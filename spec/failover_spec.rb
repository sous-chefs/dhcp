require 'chefspec'
require 'fauxhai'
require_relative 'helpers/default'
require_relative '../libraries/failover'

# wrap failover lib's search
def failover_search(result)
  DHCP::Failover.stub!(:search).and_return(result)
end

describe "DHCP::Failover" do
  before do 
    Fauxhai.mock(platform:'ubuntu', version:'12.04')
    @chef_run = ChefSpec::ChefRunner.new
  end

  it 'should detect when disabled' do
    DHCP::Failover.load(@chef_run.converge.node) 
    DHCP::Failover.enabled?.should be_false
  end
end

describe 'DHCP::Failover Master' do
  before do
    dummy_nodes

    Fauxhai.mock(platform:'ubuntu', version:'12.04') do |node|
      node[:dhcp] ||= Hash.new
      node[:dhcp][:master] = true
      node[:ipaddress] = "10.1.1.10"
    end

    @chef_run = ChefSpec::ChefRunner.new
    DHCP::Failover.load(@chef_run.converge.node)
  end

  it 'should know its primary' do
    DHCP::Failover.role.should == 'primary' 
  end

  it 'should disable without secondary' do
    failover_search(Array.new)
    DHCP::Failover.enabled?.should be_false
  end

  it 'should enable when secondary found' do
    failover_search([@slave.to_hash, 0, 1])
    DHCP::Failover.enabled?.should be_true
  end

  it 'should find our peer' do
    failover_search([ @slave.to_hash, 0, 1])
    DHCP::Failover.peer.should == '10.1.1.20'
  end
end

describe "DHCP::Failover Slave" do
  it 'should identify as slave' do
  end

  it 'should disable when no primaries found' do
  #  DHCP::Failover.load(chef_run.converge.node)  
  #  DHCP::Failover.enabled?.should be_false
  end

  it 'should enable when primary found' do 
  #  DHCP::Failover.load(chef_run.converge.node)  
  #  DHCP::Failover.enabled?.should be_false
  end
end

