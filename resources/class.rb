#
# Cookbook:: dhcp
# Resource:: class
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
          default: lazy { dhcpd_config_resource_directory(ip_version, declared_type) },
          description: 'Directory to create configuration file in'

property :cookbook, String,
          default: 'dhcp',
          description: 'Template source cookbook'

property :template, String,
          default: 'class.conf.erb',
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

property :match, String,
          description: 'Client match statement'

property :parameters, [Hash, Array],
          description: 'Class client parameters'

property :options, [Hash, Array],
          description: 'Class client options'

property :subclass, Array,
          description: 'Class subclass match statements'

action_class do
  include Dhcp::Cookbook::ResourceHelpers
end

action :create do
  template "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    cookbook new_resource.cookbook
    source new_resource.template

    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode

    variables(
      name: new_resource.name,
      comment: new_resource.comment,
      match: new_resource.match,
      parameters: new_resource.parameters,
      options: new_resource.options,
      subclasses: new_resource.subclass
    )
    helpers(Dhcp::Cookbook::TemplateHelpers)

    action :create
  end

  add_to_list_resource(new_resource.conf_dir, "#{new_resource.conf_dir}/#{new_resource.name}.conf")
end

action :delete do
  file "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    action :delete
  end
end
