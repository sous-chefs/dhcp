# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://github.com/opscode/chef-dk/blob/master/POLICYFILE_README.md

# A name that describes what the system you're building with Chef does.
name 'dhcp'

# Where to find external cookbooks:
default_source :community

# run_list: chef-client will run these recipes in the order specified.
run_list 'dhcp::default'

# Specify a custom source for a single cookbook:
# cookbook 'dhcp', path: 'cookbooks/dhcp'
cookbook 'dhcp', path: '.'
cookbook 'dhcp_net_setup', path: 'test/cookbooks/dhcp_net_setup'
cookbook 'dhcp_attributes', path: 'test/cookbooks/dhcp_attributes'
cookbook 'testing', path: 'test/cookbooks/testing'
cookbook 'ubuntu'
