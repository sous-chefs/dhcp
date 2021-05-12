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

unified_mode true

include Dhcp::Cookbook::Helpers

property :ip_version, [Symbol, String],
          equal_to: [:ipv4, :ipv6, 'ipv4', 'ipv6'],
          coerce: proc { |ipv| ipv.is_a?(Symbol) ? ipv : ipv.to_sym },
          default: :ipv4,
          description: 'The IP version, 4 or 6'

property :config_file, String,
          default: lazy { dhcpd_config_file(ip_version) },
          description: 'The full path to the DHCP server configuration on disk'

property :cookbook, String,
          default: 'dhcp'

property :template, String,
          default: 'dhcpd.conf.erb'

property :owner, String,
          default: lazy { dhcpd_user }

property :group, String,
          default: lazy { dhcpd_group }

property :mode, String,
          default: '0640'

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

property :allow, Array,
          description: 'Allow access control'

property :deny, Array,
          description: 'Deny access control'

property :ignore, Array,
          description: 'Ignore access control'

property :parameters, [Hash, Array],
          description: 'Global parameters'

property :options, [Hash, Array],
          description: 'Global options'

property :evals, Array,
          description: 'Global conditional eval statements'

property :keys, Hash,
          description: 'TSIG keys'

property :zones, Hash,
          description: 'Dynamic DNS zones'

property :hooks, Hash,
          description: 'Server event action configuration'

property :failover, Hash,
          description: 'DHCP failover configuration'

property :include_files, Array,
          description: 'Additional configuration files to include'

property :extra_lines, [String, Array],
          description: 'Extra lines to append to the main configuration file'

property :env_file, String,
          default: lazy { dhcpd_env_file },
          description: 'Configuration file lines for the DHCP environment'

property :env_file_lines, [String, Array],
          description: 'Configuration file lines for the DHCP environment file'

action_class do
  include Dhcp::Cookbook::ResourceHelpers

  DHCPD_CONFIG_INCLUDES_DIRECTORIES = %w(classes.d groups.d hosts.d shared_networks.d subnets.d).freeze
end

action :create do
  raise 'DHCP failover is only supported for IPv4' if new_resource.failover && new_resource.ip_version.eql?(:ipv6)

  directory new_resource.config_includes_directory do
    owner new_resource.owner
    group new_resource.group

    action :create
  end

  DHCPD_CONFIG_INCLUDES_DIRECTORIES.each do |dir|
    directory "#{new_resource.config_includes_directory}/#{dir}" do
      owner new_resource.owner
      group new_resource.group

      action :create
    end

    init_list_resource("#{new_resource.config_includes_directory}/#{dir}")
  end

  # Pre-condition DHCPd lib directory and lease file for distros that don't take care of this
  dhcpd_lib_dir_options.each { |property, value| edit_resource(:directory, new_resource.lib_dir).send(property, value) }
  dhcpd_lease_file_options.each { |property, value| edit_resource(:file, new_resource.lease_file).send(property, value) }

  template new_resource.config_file do
    cookbook new_resource.cookbook
    source new_resource.template

    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode

    variables(
      includes_dir: dhcpd_config_includes_directory(new_resource.ip_version),
      allow: new_resource.allow,
      deny: new_resource.deny,
      ignore: new_resource.ignore,
      parameters: new_resource.parameters,
      options: new_resource.options,
      evals: new_resource.evals,
      keys: new_resource.keys,
      zones: new_resource.zones,
      hooks: new_resource.hooks,
      failover: new_resource.failover,
      include_files: new_resource.include_files,
      extra_lines: new_resource.extra_lines
    )
    helpers(Dhcp::Cookbook::TemplateHelpers)

    action :create
  end

  template new_resource.env_file do
    cookbook 'dhcp'
    source 'dhcpd-env.erb'

    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode

    variables(
      lines: new_resource.env_file_lines
    )
    helpers(Dhcp::Cookbook::TemplateHelpers)

    action :create
  end if new_resource.env_file

  if new_resource.failover
    template new_resource.config_failover_file do
      cookbook 'dhcp'
      source 'dhcpd.failover.conf.erb'

      owner new_resource.owner
      group new_resource.group
      mode new_resource.mode

      variables(
        failover: new_resource.failover
      )
      helpers(Dhcp::Cookbook::TemplateHelpers)

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
  end if new_resource.ip_version.eql?(:ipv4)
end
