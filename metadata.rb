name             'dhcp'
maintainer       'Jesse Nelson'
maintainer_email 'spheromak@gmail.com'
license          'Apache 2.0'
description      'DHCP'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.0.0'

# tested with Ubuntu, assume Debian works similarly
%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end

depends 'ruby-helper'
depends 'helpers-databags'
