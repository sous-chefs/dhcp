require_relative 'helpers/default'
require_relative 'helpers/data'
require_relative '../libraries/dynadns'

describe "DHCP::DyanDns disabled" do
  before(:each) do 
    Fauxhai.mock(platform:'ubuntu', version:'12.04') do |n|
      n[:dns] ||= Hash.new
    end
    @chef_run = ChefSpec::ChefRunner.new
  end

  it 'should take no action if we have no zone info' do
    Fauxhai.mock(platform:'ubuntu', version:'12.04') do |n|
      n[:dns] = nil
    end
    DHCP::DynaDns.load(@chef_run.converge.node)
    DHCP::DynaDns.zones.should == nil
  end

end

describe "DHCP::DynaDns malformed" do
  before do
    Fauxhai.mock(platform:'ubuntu', version:'12.04') do |n|
      n[:dns] ||= Hash.new
      n[:dns][:zones] ||= []
      n[:dns][:zones]  =  %w/192.168.1.0/
      n[:dns][:rndc_key] = nil
    end
    @chef_run = ChefSpec::ChefRunner.new
  end

  it 'should not return masters without keys' do
    DHCP::DynaDns.load(@chef_run.converge.node)
    DHCP::DynaDns.masters.should eql({})
  end

end

describe "DHCP::DynaDns" do
  before(:each) do 
    Fauxhai.mock(platform:'ubuntu', version:'12.04') do |n|
      n[:dns] ||= Hash.new
      n[:dns][:zones] ||= []
      n[:dns][:master] = "192.168.9.9"
      n[:dns][:zones]  =  %w/vm 192.168.1.0/
      n[:dns][:rndc_key] = "dhcp-key"
    end
    @chef_run = ChefSpec::ChefRunner.new
  end

  it 'should load defined zones' do
    DHCP::DynaDns.load(@chef_run.converge.node)  
    DHCP::DynaDns.load_zones.length.should  eql(2)
  end

  it 'should return masters' do
    DHCP::DynaDns.load(@chef_run.converge.node)  
    DHCP::DynaDns.masters.should eql( {"vm"=>{"master"=>"192.168.1.9", "key"=>"dhcp-key"}, "1.168.192.IN-ADDR.ARPA"=>{"master"=>"192.168.9.9", "key"=>"dhcp-key"}})
  end

  it 'should load requested keys' do
    DHCP::DynaDns.load(@chef_run.converge.node)  
    DHCP::DynaDns.keys.should eql({"dhcp-key"=>{"id"=>"dhcp-key", "algorithm"=>"hmac-md5", "secret"=>"L+Jl4+4onU4Wstfi4pdmnQ==", "chef_type"=>"data_bag_item", "data_bag"=>"rndc_keys"}})
  end

end
