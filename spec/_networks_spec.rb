require_relative 'helpers/default'
require_relative 'helpers/data'

describe "dhcp::_networks Exceptions" do
  before(:each) do
    Fauxhai.mock(platform:'ubuntu', version:'12.04') 
    @chef_run = ChefSpec::ChefRunner.new
  end


  it 'should raise error unless we have network data bags' do
    expect { @chef_run.converge "dhcp::_networks" }.to raise_error(Chef::Exceptions::AttributeNotFound)
  end
end


