#
# Author:: Jacob McCann (<jacob.mccann2@target.com>)
# Cookbook:: dhcp
# Resource:: shared_network
#
# Copyright:: 2015-2018, Sous Chefs
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
          default: lazy { "#{dhcpd_config_includes_directory(ip_version)}/hosts.d" }

property :cookbook, String,
          default: 'dhcp'

property :template, String,
          default: 'class.conf.erb'

property :owner, String,
          default: 'root'

property :group, String,
          default: 'root'

property :mode, String,
          default: '0640'

property :subnets, Hash

# attr_accessor :subnets

# def subnet(name, &block)
#   @subnets ||= []
#   s = dhcp_subnet("#{@name}-#{name}", &block)
#   s.action :nothing
#   s.subnet name
#   @subnets << s
#   s
# end

action :create do
  template "#{new_resource.conf_dir}/shared_networks.d/#{new_resource.name}.conf" do
    cookbook 'dhcp'
    source 'shared_network.conf.erb'
    variables name: new_resource.name, subnets: new_resource.subnets
    owner 'root'
    group 'root'
    mode '0644'
  end
end

action :delete do
  file "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    action :delete
  end
end
