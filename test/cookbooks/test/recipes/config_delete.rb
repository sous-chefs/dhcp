#
# Cookbook:: dhcp_test
# Recipe:: config_delete
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

dhcp_config '/etc/dhcp/dhcpd6.conf' do
  ip_version :ipv6
  action :delete
  notifies :stop, 'dhcp_service[dhcpd6]', :delayed
  notifies :disable, 'dhcp_service[dhcpd6]', :delayed
end

dhcp_host 'Test-IPv6-Host' do
  ip_version :ipv6
  action :delete
end

dhcp_subnet 'overrides' do
  conf_dir '/etc/dhcp_override'
  action :delete
  notifies :restart, 'dhcp_service[dhcpd]', :delayed
end

dhcp_subnet 'overrides' do
  action :delete
  notifies :restart, 'dhcp_service[dhcpd]', :delayed
end

dhcp_subnet 'deny host from class' do
  action :delete
  notifies :restart, 'dhcp_service[dhcpd]', :delayed
end

dhcp_class 'UnregisteredHosts' do
  action :delete
  notifies :restart, 'dhcp_service[dhcpd]', :delayed
end
