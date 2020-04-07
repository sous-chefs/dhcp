describe file('/etc/dhcp/dhcpd.conf.d/subnets.d/deny host from class.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match 'subnet 192.168.4.0 netmask 255.255.255.0' }
  its(:content) { should match 'deny members of "RegisteredHosts"' }
end

describe file('/etc/dhcp/dhcpd6.conf.d/subnets.d/dhcpv6_basic.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match 'range6 2001:db8:2:1::1:0/112;' }
  its(:content) { should match 'default-lease-time 28800;' }
end
