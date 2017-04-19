default['dhcp']['network_data']['192.168.12.0/24'] = {
  'id' => '192-168-12-0_24',
  'routers'     => ['192.168.12.1'],
  'address'     => '192.168.12.0',
  'netmask'     => '255.255.255.0',
  'broadcast'   => '192.168.12.255',
  'range'       => '192.168.12.50 192.168.12.240',
  'options'     => ['time-offset 10'],
  'next_server' => '192.168.12.11',
}

default['dhcp']['shared_network_data']['mysharedattrnetwork']['subnets']['192.168.13.0/24'] = {
  'id' => '192-168-13-0_24',
  'routers'     => ['192.168.13.1'],
  'address'     => '192.168.13.0',
  'netmask'     => '255.255.255.0',
  'broadcast'   => '192.168.13.255',
  'range'       => '192.168.13.50 192.168.13.240',
  'next_server' => '192.168.13.11',
}
default['dhcp']['shared_network_data']['mysharedattrnetwork']['subnets']['192.168.14.0/24'] = {
  'id' => '192-168-14-0_24',
  'routers'     => ['192.168.14.1'],
  'address'     => '192.168.14.0',
  'netmask'     => '255.255.255.0',
  'broadcast'   => '192.168.14.255',
  'range'       => '192.168.14.50 192.168.14.240',
  'next_server' => '192.168.14.11',
}
