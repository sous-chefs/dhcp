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
include Dhcp::Cookbook::Helpers

property :ip_version, Symbol,
          equal_to: %i(ipv4 ipv6),
          default: :ipv4,
          description: 'The IP version, 4 or 6'

property :service_name, String,
          coerce: proc { |s| "#{s}.service" },
          description: 'Override the default service names'

property :systemd_unit_content, [String, Hash],
          default: lazy { dhcpd_systemd_unit_content(ip_version) },
          description: 'Override the systemd unit file contents'

action_class do
  def service_name
    if new_resource.service_name
      new_resource.service_name
    else
      dhcpd_service_name(new_resource.ip_version)
    end
  end

  def do_service_action(resource_action)
    with_run_context(:root) do
      edit_resource(:service, service_name) do
        delayed_action resource_action
      end
    end
  end
end

action :create do
  with_run_context :root do
    edit_resource(:systemd_unit, "#{service_name}.service") do |new_resource|
      content new_resource.dhcpd_systemd_unit_content(new_resource.ip_version)
      triggers_reload true
      verify false

      action :create
    end if dhcpd_use_systemd?
  end
end

action :delete do
  do_service_action([:stop, :disable])
  with_run_context :root do
    edit_resource(:systemd_unit, "#{service_name}.service").action(:delete) if dhcpd_use_systemd?
  end
end

action :start do
  do_service_action(action)
end

action :stop do
  do_service_action(action)
end

action :reload do
  do_service_action(action)
end

action :enable do
  do_service_action(action)
end

action :disable do
  do_service_action(action)
end
