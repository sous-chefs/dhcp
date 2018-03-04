name              'dhcp'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs and configures DHCP'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
chef_version      '>= 12.7' if respond_to?(:chef_version)
source_url        'https://github.com/sous-chefs/dhcp'
issues_url        'https://github.com/sous-chefs/dhcp/issues'
version           '5.5.0'

supports 'debian'
supports 'ubuntu'
supports 'centos'
supports 'redhat'
supports 'scientific'
supports 'oracle'
