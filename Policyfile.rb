# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://github.com/opscode/chef-dk/blob/master/POLICYFILE_README.md

# A name that describes what the system you're building with Chef does.
name 'dhcp'

# Where to find external cookbooks:
default_source :community

# run_list: chef-client will run these recipes in the order specified.
run_list 'dhcp_net_setup::default', 'dhcp::server', 'dhcp_attributes::default', 'testing::default'

# Specify a custom source for a single cookbook:
# cookbook 'dhcp', path: 'cookbooks/dhcp'
cookbook 'dhcp', path: '.'
cookbook 'dhcp_net_setup', path: 'test/cookbooks/dhcp_net_setup'
cookbook 'dhcp_attributes', path: 'test/cookbooks/dhcp_attributes'
cookbook 'testing', path: 'test/cookbooks/testing'
cookbook 'ubuntu'

# Attributes for testing
default['dhcp']['interfaces'] = ['eth0', 'eth1']
default['dhcp']['groups'] = []
default['dhcp']['hosts'] = []
default['dhcp']['networks'] = ['192.168.9.0/24']
default['dhcp']['shared_networks'] = ['mysharednet']
default['dhcp']['options']['domain-name'] = 'vm'
default['dhcp']['options']['domain-name-servers'] = '192.168.9.1'
default['dhcp']['extra_files'] = ['/etc/dhcp/extra1.conf', '/etc/dhcp/extra2.conf']
