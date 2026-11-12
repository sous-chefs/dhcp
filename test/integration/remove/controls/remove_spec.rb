# frozen_string_literal: true

control 'dhcp-remove' do
  package_names = %w(debian ubuntu).include?(os.family) ? %w(isc-dhcp-server isc-dhcp-server-ldap) : ['dhcp-server']
  package_names.each do |package_name|
    describe package(package_name) do
      it { should_not be_installed }
    end
  end

  service_names = %w(debian ubuntu).include?(os.family) ? %w(isc-dhcp-server isc-dhcp-server6) : %w(dhcpd dhcpd6)
  service_names.each do |service_name|
    describe systemd_service(service_name) do
      it { should_not be_running }
      it { should_not be_enabled }
    end
    describe file("/etc/systemd/system/#{service_name}.service") do
      it { should_not exist }
    end
  end

  %w(/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd6.conf /etc/dhcp/dhcpd.failover.conf).each do |path|
    describe file(path) do
      it { should_not exist }
    end
  end

  describe command('find /etc/dhcp/dhcpd.d /etc/dhcp/dhcpd6.d -name "*.conf" ! -name list.conf') do
    its('stdout') { should eq '' }
  end

  # Leases remain server data after packages/configuration are removed.
  describe file(%w(debian ubuntu).include?(os.family) ? '/var/lib/dhcp/dhcpd.leases' : '/var/lib/dhcpd/dhcpd.leases') do
    it { should exist }
  end
end
