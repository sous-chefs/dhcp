name              'dhcp'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs and configures DHCP'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '5.4.0'

source_url "https://github.com/sous-chefs/#{name}" if respond_to?(:source_url)
issues_url "https://github.com/sous-chefs/#{name}/issues" if respond_to?(:issues_url)

# tested with Ubuntu, assume Debian works similarly
%w(debian ubuntu centos redhat).each do |os|
  supports os
end

chef_version '>= 12.1'
