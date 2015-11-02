name 'dhcp'
maintainer 'Chef Brigade'
maintainer_email 'help@chefbrigade.io'
source_url "https://github.com/chef-brigade/#{name}-cookbook" if respond_to?(:source_url)
issues_url "https://github.com/chef-brigade/#{name}-cookbook/issues" if respond_to?(:issues_url)
license 'Apache 2.0'
description 'DHCP'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '5.2.0'

# tested with Ubuntu, assume Debian works similarly
%w(debian ubuntu centos redhat).each do |os|
  supports os
end
