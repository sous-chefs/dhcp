# Define using defaults
dhcp_subnet '10.0.2.0' do
  netmask '255.255.254.0' # Requried attribute
end

# Override everything
dhcp_subnet 'overrides' do
  subnet '192.168.0.0'
  broadcast '192.168.0.255'
  netmask '255.255.255.0'
  routers ['192.168.0.1']
  options ['time-offset 10']
  range '192.168.0.100 192.168.0.200'
  ddns 'test.com'
  peer '192.168.0.2'
  evals [%q(
    if exists user-class and option user-class = "iPXE" {
      filename "bootstrap.ipxe";
    } else {
      filename "undionly.kpxe";
    })]
  key 'name' => 'test_key', 'algorithm' => 'test_algo', 'secret' => 'test_secret'
  zones [{ 'zone' => 'test', 'primary' => 'test_pri', 'key' => 'test_key' }]
  conf_dir '/etc/dhcp_override'
  next_server '192.168.0.3'
end
