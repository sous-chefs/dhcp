
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

property :ip_version, Symbol,
          equal_to: %i(ipv4 ipv6),
          default: :ipv4,
          description: 'The IP version, 4 or 6'

property :conf_dir, String,
          default: lazy { "#{dhcpd_config_includes_directory(ip_version)}/subnets.d" }

property :cookbook, String,
          default: 'dhcp'

property :template, String,
          default: lazy {
            case ip_version
            when :ipv4
              'subnet.conf.erb'
            when :ipv6
              'subnet6.conf.erb'
            end
          }

property :subnet, String,
          required: true,
          description: 'Subnet network address'

property :netmask, String,
          description: 'Subnet network mask, required for IPv4'

property :prefix, Integer,
          description: 'Subnet network prefix, required for IPv6'

property :options, [Hash, Array],
          description: 'Subnet options'

property :parameters, Hash,
          description: 'Subnet configuration parameters'

property :evals, Array
property :key, Hash
property :zones, Array

property :allow, Array

property :deny, Array

property :extra_lines, Hash,
          description: 'Subnet additional configuration lines'

property :pool, [Hash, Array],
          callbacks: {
            'Pool requires range be specified' => proc { |p| p.key?('range') },
            'Pool options should be an Array' => proc { |p| p['options'].is_a?(Array) || !p.key?('options') },
            'Pool parameters should be a Hash' => proc { |p| p['parameters'].is_a?(Hash) || !p.key?('parameters') },
          }

property :range, [String, Array]

action :create do
  case new_resource.ip_version
  when :ipv4
    raise 'netmask is a required property for IPv4' unless new_resource.netmask
  when :ipv6
    raise 'prefix is a required property for IPv6' unless new_resource.prefix
    raise 'range is a required property for IPv6' unless new_resource.range
  end

  template "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    cookbook new_resource.cookbook
    source new_resource.template

    owner 'root'
    group 'root'
    mode '0644'

    variables(
      name: new_resource.name,
      comment: new_resource.comment,
      subnet: new_resource.subnet,
      netmask: new_resource.netmask,
      prefix: new_resource.prefix,
      options: new_resource.options,
      parameters: new_resource.parameters,
      evals: new_resource.evals,
      key: new_resource.key,
      zones: new_resource.zones,
      allow: new_resource.allow,
      deny: new_resource.deny,
      extra_lines: new_resource.extra_lines,
      pool: new_resource.pool,
      range: new_resource.range
    )
    helpers(Dhcp::Template::Helpers)

    action :create
  end

  with_run_context :root do
    edit_resource!(:template, "#{new_resource.conf_dir}/list.conf") do |new_resource|
      variables['files'].push("#{new_resource.conf_dir}/#{new_resource.name}.conf")
    end
  end
end

action :delete do
  file "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    action :delete
  end
end
