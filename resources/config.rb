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
include Dhcp::Template::Helpers

property :ip_version, Symbol,
          equal_to: %i(ipv4 ipv6),
          default: :ipv4,
          description: 'The IP version, 4 or 6'

property :config_file, String,
          default: lazy { dhcpd_config_file(ip_version) },
          description: 'The full path to the DHCP server configuration on disk'

property :cookbook, String,
          default: 'dhcp'

property :template, String,
          default: 'dhcpd.conf.erb'

property :config_failover_file, String,
          default: lazy { dhcpd_failover_config_file(ip_version) },
          description: 'The full path to the DHCP server failover configuration on disk'

property :config_includes_directory, String,
          default: lazy { dhcpd_config_includes_directory(ip_version) }

property :lib_dir, String,
          default: lazy { dhcpd_lib_dir },
          description: 'The full path to the DHCP lib directory on disk'

property :lease_file, String,
          default: lazy { dhcpd_lease_file(ip_version) },
          description: 'The full path to the DHCP server leases file on disk'

property :allow, Array

property :deny, Array

property :ignore, Array

property :parameters, Hash,
          description: 'Global parameters'

property :options, Hash,
          description: 'Global options'

property :keys, Hash,
          description: 'TSIG keys'

property :zones, Hash,
          description: 'Dynamic DNS zone configuration'

property :failover, Hash,
          description: 'DHCP failover configuration'

property :include_files, Array,
          description: 'Additional configuration files to include'

property :extra_lines, [String, Array],
          description: 'Extra lines to append to the main configuration file'

action :create do
  case new_resource.ip_version
  # when :ipv4
  #   raise 'netmask is a required property for IPv4' unless new_resource.netmask
  when :ipv6
    raise 'DHCP failover is only supported for IPv4' if new_resource.failover
  end

  directory new_resource.config_includes_directory

  %w(groups.d hosts.d subnets.d shared_networks.d classes.d).each do |dir|
    directory "#{new_resource.config_includes_directory}/#{dir}" do
      action :create
    end

    with_run_context(:root) do
      edit_resource(:template, "#{new_resource.config_includes_directory}/#{dir}/list.conf") do
        cookbook 'dhcp'
        source 'list.conf.erb'

        variables['files'] ||= []

        action :nothing
        delayed_action :create
      end
    end
  end

  # Pre-condition DHCPd lib directory and lease file for distros that don't take care of this
  dhcpd_lib_dir_options.each { |property, value| edit_resource(:directory, new_resource.lib_dir).send(property, value) }
  dhcpd_lease_file_options.each { |property, value| edit_resource(:file, new_resource.lease_file).send(property, value) }

  template new_resource.config_file do
    cookbook new_resource.cookbook
    source new_resource.template

    owner 'root'
    group 'dhcpd'
    mode '0640'

    variables(
      includes_dir: dhcpd_config_includes_directory(new_resource.ip_version),
      allow: new_resource.allow,
      deny: new_resource.deny,
      ignore: new_resource.ignore,
      parameters: new_resource.parameters,
      options: new_resource.options,
      keys: new_resource.keys,
      zones: new_resource.zones,
      failover: new_resource.failover,
      include_files: new_resource.include_files,
      extra_lines: new_resource.extra_lines
    )
    helpers(Dhcp::Template::Helpers)

    action :create
  end

  unless nil_or_empty?(new_resource.failover)
    template new_resource.config_failover_file do
      cookbook 'dhcp'
      source 'dhcpd.failover.conf.erb'

      owner 'root'
      group 'root'
      mode '0640'

      variables(
        failover: new_resource.failover
      )
      helpers(Dhcp::Template::Helpers)

      action :create
    end
  end
end

action :delete do
  %w(config_file config_failover_file).each do |file|
    file new_resource.send(file) do
      action :delete
    end
  end
end
