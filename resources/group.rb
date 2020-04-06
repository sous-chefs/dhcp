
#
# Cookbook:: dhcp
# Resource:: group
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
          default: lazy { "#{dhcpd_config_includes_directory(ip_version)}/groups.d" }

property :cookbook, String,
          default: 'dhcp'

property :template, String,
          default: 'group.conf.erb'

property :owner, String,
          default: 'root'

property :group, String,
          default: 'root'

property :mode, String,
          default: '0640'

property :parameters, Hash

property :evals, Array

property :hosts, Hash

action :create do
  template "#{new_resource.conf_dir}/groups.d/#{new_resource.name}.conf" do
    cookbook new_resource.cookbook
    source new_resource.template

    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode

    variables(
      name: new_resource.name,
      comment: new_resource.comment,
      ip_version: new_resource.ip_version,
      parameters: new_resource.parameters,
      evals: new_resource.evals,
      hosts: new_resource.hosts
    )
    helpers(Dhcp::Template::Helpers)

    action :create
  end
end

action :delete do
  file "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    action :delete
  end
end
