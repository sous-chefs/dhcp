#
# Cookbook:: dhcp
# Resource:: subnet
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

property :comment, String,
          description: 'Unparsed comment to add to the configuration file'

property :ip_version, [Symbol, String],
          equal_to: [:ipv4, :ipv6, 'ipv4', 'ipv6'],
          coerce: proc { |ipv| ipv.is_a?(Symbol) ? ipv : ipv.to_sym },
          default: :ipv4,
          description: 'The IP version, 4 or 6'

property :conf_dir, String,
          default: lazy { dhcpd_config_resource_directory(ip_version, declared_type) },
          description: 'Directory to create configuration file in'

property :cookbook, String,
          default: 'dhcp',
          description: 'Template source cookbook'

property :template, String,
          default: lazy {
            case ip_version
            when :ipv4
              'subnet.conf.erb'
            when :ipv6
              'subnet6.conf.erb'
            end
          },
          description: 'Template source file'

property :owner, String,
          default: lazy { dhcpd_user },
          description: 'Generated file owner'

property :group, String,
          default: lazy { dhcpd_group },
          description: 'Generated file group'

property :mode, String,
          default: '0640',
          description: 'Generated file mode'

property :shared_network, [true, false],
          default: false,
          description: 'Flag to indicate subnet is used inside a shared_network resource and should not be added to list.conf'

property :subnet, String,
          name_property: true,
          description: 'Subnet network address'

property :netmask, String,
          description: 'Subnet network mask, required for IPv4'

property :prefix, Integer,
          description: 'Subnet network prefix, required for IPv6'

property :parameters, [Hash, Array],
          description: 'Subnet configuration parameters'

property :options, [Hash, Array],
          description: 'Subnet options'

property :evals, Array,
          description: 'Subnet conditional eval statements'

property :key, Hash,
          description: 'Subnet TSIG keys'

property :zones, Hash,
          description: 'Subnet dynamic DNS zones'

property :allow, Array,
          description: 'Subnet allow access control'

property :deny, Array,
          description: 'Subnet deny access control'

property :extra_lines, Array,
          description: 'Subnet additional configuration lines'

property :pools, [Hash, Array],
          description: 'Subnet pool(s) configuration'

property :range, [String, Array]

action_class do
  include Dhcp::Cookbook::ResourceHelpers
end

action :create do
  case new_resource.ip_version
  when :ipv4
    raise 'netmask is a required property for IPv4' unless new_resource.netmask
  when :ipv6
    raise 'prefix is a required property for IPv6' unless new_resource.prefix
  end

  template "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    cookbook new_resource.cookbook
    source new_resource.template

    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode

    variables(
      name: new_resource.name,
      comment: new_resource.comment,
      subnet: new_resource.subnet,
      netmask: new_resource.netmask,
      prefix: new_resource.prefix,
      parameters: new_resource.parameters,
      options: new_resource.options,
      evals: new_resource.evals,
      key: new_resource.key,
      zones: new_resource.zones,
      allow: new_resource.allow,
      deny: new_resource.deny,
      extra_lines: new_resource.extra_lines,
      pools: new_resource.pools,
      range: new_resource.range
    )
    helpers(Dhcp::Cookbook::TemplateHelpers)

    action :create
  end

  add_to_list_resource(new_resource.conf_dir, "#{new_resource.conf_dir}/#{new_resource.name}.conf") unless new_resource.shared_network
end

action :delete do
  file "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    action :delete
  end

  remove_from_list_resource(new_resource.conf_dir, "#{new_resource.conf_dir}/#{new_resource.name}.conf") unless new_resource.shared_network
end
