#
# vim: set ft=ruby:
#
source 'https://supermarket.chef.io'

metadata

cookbook 'dhcp_net_setup', path: 'test/cookbooks/dhcp_net_setup'
cookbook 'dhcp_attributes', path: 'test/cookbooks/dhcp_attributes'
cookbook 'testing', path: 'test/cookbooks/testing'

group :integration do
  cookbook 'ubuntu'
end
