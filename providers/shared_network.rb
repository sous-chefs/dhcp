#
# Author:: Jacob McCann (<jacob.mccann2@target.com>)
# Cookbook:: dhcp
# Provider:: dhcp_shared_subnet
#
# Copyright:: 2015-2017, Sous Chefs
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

include Dhcp::Helpers

action :add do
  run_context.include_recipe 'dhcp::_service'

  directory "#{new_resource.conf_dir}/shared_networks.d #{new_resource.name}" do
    path "#{new_resource.conf_dir}/shared_networks.d"
  end

  template "#{new_resource.conf_dir}/shared_networks.d/#{new_resource.name}.conf" do
    cookbook 'dhcp'
    source 'shared_network.conf.erb'
    variables name: new_resource.name, subnets: new_resource.subnets
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
  end

  write_include 'shared_networks.d', new_resource.name
end

action :remove do
  file "#{new_resource.conf_dir}/shared_networks.d/#{new_resource.name}.conf" do
    action :delete
    notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
    notifies :send_notification, new_resource, :immediately
  end
  write_include 'shared_networks.d', new_resource.name
end
