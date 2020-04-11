describe file('/etc/dhcp/dhcpd.conf.d/classes.d/UnregisteredHosts.conf') do
  it { should_not exist }
  it { should_not be_file }
end

describe file('/etc/dhcp/dhcpd.conf.d/classes.d/RegisteredHosts.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match 'class "RegisteredHosts" ' }
  its(:content) { should match 'subclass "RegisteredHosts" 1:10:bf:48:42:55:01;' }
end

describe file('/etc/dhcp/dhcpd.conf.d/classes.d/list.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should_not match 'include /etc/dhcp/dhcpd.conf.d/classes.d/UnregisteredHosts.conf' }
end

describe file('/etc/dhcp/dhcpd6.conf.d/classes.d/list.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match '# No files to include' }
end
