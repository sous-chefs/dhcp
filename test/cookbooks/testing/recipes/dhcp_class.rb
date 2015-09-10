dhcp_class 'BlankClass' do
  match 'hardware'
end

dhcp_class 'RegisteredHosts' do
  match 'hardware'
  subclass '1:10:bf:48:42:55:01'
  subclass '1:10:bf:48:42:55:02'
end

dhcp_subnet 'deny host from class' do
  subnet '192.168.4.0'
  broadcast '192.168.4.255'
  netmask '255.255.255.0'
  routers ['192.168.4.1']
  pool do
    range '192.168.4.20 192.168.4.30'
    deny 'members of "RegisteredHosts"'
  end
end
