#
# Cookbook:: dhcp_test
# Recipe:: service
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

dhcp_service 'dhcpd' do
  ip_version :ipv4
  action [:create, :enable, :start]
end

require 'socket'
ipv6_available = Socket.getifaddrs.select { |addr_info| addr_info.addr.ipv6? }.count > 0

dhcp_service 'dhcpd6' do
  ip_version :ipv6
  action ipv6_available ? [:create, :enable, :start] : [:create, :enable]
end
