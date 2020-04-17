require 'spec_helper'

describe 'Default recipe on CentOS 7' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'centos', version: '7', step_into: ['dhcp_package']) }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end
