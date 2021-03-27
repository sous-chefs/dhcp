describe file('/etc/dhcp/dhcpd.d/groups.d/ip-phones.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match 'tftp-server-name "192.0.2.10";' }
  its(:content) { should match 'include "/etc/dhcp/dhcpd.d/groups.d/ip-phones_grouphost_SEP010101010101.conf";' }
end

describe file('/etc/dhcp/dhcpd.d/groups.d/ip-phones_grouphost_SEP010101010101.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match 'host ip-phones_grouphost_SEP010101010101 {' }
  its(:content) { should match 'hardware ethernet 01:01:01:01:01:01;' }
end
