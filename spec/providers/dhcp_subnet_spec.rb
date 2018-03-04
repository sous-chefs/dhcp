require 'spec_helper'

describe 'test::dhcp_subnet' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8', step_into: ['dhcp_subnet']).converge(described_recipe)
  end

  it 'generates a default config' do
    expect(chef_run).to create_template '/etc/dhcp/subnets.d/10.0.2.0.conf'
    expect(chef_run).to render_file('/etc/dhcp/subnets.d/10.0.2.0.conf').with_content(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'dhcp_subnet.default')))
  end

  it 'generates a basic subnet config' do
    expect(chef_run).to create_template '/etc/dhcp/subnets.d/basic.conf'
    expect(chef_run).to render_file('/etc/dhcp/subnets.d/basic.conf').with_content(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'dhcp_subnet.basic')))
  end

  it 'generates an overriden config' do
    expect(chef_run).to create_template '/etc/dhcp_override/subnets.d/overrides.conf'
    expect(chef_run).to render_file('/etc/dhcp_override/subnets.d/overrides.conf').with_content(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'dhcp_subnet.overrides')))
  end
end
