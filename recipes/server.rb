#
# Author:: Jesse Nelson <spheromak@gmail.com>
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: dhcp
# Recipe:: server
#
# Copyright 2012, Jesse Nelson
# Copyright 2011, Opscode, Inc
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

# load dynadns with current context

include_recipe "git"
include_recipe "helpers-databags"
include_recipe "helpers-search::mix_recipe"
include_recipe "ruby-helper"

include_recipe "dhcp::_package"
include_recipe "dhcp::_service"

DHCP::Failover.load(node)
DHCP::DynaDns.load(node)

#
# Global DHCP config settings
#
template node[:dhcp][:config_file] do
  owner "root"
  group "root"
  mode 0644
  source "dhcpd.conf.erb"
  variables(
    :allows => node['dhcp']['allows'] || [], 
    :parameters =>  node['dhcp']['parameters'] || [],
    :options =>  node[:dhcp][:options] || [],
    :ddns => DHCP::DynaDns.rndc_keys,
    :my_ip => node[:ipaddress],
    :role => DHCP::Failover.role,
    :peer_ip => DHCP::Failover.peer,
    :failover => DHCP::Failover.enabled?
    )
  action :create
  notifies :restart, resources(:service => node[:dhcp][:service_name] ), :delayed
end

#
# Create the dirs and stub files for each resource type
#
%w{groups.d hosts.d subnets.d}.each do |dir|
  directory "#{node[:dhcp][:dir]}/#{dir}"
  file "#{node[:dhcp][:dir]}/#{dir}/list.conf" do
    action :create_if_missing
    content ""
  end
end


include_recipe  "dhcp::_networks"
include_recipe  "dhcp::_groups"
include_recipe  "dhcp::_hosts"




