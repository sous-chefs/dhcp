# encoding: UTF-8
# Example Attribute driven  wrapper recipe
# There is more examples here https://github.com/sous-chefs/dhcp/blob/master/spec/_networks_spec.rb

node.default['dhcp']['options']['domain-name'] = '"dev.f00bar.com"'
node.default['dhcp']['options']['domain-name-servers'] = '10.33.87.98, 10.33.87.99'
node.default['dhcp']['options']['domain-search'] = '"dev.f00bar.com","f00bar.com"'
# rubocop:enable All

include_recipe 'dhcp::_package'
include_recipe 'dhcp::_service'
include_recipe 'dhcp::_config'

rndc_key = {
  'name' => 'dev.f00bar.com',
  'algorithm' => 'hmac-md5',
  'secret' => 'CHANGETHISYOURSELF',
}

dns_zones = [
  {
    'zone' => 'dev.f00bar.com',
    'primary' => 'ns01.dev.f00bar.com',
    'key' => 'dev.f00bar.com',
  },
  {
    'zone' => '0.87.33.10.in-addr.arpa.',
    'primary' => 'ns01.dev.f00bar.com',
    'key' => 'dev.f00bar.com',
  },
]

dhcp_subnet '10.33.87.0' do
  conf_dir node['dhcp']['dir']
  netmask '255.255.255.0'
  broadcast '10.33.87.255'
  routers ['10.33.87.1']
  range '10.33.87.5 10.33.87.254'
  key rndc_key
  zones dns_zones
end
