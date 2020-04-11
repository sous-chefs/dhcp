describe file('/etc/dhcp/dhcpd.d/classes.d/RegisteredHosts.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match 'class "RegisteredHosts" ' }
  its(:content) { should match 'subclass "RegisteredHosts" 1:10:bf:48:42:55:01;' }
end

describe file('/etc/dhcp/dhcpd6.d/classes.d/list.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match '# No files to include' }
end
