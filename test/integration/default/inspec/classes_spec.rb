describe file('/etc/dhcp/dhcpd.d/classes.d/RegisteredHosts.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match 'class "RegisteredHosts" ' }
  its(:content) { should match 'subclass "RegisteredHosts" 1:10:bf:48:42:55:01;' }
end

describe file('/etc/dhcp/dhcpd.d/classes.d/UnregisteredHosts.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match 'class "UnregisteredHosts" ' }
  its(:content) { should match 'subclass "UnregisteredHosts" 1:10:bf:48:42:55:03;' }
  its(:content) { should match 'option domain-name-servers 8.8.8.8;' }
end

describe file('/etc/dhcp/dhcpd6.d/classes.d/list.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match '# No files to include' }
end
