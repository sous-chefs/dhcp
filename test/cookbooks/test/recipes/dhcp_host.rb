dhcp_host 'Test-IPv4-Host' do
  hostname 'test-ipv4-host'
  identifier 'hardware ethernet 00:53:00:00:00:01'
  address '192.168.0.10'
end

dhcp_host 'Test-IPv6-Host' do
  ip_version :ipv6
  hostname 'test-ipv6-host'
  identifier 'host-identifier option dhcp6.client-id 00:53:00:00:00:01:a4:65:b7:c8'
  address '2001:db8:1:1:0:0:1:10'
end
