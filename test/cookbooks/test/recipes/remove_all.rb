# frozen_string_literal: true

%i(ipv4 ipv6).each do |ip_version|
  dhcp_service "remove #{ip_version}" do
    ip_version ip_version
    action :delete
  end
end

%w(BlankClass RegisteredHosts UnregisteredHosts OtherHosts).each do |class_name|
  dhcp_class class_name do
    action :delete
  end
end

dhcp_host 'Test-IPv4-Host' do
  action :delete
end

dhcp_host 'Test-IPv6-Host' do
  ip_version :ipv6
  action :delete
end

['192.168.9.0', 'basic', 'overrides', 'deny host from class'].each do |subnet|
  dhcp_subnet subnet do
    action :delete
  end
end

dhcp_subnet 'overrides' do
  conf_dir '/etc/dhcp/override'
  action :delete
end

%w(dhcpv6_listen dhcpv6_basic).each do |subnet|
  dhcp_subnet subnet do
    ip_version :ipv6
    action :delete
  end
end

dhcp_group 'ip-phones' do
  hosts 'SEP010101010101' => {}
  action :delete
end

dhcp_shared_network 'single' do
  subnets '192.168.1.0' => {}
  action :delete
end

dhcp_shared_network 'multiple' do
  subnets '192.168.2.0' => {}, '192.168.3.0' => {}
  action :delete
end

%i(ipv4 ipv6).each do |ip_version|
  dhcp_config "remove #{ip_version}" do
    ip_version ip_version
    action :delete
  end
end

dhcp_package 'Server Test' do
  action :remove
end
