require_relative 'helpers/default'
require_relative 'helpers/data'

describe 'dhcp::_networks Exceptions' do
  before(:each) do
    Fauxhai.mock(platform: 'ubuntu', version: '12.04')
    @chef_run = ChefSpec::SoloRunner.new
  end

  it 'should not raise error unless when bags are missing' do
    @chef_run.converge 'dhcp::_networks'
  end
end

describe 'dhcp::_networks' do
  context 'driven by node attributes' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.6', step_into: ['dhcp_subnet']) do |node|
        node.set[:chef_environment] = 'production'
        node.set[:dhcp][:use_bags] = false
        node.set[:dhcp][:networks] = ['192.168.9.0/24']
        node.set[:dhcp][:network_data]['192.168.9.0/24'] = {
          'id' => '192-168-9-0_24',
          'routers'   => ['192.168.9.1'],
          'address'   => '192.168.9.0',
          'netmask'   => '255.255.255.0',
          'broadcast' => '192.168.9.255',
          'range'     => '192.168.9.50 192.168.9.240',
          'options'   => ['next-server 192.168.9.11']
        }
      end.converge(described_recipe)
    end

    it 'declares subnet 192.168.9.0' do
      expect(chef_run).to add_dhcp_subnet('192.168.9.0')
        .with(broadcast: '192.168.9.255', netmask: '255.255.255.0', routers: ['192.168.9.1'],
              options: ['next-server 192.168.9.11'],
              range: '192.168.9.50 192.168.9.240', conf_dir: '/etc/dhcp',
              evals: [], key: {}, zones: [])
    end

    it 'generates subnet config for 192.168.9.0' do
      expect(chef_run).to create_template '/etc/dhcp/subnets.d/192.168.9.0.conf'
      expect(chef_run).to render_file('/etc/dhcp/subnets.d/192.168.9.0.conf').with_content(File.read File.join(File.dirname(__FILE__), 'fixtures', '192.168.9.0.conf'))
    end
  end
end
