case os.family
when 'redhat', 'centos'
  package_name = if os.release.to_i < 8
                   'dhcp'
                 else
                   'dhcp-server'
                 end
  service_name = %w(dhcpd)
  service_name.push('dhcpd6') if interface('eth0').ipv6_address?
when 'fedora'
  package_name = 'dhcp-server'
  service_name = %w(dhcpd)
  service_name.push('dhcpd6') if interface('eth0').ipv6_address?
when 'debian', 'ubuntu'
  package_name = 'isc-dhcp-server'
  service_name = %w(isc-dhcp-server)
  service_name.push('isc-dhcp-server6') if interface('eth0').ipv6_address?
end

describe package(package_name) do
  it { should be_installed }
end

describe service(service_name[0]) do
  it { should be_enabled }
  it { should be_running }
end

describe service(service_name[1]) do
  it { should_not be_enabled }
  it { should_not be_running }
end

describe command('/usr/sbin/dhcpd -t -4 -cf /etc/dhcp/dhcpd.conf') do
  its('exit_status') { should eq 0 }
end

states = if os.name.eql?('ubuntu') && os.release.eql?('20.04')
           %w(Ssl)
         else
           %w(Ss)
         end

describe processes('dhcpd') do
  its('states') { should eq states }
end

describe port(67) do
  it { should be_listening }
  its('protocols') { should include 'udp' }
  its('processes') { should include 'dhcpd' }
end

describe port(547) do
  it { should_not be_listening }
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
  it { should_not exist }
  it { should_not be_file }
end
