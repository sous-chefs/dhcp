require 'spec_helper'

describe 'dhcp_host' do
  step_into :dhcp_host
  platform 'centos'

  context 'create a dhcpd host and verify config is created properly' do
    recipe do
      dhcp_host 'Test-IPv4-Host' do
        options 'host-name' => 'test-ipv4-host'
        identifier 'hardware ethernet 00:53:00:00:00:01'
        address '192.168.0.10'
      end
    end

    it 'Creates the class configuration file correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd.d/hosts.d/Test-IPv4-Host.conf')
        .with_content(/host Test-IPv4-Host {/)
        .with_content(/hardware ethernet 00:53:00:00:00:01;/)
        .with_content(/option host-name test-ipv4-host;/)
    end
  end

  context 'create a dhcpd6 host and verify config is created properly' do
    recipe do
      dhcp_host 'Test-IPv6-Host' do
        ip_version :ipv6
        options 'host-name' => 'test-ipv6-host'
        identifier 'host-identifier option dhcp6.client-id 00:53:00:00:00:01:a4:65:b7:c8'
        address '2001:db8:1:1:0:0:1:10'
      end
    end

    it 'Creates the class configuration file correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd6.d/hosts.d/Test-IPv6-Host.conf')
        .with_content(/host Test-IPv6-Host {/)
        .with_content(/host-identifier option dhcp6.client-id 00:53:00:00:00:01:a4:65:b7:c8;/)
        .with_content(/option host-name test-ipv6-host;/)
    end
  end
end
