require_relative 'helpers/default'

recipe = 'dhcp::server'

describe recipe do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set[:chef_environment] = 'production'
    end.converge(recipe)
  end
end
