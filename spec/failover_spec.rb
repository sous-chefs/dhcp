require_relative 'helpers/default'
require_relative 'helpers/data'
require_relative '../libraries/failover'

def stub_slave_search
  stub_search(:node, 'domain:local AND dhcp_slave:true') do
    n = Chef::Node.new
    n.set[:dhcp] ||= {}
    n.set[:dhcp][:slave] = true
    n.set[:ipaddress] = '10.1.1.20'
    [n]
  end
end

def stub_master_search
  stub_search(:node, 'domain:local AND dhcp_master:true') do
    n = Chef::Node.new
    n.set[:dhcp] ||= {}
    n.set[:dhcp][:master] = true
    n.set[:ipaddress] = '10.1.1.10'
    [n]
  end
end

describe 'DHCP::Failover' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge('dhcp::library')
  end

  it 'should detect when disabled' do
    DHCP::Failover.load(chef_run.run_context.node)
    expect(DHCP::Failover.enabled?).to be false
  end
end

describe 'DHCP::Failover Master' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set[:dhcp] ||= {}
      node.set[:dhcp][:master] = true
      node.set[:ipaddress] = '10.1.1.10'
    end.converge('dhcp::library')
  end

  it 'should identify as primary' do
    DHCP::Failover.load(chef_run.run_context.node)
    expect(DHCP::Failover.role).to eq 'primary'
  end

  it 'should disable without secondary' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_search(:node, 'domain:local AND dhcp_slave:true') {}
    expect(DHCP::Failover.enabled?).to be false
  end

  it 'should enable when secondary found' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_slave_search
    expect(DHCP::Failover.enabled?).to be true
  end

  it 'should find our peer' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_slave_search
    expect(DHCP::Failover.peer).to eq '10.1.1.20'
  end
end

describe 'DHCP::Failover Slave' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set[:dhcp] ||= {}
      node.set[:dhcp][:slave] = true
      node.set[:ipaddress] = '10.1.1.20'
    end.converge('dhcp::library')
  end

  it 'should identify as secondary' do
    DHCP::Failover.load(chef_run.run_context.node)
    expect(DHCP::Failover.role).to eq 'secondary'
  end

  it 'should disable when no primaries found' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_search(:node, 'domain:local AND dhcp_master:true') {}
    expect(DHCP::Failover.enabled?).to be false
  end

  it 'should enable when primary found' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_master_search
    expect(DHCP::Failover.enabled?).to be true
  end

  it 'should find our peer' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_master_search
    expect(DHCP::Failover.peer).to eq '10.1.1.10'
  end
end
