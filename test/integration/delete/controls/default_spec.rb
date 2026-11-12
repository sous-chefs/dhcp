# frozen_string_literal: true

control 'dhcp-delete-default-spec' do
  debian_family = %w(debian ubuntu).include?(os.family)
  package_name = debian_family ? 'isc-dhcp-server' : 'dhcp-server'
  service_name = debian_family ? %w(isc-dhcp-server isc-dhcp-server6) : %w(dhcpd dhcpd6)

  describe package(package_name) do
    it { should be_installed }
  end

  describe service(service_name.first) do
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

  describe processes('dhcpd') do
    its('states') { should all match(/\A[RS]/) }
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
end
