maintainer       "Opscode, Inc."
maintainer_email "matt@opscode.com"
license          "Apache 2.0"
description      "DHCP"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.0"

#tested with Ubuntu, assume Debian works similarly 
%w{ ubuntu centos redhat }.each do |os|
  supports os
end

depends "git"
depends "ruby-helper"
depends "helpers-search"
depends "helpers-databags"
