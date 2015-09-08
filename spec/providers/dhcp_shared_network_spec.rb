require_relative '../helpers/default'

describe 'testing::dhcp_shared_network' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '6.6', step_into: ['dhcp_shared_network']).converge(described_recipe)
  end

  it 'generates a shared network with a single network' do
    expect(chef_run).to create_template '/etc/dhcp/shared_networks.d/single.conf'
    expect(chef_run).to render_file('/etc/dhcp/shared_networks.d/single.conf').with_content(File.read File.join(File.dirname(__FILE__), 'fixtures', 'dhcp_shared_network.single'))
  end

  it 'generates a shared network with multiple networks' do
    expect(chef_run).to create_template '/etc/dhcp/shared_networks.d/multiple.conf'
    expect(chef_run).to render_file('/etc/dhcp/shared_networks.d/multiple.conf').with_content(File.read File.join(File.dirname(__FILE__), 'fixtures', 'dhcp_shared_network.multiple'))
  end
end
