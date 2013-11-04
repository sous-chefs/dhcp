require_relative 'helpers/default'
require_relative 'helpers/data'
require_relative '../../libraries/failover'

def stub_slave_search
  stub_search(:node, "domain:local AND dhcp_slave:true") {
    n = Chef::Node.new
    n.set[:dhcp] ||= Hash.new
    n.set[:dhcp][:slave] = true
    n.set[:ipaddress] = "10.1.1.20"
    [ n ]
  }
end

def stub_master_search
  stub_search(:node, "domain:local AND dhcp_master:true") {
    n = Chef::Node.new
    n.set[:dhcp] ||= Hash.new
    n.set[:dhcp][:master] = true
    n.set[:ipaddress] = "10.1.1.10"
    [ n ]
  }
end

describe "DHCP::Failover" do
  let(:chef_run) do
    ChefSpec::Runner.new.converge("dhcp::library")
  end

  it 'should detect when disabled' do
    DHCP::Failover.load(chef_run.run_context.node)
    DHCP::Failover.enabled?.should be_false
  end
end

describe 'DHCP::Failover Master' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:dhcp] ||= Hash.new
      node.set[:dhcp][:master] = true
      node.set[:ipaddress] = "10.1.1.10"
    end.converge("dhcp::library")
  end

  it 'should identify as primary' do
    DHCP::Failover.load(chef_run.run_context.node)
    DHCP::Failover.role.should == 'primary'
  end

  it 'should disable without secondary' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_search(:node, "domain:local AND dhcp_slave:true") {}
    DHCP::Failover.enabled?.should be_false
  end

  it 'should enable when secondary found' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_slave_search
    DHCP::Failover.enabled?.should be_true
  end

  it 'should find our peer' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_slave_search
    DHCP::Failover.peer.should == '10.1.1.20'
  end
end

describe "DHCP::Failover Slave" do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:dhcp] ||= Hash.new
      node.set[:dhcp][:slave] = true
      node.set[:ipaddress] = "10.1.1.20"
    end.converge("dhcp::library")
  end

  it 'should identify as secondary' do
    DHCP::Failover.load(chef_run.run_context.node)
    DHCP::Failover.role.should == 'secondary'
  end

  it 'should disable when no primaries found' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_search(:node, "domain:local AND dhcp_master:true") {}
    DHCP::Failover.enabled?.should be_false
  end

  it 'should enable when primary found' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_master_search
    DHCP::Failover.enabled?.should be_true
  end

  it 'should find our peer' do
    DHCP::Failover.load(chef_run.run_context.node)
    stub_master_search
    DHCP::Failover.peer.should == '10.1.1.10'
  end

end

