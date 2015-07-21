require_relative 'helpers/default'
require_relative 'helpers/data'
require_relative '../libraries/dynadns'

describe 'DHCP::DyanDns disabled' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge('dhcp::library')
  end

  it 'should take no action if we have no zone info' do
    DHCP::DynaDns.load chef_run.run_context.node
    DHCP::DynaDns.zones.should.nil?
  end
end

describe 'DHCP::DynaDns malformed' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:dns] ||= {}
      node.set[:dns][:zones] ||= []
      node.set[:dns][:zones]  =  %w(192.168.1.0)
      node.set[:dns][:rndc_key] = nil
    end.converge('dhcp::library')
  end

  before do
    file_bags
  end

  it 'should not return masters without keys' do
    DHCP::DynaDns.load chef_run.run_context.node
    DHCP::DynaDns.masters.should eql({})
  end
end

describe 'DHCP::DynaDns' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:dns] ||= {}
      node.set[:dns][:zones] ||= []
      node.set[:dns][:master] = '192.168.9.9'
      node.set[:dns][:zones]  =  %w(vm 192.168.1.0)
      node.set[:dns][:rndc_key] = 'dhcp-key'
    end.converge('dhcp::library')
  end

  before do
    file_bags
  end

  it 'should load defined zones' do
    DHCP::DynaDns.load(chef_run.run_context.node)
    DHCP::DynaDns.load_zones.length.should eql(2)
  end

  it 'should return masters' do
    DHCP::DynaDns.load(chef_run.run_context.node)
    DHCP::DynaDns.masters.should eql('vm' => { 'master' => '192.168.1.9', 'key' => 'dhcp-key' }, '1.168.192.IN-ADDR.ARPA' => { 'master' => '192.168.9.9', 'key' => 'dhcp-key' })
  end

  it 'should load requested keys' do
    DHCP::DynaDns.load(chef_run.run_context.node)
    DHCP::DynaDns.keys.should eql('dhcp-key' => { 'id' => 'dhcp-key', 'algorithm' => 'hmac-md5', 'secret' => 'L+Jl4+4onU4Wstfi4pdmnQ==' })
  end
end
