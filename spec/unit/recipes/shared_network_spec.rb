require 'spec_helper'

describe 'dhcp_shared_network' do
  step_into :dhcp_shared_network, :dhcp_subnet
  platform 'centos'

  context 'create a dhcpd single shared network and verify config is created properly' do
    recipe do
      dhcp_shared_network 'single' do
        subnets(
          '192.168.1.0' => {
            'subnet' => '192.168.1.0',
            'netmask' => '255.255.255.0',
            'options' => {
              'broadcast-address' => '192.168.1.255',
              'routers' => '192.168.1.1',
            },
            'pool' => {
              'range' => '192.168.1.20 192.168.1.30',
            },
          }
        )
      end
    end

    it 'Creates the shared network configuration file correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd.d/shared_networks.d/single.conf')
        .with_content(%r{include "/etc/dhcp/dhcpd.d/shared_networks.d/single_sharedsubnet_192.168.1.0.conf";})
    end

    it 'Creates the nested subnet configuration file correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd.d/shared_networks.d/single_sharedsubnet_192.168.1.0.conf')
        .with_content(/subnet 192.168.1.0 netmask 255.255.255.0 {/)
        .with_content(/range 192.168.1.20 192.168.1.30;/)
    end
  end

  context 'create a dhcpd multiple shared network and verify config is created properly' do
    recipe do
      dhcp_shared_network 'multiple' do
        subnets(
          '192.168.2.0' => {
            'subnet' => '192.168.2.0',
            'netmask' => '255.255.255.0',
            'options' => {
              'broadcast-address' => '192.168.2.255',
              'routers' => '192.168.2.1',
            },
            'pool' => {
              'range' => '192.168.2.20 192.168.2.30',
            },
          },
          '192.168.3.0' => {
            'subnet' => '192.168.3.0',
            'netmask' => '255.255.255.0',
            'options' => {
              'broadcast-address' => '192.168.3.255',
              'routers' => '192.168.3.1',
            },
            'pool' => {
              'range' => [
                '192.168.3.20 192.168.3.30',
                '192.168.3.40 192.168.3.50',
              ],
            },
          }
        )
      end
    end

    it 'Creates the shared network configuration file correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd.d/shared_networks.d/multiple.conf')
        .with_content(%r{include "/etc/dhcp/dhcpd.d/shared_networks.d/multiple_sharedsubnet_192.168.2.0.conf";})
        .with_content(%r{include "/etc/dhcp/dhcpd.d/shared_networks.d/multiple_sharedsubnet_192.168.3.0.conf";})
    end

    it 'Creates the nested subnet configuration files correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd.d/shared_networks.d/multiple_sharedsubnet_192.168.2.0.conf')
        .with_content(/subnet 192.168.2.0 netmask 255.255.255.0 {/)
        .with_content(/range 192.168.2.20 192.168.2.30;/)
      is_expected.to render_file('/etc/dhcp/dhcpd.d/shared_networks.d/multiple_sharedsubnet_192.168.3.0.conf')
        .with_content(/subnet 192.168.3.0 netmask 255.255.255.0 {/)
        .with_content(/option broadcast-address 192.168.3.255;/)
        .with_content(/range 192.168.3.40 192.168.3.50;/)
    end
  end
end
