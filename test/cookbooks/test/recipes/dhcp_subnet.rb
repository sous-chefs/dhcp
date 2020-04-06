# Define using defaults
dhcp_subnet '192.168.9.0' do
  comment 'Listen Subnet Declaration'
  subnet '192.168.9.0'
  netmask '255.255.255.0'
end

# Basic definition
dhcp_subnet 'basic' do
  comment 'Basic Subnet Declaration'
  subnet '192.168.0.0'
  netmask '255.255.255.0'
  options [
    'routers 192.168.0.1',
    'time-offset 10',
  ]
  pool 'range' => '192.168.0.100 192.168.0.200'
end

directory '/etc/dhcp_override'

# Override everything
dhcp_subnet 'overrides' do
  comment 'Overrides Subnet Declaration'
  subnet '192.168.1.0'
  netmask '255.255.255.0'
  options [
    'routers 192.168.1.1',
    'time-offset 10',
    'broadcast-address 192.168.0.255',
  ]
  pool(
    'peer' => '192.168.0.2',
    'range' => '192.168.1.100 192.168.1.200',
    'deny' => 'members of "RegisteredHosts"',
    'allow' => ['members of "UnregisteredHosts"', 'members of "OtherHosts"']
  )
  parameters(
    'ddns-domainname' => '"test.com"',
    'next-server' => '192.168.0.3'
  )
  evals [ 'if exists user-class and option user-class = "iPXE" {
    filename "bootstrap.ipxe";
  } else {
    filename "undionly.kpxe";
  }' ]
  key 'name' => 'test_key', 'algorithm' => 'hmac-sha256', 'secret' => 'c7nBOcB2rbJh7lYCI65/PGrS6QdlLMCPe2xunZ4dij8='
  zones [{ 'zone' => 'test', 'primary' => 'test_pri', 'key' => 'test_key' }]
  conf_dir '/etc/dhcp_override'
end

# DHCPv6 listen subnet
dhcp_subnet 'dhcpv6_listen' do
  ip_version :ipv6
  comment 'Testing DHCPv6 Basic Subnet'
  subnet '2001:db8:2::'
  prefix 64
end

# DHCPv6 basic subnet
dhcp_subnet 'dhcpv6_basic' do
  ip_version :ipv6
  comment 'Testing DHCPv6 Basic Subnet'
  subnet '2001:db8:1:1::'
  prefix 64
  options(
    'domain-name' => '"test.domain.local"',
    'dhcp6.name-servers' => '2001:4860:4860::8888, 2001:4860:4860::8844'
  )
  parameters(
    'ddns-domainname' => '"test.domain.local"',
    'default-lease-time' => 28800
  )
  range [
    '2001:db8:1:1::1:0/112',
  ]
end
