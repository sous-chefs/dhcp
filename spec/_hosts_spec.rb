require 'spec_helper'

describe 'dhcp::_hosts' do
  context 'when all attributes are default, on rhel 6.x' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8') do |node, server|
        node.default['dhcp']['hosts'] = ['pxe_test-vm', 'vagrant-vm']
        server.create_data_bag('dhcp_hosts',
                               'pxe_test-vm' => parse_data_bag('dhcp_hosts/pxe_test-vm'),
                               'vagrant-vm' => parse_data_bag('dhcp_hosts/vagrant-vm'))
      end.converge(described_recipe)
    end

    it 'converges' do
      chef_run
    end
  end
end
