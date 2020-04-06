
case os[:family]
when 'redhat'
  package_name = if os[:release].to_i < 8
                   'dhcp'
                 else
                   'dhcp-server'
                 end
  service_name = %w(dhcpd dhcpd6)
when 'fedora'
  package_name = 'dhcp-server'
  service_name = %w(dhcpd dhcpd6)
when 'debian', 'ubuntu'
  package_name = 'isc-dhcp-server'
  service_name = %w(isc-dhcp-server isc-dhcp-server6)
end

describe package(package_name) do
  it { should be_installed }
end

service_name.each do |service|
  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end
end

describe processes('dhcpd') do
  its('states') { should eq %w(Ss Ss) }
end

describe port(67) do
  it { should be_listening }
  its('protocols') { should include 'udp' }
  its('processes') { should include 'dhcpd' }
end

describe port(547) do
  it { should be_listening }
  its('protocols') { should include 'udp' }
  its('processes') { should include 'dhcpd' }
end

describe file('/etc/dhcp/dhcpd.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match %r{^include "/etc/dhcp/extra1.conf";} }
  its(:content) { should match %r{^include "/etc/dhcp/extra2.conf";} }
  its(:content) { should match "on commit {\n  use-host-decl-names on;\n}" }
  its(:content) { should match "on release {\n  use-host-decl-names on;\n}" }
end

describe file('/etc/dhcp/dhcpd6.conf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match /option dhcp6.name-servers 2001:4860:4860::8888, 2001:4860:4860::8844;/ }
  its(:content) { should match "# Deny\ndeny duplicates;" }
end
