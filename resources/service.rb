# frozen_string_literal: true

#
# Cookbook:: dhcp
# Resource:: service
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

provides :dhcp_service
unified_mode true

include Dhcp::Cookbook::Helpers

use '_partial/_ip_version'

property :service_name, String,
          coerce: proc { |p| "#{p.delete_suffix('.service')}.service" },
          default: lazy { dhcpd_service_name(ip_version) },
          description: 'Override the default service names'

property :systemd_unit_content, [String, Hash],
          default: lazy { dhcpd_systemd_unit_content(ip_version, config_file) },
          description: 'Override the systemd unit file contents'

property :config_file, String,
          default: lazy { dhcpd_config_file(ip_version) },
          description: 'The full path to the DHCP server configuration on disk'

property :config_test, [true, false],
          default: true,
          description: 'Perform configuration file test before performing service action'

property :config_test_fail_action, Symbol,
          equal_to: %i(raise log),
          default: :raise,
          description: 'Action to perform upon configuration test failure.'

action_class do
  def service_present_or_enabled?
    return true if ::File.exist?("/etc/systemd/system/#{new_resource.service_name}")

    %w(is-active is-enabled).any? do |predicate|
      shell_out('systemctl', predicate, '--quiet', new_resource.service_name).exitstatus.zero?
    end
  end

  def configuration_valid?
    return false unless ::File.exist?(new_resource.config_file)
    return true unless new_resource.config_test

    command = Mixlib::ShellOut.new(dhcpd_config_test_command(new_resource.ip_version, new_resource.config_file), user: dhcpd_user)
    command.run_command.error!
    true
  rescue Mixlib::ShellOut::ShellCommandFailed
    message = "Configuration test failed, #{new_resource.service_name} action aborted!\n\n#{command.stderr}"
    raise message unless new_resource.config_test_fail_action == :log

    Chef::Log.error(message)
    false
  end

  def do_service_action(resource_action)
    provider = self
    resource_type = dhcpd_use_systemd? ? :systemd_unit : :service
    resource_name = dhcpd_use_systemd? ? new_resource.service_name : new_resource.service_name.delete_suffix('.service')
    with_run_context(:root) do
      declare_resource(resource_type, resource_name) do
        only_if { provider.configuration_valid? } if %i(start restart reload).include?(resource_action)
        action :nothing
        delayed_action(resource_action)
      end
    end
  end
end

action :create do
  with_run_context(:root) do
    systemd_unit new_resource.service_name do
      content new_resource.systemd_unit_content
      triggers_reload true
      verify false
      action :create
    end
  end if dhcpd_use_systemd?
end

action :delete do
  if dhcpd_use_systemd?
    provider = self
    systemd_unit new_resource.service_name do
      action [:stop, :disable, :delete]
      only_if { provider.service_present_or_enabled? }
    end
  else
    service new_resource.service_name.delete_suffix('.service') do
      action [:stop, :disable]
    end
  end
end

%i(start stop restart reload enable disable).each do |action_type|
  action(action_type) { do_service_action(action_type) }
end
