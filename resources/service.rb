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

unified_mode true

include Dhcp::Cookbook::Helpers

property :ip_version, [Symbol, String],
          equal_to: [:ipv4, :ipv6, 'ipv4', 'ipv6'],
          coerce: proc { |p| p.is_a?(Symbol) ? p : p.to_sym },
          default: :ipv4,
          description: 'The IP version, 4 or 6'

property :service_name, String,
          coerce: proc { |p| "#{p}.service" },
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
  def do_service_action(resource_action)
    with_run_context(:root) do
      if %i(start restart reload).include?(resource_action)
        declare_resource(:ruby_block, "Run pre #{new_resource.service_name} #{resource_action} configuration test") do
          block do
            begin
              if new_resource.config_test
                cmd = Mixlib::ShellOut.new(dhcpd_config_test_command(new_resource.ip_version, new_resource.config_file))
                cmd.user = dhcpd_user
                cmd.run_command.error!
                Chef::Log.info("Configuration test passed, creating #{new_resource.service_name} #{new_resource.declared_type} resource with action #{resource_action}")
              else
                Chef::Log.info("Configuration test disabled, creating #{new_resource.service_name} #{new_resource.declared_type} resource with action #{resource_action}")
              end

              declare_resource(:service, new_resource.service_name.delete_suffix('.service')) { delayed_action(resource_action) }
            rescue Mixlib::ShellOut::ShellCommandFailed
              if new_resource.config_test_fail_action.eql?(:log)
                Chef::Log.error("Configuration test failed, #{new_resource.service_name} #{resource_action} action aborted!\n\n"\
                                "Error\n-----\n#{cmd.stderr}")
              else
                raise "Configuration test failed, #{new_resource.service_name} #{resource_action} action aborted!\n\n"\
                      "Error\n-----\nAction: #{resource_action}\n#{cmd.stderr}"
              end
            end
          end

          only_if { ::File.exist?(new_resource.config_file) }

          action :nothing
          delayed_action :run
        end
      else
        declare_resource(:service, new_resource.service_name.delete_suffix('.service')) { delayed_action(resource_action) }
      end
    end
  end
end

action :create do
  with_run_context :root do
    declare_resource(:systemd_unit, new_resource.service_name) do
      content new_resource.systemd_unit_content
      triggers_reload true
      verify false

      action :create
    end if dhcpd_use_systemd?
  end
end

action :delete do
  do_service_action([:stop, :disable])
  with_run_context :root do
    declare_resource(:systemd_unit, new_resource.service_name) { action(:delete) } if dhcpd_use_systemd?
  end
end

%i(start stop restart reload enable disable).each do |action_type|
  send(:action, action_type) { do_service_action(action) }
end
