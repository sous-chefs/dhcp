#
# Cookbook:: dhcp_test
# Recipe:: config
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

dhcp_config '/etc/dhcp/dhcpd.conf' do
  allow %w(booting bootp unknown-clients)
  parameters(
    'default-lease-time' => 7200,
    'ddns-update-style' => 'interim',
    'max-lease-time' => 86400,
    'update-static-leases' => true,
    'one-lease-per-client' => true,
    'authoritative' => '',
    'ping-check' => true
  )
  options(
    'domain-name' => 'test.domain.local',
    'domain-name-servers' => '8.8.8.8',
    'host-name' => ' = binary-to-ascii (16, 8, "-", substring (hardware, 1, 6))'
  )
  action :create
end

dhcp_config '/etc/dhcp/dhcpd6.conf' do
  ip_version :ipv6
  deny %w(duplicates)
  parameters(
    'default-lease-time' => 7200,
    'ddns-updates' => 'on',
    'ddns-update-style' => 'interim',
    'max-lease-time' => 86400,
    'update-static-leases' => true,
    'one-lease-per-client' => 'on',
    'authoritative' => '',
    'ping-check' => true
  )
  options(
    'dhcp6.name-servers' => '2001:4860:4860::8888, 2001:4860:4860::8844'
  )
  action :create
end
