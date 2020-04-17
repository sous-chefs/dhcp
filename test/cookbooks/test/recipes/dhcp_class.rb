dhcp_class 'BlankClass' do
  match 'hardware'
end

dhcp_class 'RegisteredHosts' do
  match 'hardware'
  subclass [
    '1:10:bf:48:42:55:01',
    '1:10:bf:48:42:55:02',
  ]
end

dhcp_class 'UnregisteredHosts' do
  match 'hardware'
  subclass [
    '1:10:bf:48:42:55:03',
    '1:10:bf:48:42:55:04',
  ]
  options(
    'domain-name-servers' => '8.8.8.8'
  )
end

dhcp_class 'OtherHosts' do
  match 'hardware'
  subclass [
    '1:10:bf:48:42:55:05',
    '1:10:bf:48:42:55:06',
  ]
end

dhcp_subnet 'deny host from class' do
  subnet '192.168.4.0'
  netmask '255.255.255.0'
  options(
    'broadcast-address' => '192.168.4.255',
    'routers' => '192.168.4.1'
  )
  pools(
    'range' => '192.168.4.20 192.168.4.30',
    'deny' => 'members of "RegisteredHosts"',
    'allow' => 'members of "UnregisteredHosts"'
  )
end
