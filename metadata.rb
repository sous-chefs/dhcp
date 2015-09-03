name 'dhcp'
source_url "https://github.com/chef-brigade/#{name}-cookbook" if respond_to?(:source_url)
issues_url "https://github.com/chef-brigade/#{name}-cookbook/issues" if respond_to?(:issues_url)
maintainer 'Chef Brigade'
maintainer_email 'help@chefbrigade.io'
license 'Apache 2.0'
description 'DHCP'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '4.1.2'

# tested with Ubuntu, assume Debian works similarly
%w(debian ubuntu centos redhat).each do |os|
  supports os
end

depends 'ruby-helper'
depends 'helpers-databags'
