require 'spec_helper'

describe 'dhcp::_config' do
  context 'when all attributes are default, on rhel 6.x' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8').converge(described_recipe)
    end

    let(:params) do
      {
        'default-lease-time' => '6400',
        'ddns-domainname' => '"local"',
        'ddns-update-style' => 'interim',
        'max-lease-time' => '86400',
        'update-static-leases' => 'true',
        'one-lease-per-client' => 'true',
        'authoritative' => '',
        'ping-check' => 'true',
        'next-server' => '10.0.0.2',
        'filename' => '"pxelinux.0"',
      }
    end

    let(:opts) do
      {
        'domain-name' => '"local"',
        'domain-name-servers' => '8.8.8.8',
        'host-name' => ' = binary-to-ascii (16, 8, "-", substring (hardware, 1, 6))',
      }
    end

    it 'generates a config file' do
      expect(chef_run).to create_template('/etc/dhcp/dhcpd.conf')
        .with(variables: { allows: %w(booting bootp unknown-clients),
                           parameters: params, options: opts, masters: nil,
                           keys: nil, my_ip: '10.0.0.2', role: nil,
                           peer_ip: nil, failover: false, hooks: {} })
      expect(chef_run).to render_file('/etc/dhcp/dhcpd.conf').with_content(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'dhcpd.conf.default')))
    end
  end

  context 'when attributes are overridden, on rhel 6.x' do
    # Only testing overriding node['dhcp']['extra_files']
    # Need to add testing for all other attributes used by _config recipe
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8') do |node|
        node.override['dhcp']['extra_files'] = ['/etc/dhcp/my_conf.conf', '/tmp/bad.conf']
        node.override['dhcp']['hooks'] = hooks
      end.converge(described_recipe)
    end

    let(:hooks) do
      {
        'commit' => ['set clip = binary-to-ascii(10, 8, ".", leased-address);',
                     'set clhw = binary-to-ascii(16, 8, ":", substring(hardware, 1, 6));',
                     'execute("/usr/local/sbin/dhcpevent", "commit", clip, clhw, host-decl-name);'],
      }
    end

    let(:params) do
      {
        'default-lease-time' => '6400',
        'ddns-domainname' => '"local"',
        'ddns-update-style' => 'interim',
        'max-lease-time' => '86400',
        'update-static-leases' => 'true',
        'one-lease-per-client' => 'true',
        'authoritative' => '',
        'ping-check' => 'true',
        'next-server' => '10.0.0.2',
        'filename' => '"pxelinux.0"',
      }
    end

    let(:opts) do
      {
        'domain-name' => '"local"',
        'domain-name-servers' => '8.8.8.8',
        'host-name' => ' = binary-to-ascii (16, 8, "-", substring (hardware, 1, 6))',
      }
    end

    it 'generates config file with noextra config files' do
      expect(chef_run).to create_template('/etc/dhcp/dhcpd.conf')
        .with(variables: { allows: %w(booting bootp unknown-clients),
                           parameters: params, options: opts, masters: nil,
                           keys: nil, my_ip: '10.0.0.2', role: nil,
                           peer_ip: nil, failover: false, hooks: hooks })
      expect(chef_run).to render_file('/etc/dhcp/dhcpd.conf').with_content(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'dhcpd.conf.overrides')))
    end
  end
end
