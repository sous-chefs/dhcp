# frozen_string_literal: true

#
# Cookbook:: dhcp
# Resource:: host
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

provides :dhcp_host
unified_mode true

include Dhcp::Cookbook::Helpers

use '_partial/_ip_version'
use '_partial/_fragment'

property :template, String,
          default: 'host.conf.erb',
          description: 'Template source file'

property :group_host, [true, false],
          default: false,
          description: 'Flag to indicate host is used inside a group resource and should not be added to list.conf'

property :identifier, String,
          description: 'Host identifier, usually MAC or DHCID'

property :address, String,
          description: 'Host assigned address'

property :parameters, [Hash, Array],
          description: 'Host parameters'

property :options, [Hash, Array],
          description: 'Host options'

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
      ip_version: new_resource.ip_version,
      identifier: new_resource.identifier,
      address: new_resource.address,
      parameters: new_resource.parameters,
      options: new_resource.options
    )
    helpers(Dhcp::Cookbook::TemplateHelpers)

    action :create
  end

  add_to_list_resource(new_resource.conf_dir, "#{new_resource.conf_dir}/#{new_resource.name}.conf") unless new_resource.group_host
end

action :delete do
  file "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    action :delete
  end

  remove_from_list_resource(new_resource.conf_dir, "#{new_resource.conf_dir}/#{new_resource.name}.conf") unless new_resource.group_host
end
