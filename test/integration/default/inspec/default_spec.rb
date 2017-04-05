title 'DHCP install'

case os[:family]
when 'redhat'
  package_name = 'dhcp'
  service_name = 'dhcpd'
when 'debian', 'ubuntu'
  package_name = 'isc-dhcp-server'
  service_name = 'isc-dhcp-server'
end

describe package(package_name) do
  it { should be_installed }
end

describe service(service_name) do
  it { should be_enabled }
  it { should be_running }
end

describe processes('dhcpd') do
  its('states') { should eq ['Ss'] }
end

describe file('/etc/dhcp/dhcpd.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match %r{^include "/etc/dhcp/extra1.conf";} }
  its(:content) { should match %r{^include "/etc/dhcp/extra2.conf";} }
end
