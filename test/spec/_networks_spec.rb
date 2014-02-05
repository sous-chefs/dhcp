require_relative 'helpers/default'
require_relative 'helpers/data'

describe "dhcp::_networks Exceptions" do
  before(:each) do
    Fauxhai.mock(platform:'ubuntu', version:'12.04')
    @chef_run = ChefSpec::Runner.new
  end


  it 'should not raise error unless when bags are missing' do
    @chef_run.converge "dhcp::_networks"
  end
end


