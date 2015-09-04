include_attribute 'dhcp'

default['dhcp']['network_data']['192.168.9.0/24'] = {
  'id' => '192-168-9-0_24',
  'routers'     => ['192.168.9.1'],
  'address'     => '192.168.9.0',
  'netmask'     => '255.255.255.0',
  'broadcast'   => '192.168.9.255',
  'range'       => '192.168.9.50 192.168.9.240',
  'options'     => ['time-offset 10'],
  'next_server' => '192.168.9.11'
}

default['dhcp']['shared_network_data']['mysharednetwork']['subnets']['192.168.10.0/24'] = {
  'id' => '192-168-10-0_24',
  'routers'     => ['192.168.10.1'],
  'address'     => '192.168.10.0',
  'netmask'     => '255.255.255.0',
  'broadcast'   => '192.168.10.255',
  'range'       => '192.168.10.50 192.168.10.240',
  'next_server' => '192.168.10.11'
}
default['dhcp']['shared_network_data']['mysharednetwork']['subnets']['192.168.11.0/24'] = {
  'id' => '192-168-11-0_24',
  'routers'     => ['192.168.11.1'],
  'address'     => '192.168.11.0',
  'netmask'     => '255.255.255.0',
  'broadcast'   => '192.168.11.255',
  'range'       => '192.168.11.50 192.168.11.240',
  'next_server' => '192.168.11.11'
}
