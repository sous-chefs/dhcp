#
# Cookbook:: dhcp
# Resource:: config
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

property :config_file, String,
          default: lazy { dhcpd_config_file(ip_version) },
          description: 'The full path to the DHCP server configuration on disk'

property :config_failover_file, String,
          default: lazy { dhcpd_failover_config_file(ip_version) },
          description: 'The full path to the DHCP server failover configuration on disk'

property :config_includes_directory, String,
          default: lazy { dhcpd_config_includes_directory(ip_version) }

property :lease_file, String,
          default: lazy { dhcpd_lease_file(ip_version) },
          description: 'The full path to the DHCP server leases file on disk'

property :allow, Array,
          default: []

property :deny, Array,
          default: []

property :ignore, Array,
          default: []

property :parameters, Hash,
          default: {},
          description: 'Global parameters'

property :options, Hash,
          default: {},
          description: 'Global options'

property :keys, Hash,
          default: {},
          description: 'TSIG keys'

property :zones, Hash,
          default: {},
          description: 'Dynamic DNS zone configuration'

property :failover, Hash,
          default: {},
          description: 'DHCP failover configuration'

action :create do
  directory new_resource.config_includes_directory

  %w(groups.d hosts.d subnets.d shared_networks.d classes.d).each do |dir|
    directory "#{new_resource.config_includes_directory}/#{dir}" do
      action :create
    end

    with_run_context(:root) do
      edit_resource(:template, "#{new_resource.config_includes_directory}/#{dir}/list.conf") do
        cookbook 'dhcp'
        source 'config/list.conf.erb'

        variables['files'] ||= []

        action :nothing
        delayed_action :create
      end
    end
  end

  file new_resource.lease_file do
    owner 'dhcpd'
    group 'dhcpd'
    mode '0644'

    action :create_if_missing
  end

  template new_resource.config_file do
    cookbook 'dhcp'
    source 'dhcpd.conf.erb'

    owner 'root'
    group 'root'
    mode '0755'

    variables(
      allow: new_resource.allow,
      deny: new_resource.deny,
      ignore: new_resource.ignore,
      parameters: new_resource.parameters,
      options: new_resource.options,
      keys: new_resource.keys,
      zones: new_resource.zones,
      failover: !new_resource.failover.empty?
    )

    action :create
  end

  unless new_resource.failover.empty?
    template new_resource.config_failover_file do
      cookbook 'dhcp'
      source 'dhcpd.failover.conf.erb'

      owner 'root'
      group 'root'
      mode '0755'

      variables(
        failover: new_resource.failover
      )

      action :create
    end
  end
end

action :delete do
  file new_resource.config_file do
    action :delete
  end

  file new_resource.config_failover_file do
    action :delete
  end
end
