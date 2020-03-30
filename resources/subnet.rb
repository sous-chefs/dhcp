
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

property :subnet, String, name_property: true
property :broadcast, String
property :netmask, String, required: true
property :routers, Array, default: []
property :options, Array, default: []
property :ddns, String
property :evals, Array, default: []
property :key, Hash, default: {}
property :zones, Array, default: []
property :conf_dir, String, default: '/etc/dhcp'
property :next_server, String

attr_accessor :pools

def pool(&block)
  @pools ||= []
  p = dhcp_pool("#{@name}-pool#{@pools.count}", &block)
  p.action :nothing
  @pools << p
  p
end

action :add do
  template "#{new_resource.conf_dir}/subnets.d/#{new_resource.name}.conf" do
    cookbook 'dhcp'
    source 'subnet.conf.erb'
    variables(
      subnet: new_resource.subnet,
      netmask: new_resource.netmask,
      broadcast: new_resource.broadcast,
      pools: new_resource.pools,
      routers: new_resource.routers,
      options: new_resource.options,
      evals: new_resource.evals,
      key: new_resource.key,
      zones: new_resource.zones,
      ddns: new_resource.ddns,
      next_server: new_resource.next_server
    )
    owner 'root'
    group 'root'
    mode '0644'
  end
end

# action :remove do
#   with_run_context :root do
#     file "#{new_resource.conf_dir}/subnets.d/#{new_resource.name}.conf" do
#       action :delete
#       notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
#       notifies :send_notification, new_resource, :immediately
#     end

#     write_include 'subnets.d', new_resource.name
#   end
# end
