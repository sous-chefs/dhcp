# frozen_string_literal: true

control 'dhcp-default-default-spec' do
  debian_family = %w(debian ubuntu).include?(os.family)
  package_name = debian_family ? 'isc-dhcp-server' : 'dhcp-server'
  service_name = debian_family ? %w(isc-dhcp-server isc-dhcp-server6) : %w(dhcpd dhcpd6)

  describe package(package_name) do
    it { should be_installed }
  end

  service_name.each do |service|
    describe service(service) do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe command('/usr/sbin/dhcpd -t -4 -cf /etc/dhcp/dhcpd.conf') do
    its('exit_status') { should eq 0 }
  end

  describe command('/usr/sbin/dhcpd -t -6 -cf /etc/dhcp/dhcpd6.conf') do
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
    it { should be_listening }
    its('protocols') { should include 'udp' }
    its('processes') { should include 'dhcpd' }
  end if interface('eth0').ipv6_address?

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
end
