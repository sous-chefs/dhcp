require_relative '../helpers/default'

describe 'testing::dhcp_class' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6', step_into: ['dhcp_class']).converge(described_recipe)
  end

  let(:list_conf_contents) do
    '#
# file managed by chef
# Host entry includes
#
include "/etc/dhcp/classes.d/BlankClass.conf";
include "/etc/dhcp/classes.d/RegisteredHosts.conf";'
  end

  it 'creates classes.d directory' do
    expect(chef_run).to create_directory '/etc/dhcp/classes.d'
  end

  it 'creates list.conf to include other subconfig files' do
    expect(chef_run).to create_template '/etc/dhcp/classes.d/list.conf'
    expect(chef_run).to render_file('/etc/dhcp/classes.d/list.conf').with_content(list_conf_contents)
  end

  it 'generates a blank class config' do
    expect(chef_run).to create_template '/etc/dhcp/classes.d/BlankClass.conf'
    expect(chef_run).to render_file('/etc/dhcp/classes.d/BlankClass.conf').with_content(File.read File.join(File.dirname(__FILE__), 'fixtures', 'dhcp_class_blank.conf'))
  end

  it 'generates class config with subclasses' do
    expect(chef_run).to create_template '/etc/dhcp/classes.d/RegisteredHosts.conf'
    expect(chef_run).to render_file('/etc/dhcp/classes.d/RegisteredHosts.conf').with_content(File.read File.join(File.dirname(__FILE__), 'fixtures', 'dhcp_class_registered_hosts.conf'))
  end
end
