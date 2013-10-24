#
# vim: set ft=ruby:
#

chef_api "https://chefdev.mkd2.ktc", node_name: "cookbook", client_key: ".cookbook.pem"

site :opscode

metadata

cookbook 'ktc-testing'
cookbook "dhcp_net_setup", path: "test/cookbooks/dhcp_net_setup"
