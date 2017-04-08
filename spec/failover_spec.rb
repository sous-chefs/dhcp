require 'spec_helper'
require_relative '../libraries/failover'

describe 'DHCP::Failover' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new.converge('dhcp::library')
  end

  it 'should detect when disabled' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.enabled?).to be false
  end
end

describe 'DHCP::Failover Master without slaves' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node, _server|
      node.default['dhcp']['master'] = true
      node.automatic['ipaddress'] = '10.1.1.10'
    end.converge('dhcp::library')
  end

  it 'should disable without secondary' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.enabled?).to be false
  end

  it 'should identify as primary' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.role).to eq 'primary'
  end
end

describe 'DHCP::Failover Master with slaves' do
  let(:slave) do
    stub_node('slave', platform: 'ubuntu', version: '14.04') do |node|
      node.default['dhcp']['slave'] = true
      node.automatic['ipaddress'] = '10.1.1.20'
    end
  end

  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      node.default[:dhcp][:master] = true
      node.automatic[:ipaddress] = '10.1.1.10'

      server.create_node(slave)
    end.converge('dhcp::library')
  end

  it 'should identify as primary' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.role).to eq 'primary'
  end

  it 'should enable when secondary found' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.enabled?).to be true
  end

  it 'should find our peer' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.peer).to eq '10.1.1.20'
  end
end

describe 'DHCP::Failover Slave no master' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node|
      node.default['dhcp']['slave'] = true
      node.automatic['ipaddress'] = '10.1.1.20'
    end.converge('dhcp::library')
  end

  it 'should identify as secondary' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.role).to eq 'secondary'
  end

  it 'should disable when no primaries found' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.enabled?).to be false
  end
end

describe 'DHCP::Failover Slave' do
  let(:master) do
    stub_node('master', platform: 'ubuntu', version: '14.04') do |node|
      node.default['dhcp']['master'] = true
      node.automatic['ipaddress'] = '10.1.1.10'
    end
  end

  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      node.default[:dhcp][:slave] = true
      node.default[:ipaddress] = '10.1.1.20'

      server.create_node(master)
    end.converge('dhcp::library')
  end

  it 'should identify as secondary' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.role).to eq 'secondary'
  end

  it 'should enable when primary found' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.enabled?).to be true
  end

  it 'should find our peer' do
    DHCP::Failover.load(chef_run.node)
    expect(DHCP::Failover.peer).to eq '10.1.1.10'
  end
end
