require 'spec_helper'

describe 'dhcp_config' do
  step_into :dhcp_config
  platform 'centos'

  context 'create a dhcpd config and verify config is created properly' do
    recipe do
      dhcp_config '/etc/dhcp/dhcpd.conf' do
        allow %w(booting bootp unknown-clients)
        parameters(
          'default-lease-time' => 7200,
          'ddns-update-style' => 'interim',
          'max-lease-time' => 86400,
          'update-static-leases' => true,
          'one-lease-per-client' => true,
          'authoritative' => '',
          'ping-check' => true
        )
        options(
          'domain-name' => '"test.domain.local"',
          'domain-name-servers' => '8.8.8.8',
          'host-name' => ' = binary-to-ascii (16, 8, "-", substring (hardware, 1, 6))'
        )
        hooks(
          'commit' => ['use-host-decl-names on'],
          'release' => ['use-host-decl-names on']
        )
        include_files [
          '/etc/dhcp/extra1.conf',
          '/etc/dhcp/extra2.conf',
          '/etc/dhcp_override/list.conf',
        ]
        action :create
      end
    end

    it 'Creates the main configuration file' do
      is_expected.to render_file('/etc/dhcp/dhcpd.conf')
        .with_content(/authoritative/)
        .with_content(/default-lease-time 7200/)
        .with_content(/option domain-name-servers 8.8.8.8;/)
        .with_content(%r{include "/etc/dhcp/dhcpd.conf.d/classes.d/list.conf";})
    end
  end

  context 'create a dhcpd6 config and verify config is created properly' do
    recipe do
      dhcp_config '/etc/dhcp/dhcpd6.conf' do
        ip_version :ipv6
        deny %w(duplicates)
        parameters(
          'default-lease-time' => 7200,
          'ddns-updates' => 'on',
          'ddns-update-style' => 'interim',
          'max-lease-time' => 86400,
          'update-static-leases' => true,
          'one-lease-per-client' => 'on',
          'authoritative' => '',
          'ping-check' => true
        )
        options(
          'dhcp6.name-servers' => '2001:4860:4860::8888, 2001:4860:4860::8844'
        )
        action :create
      end
    end

    it 'Creates the main configuration file' do
      is_expected.to render_file('/etc/dhcp/dhcpd6.conf')
        .with_content(/authoritative/)
        .with_content(/default-lease-time 7200/)
        .with_content(/option dhcp6.name-servers 2001:4860:4860::8888, 2001:4860:4860::8844;/)
        .with_content(%r{include "/etc/dhcp/dhcpd6.conf.d/classes.d/list.conf";})
    end
  end
end
