# frozen_string_literal: true

#
# Cookbook:: dhcp
# Resource:: shared_network
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

provides :dhcp_shared_network
unified_mode true

include Dhcp::Cookbook::Helpers

use '_partial/_ip_version'
use '_partial/_fragment'

property :template, String,
          default: 'shared_network.conf.erb',
          description: 'Template source file'

property :subnets, Hash,
          description: 'Shared subnets configuration hash'

action_class do
  include Dhcp::Cookbook::ResourceHelpers
end

action :create do
  subnets_include = []

  new_resource.subnets.each do |subnet, properties|
    declare_resource(:dhcp_subnet, "#{new_resource.name}_sharedsubnet_#{subnet}") do
      owner new_resource.owner
      group new_resource.group
      mode new_resource.mode

      ip_version new_resource.ip_version
      conf_dir new_resource.conf_dir
      shared_network true

      properties.each { |property, value| send(property, value) }
    end

    subnets_include.push("#{new_resource.conf_dir}/#{new_resource.name}_sharedsubnet_#{subnet}.conf")
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
      subnets: subnets_include
    )
    helpers(Dhcp::Cookbook::TemplateHelpers)

    action :create
  end

  add_to_list_resource(new_resource.conf_dir, "#{new_resource.conf_dir}/#{new_resource.name}.conf")
end

action :delete do
  (new_resource.subnets || {}).each_key do |subnet|
    dhcp_subnet "#{new_resource.name}_sharedsubnet_#{subnet}" do
      ip_version new_resource.ip_version
      conf_dir new_resource.conf_dir
      shared_network true
      action :delete
    end
  end

  file "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    action :delete
  end

  remove_from_list_resource(new_resource.conf_dir, "#{new_resource.conf_dir}/#{new_resource.name}.conf")
end
