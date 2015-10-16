require 'spec_helper'

describe 'dhcp::server' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node|
      node.set['chef_environment'] = 'production'
    end.converge(described_recipe)
  end
end
