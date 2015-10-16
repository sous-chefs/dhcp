require 'spec_helper'

case os[:family]
when 'redhat'
  package_name = 'dhcp'
  service_name = 'dhcpd'
when 'debian', 'ubuntu'
  package_name = 'isc-dhcp-server'
  service_name = 'isc-dhcp-server'
end

describe 'dhcp::_package' do
  it 'installs dhcp server package' do
    expect(package(package_name)).to be_installed
  end
end

describe 'dhcp::_service' do
  it 'enables dhcp server service' do
    expect(service(service_name)).to be_enabled
    expect(service(service_name)).to be_running
  end

  describe process('dhcpd') do
    it { should be_running }
  end
end

describe 'dhcp::_config' do
  it 'generates the dhcp confg file' do
    expect(file('/etc/dhcp/dhcpd.conf')).to exist
    expect(file('/etc/dhcp/dhcpd.conf')).to be_file
  end

  it 'adds extra files to dhcp config file' do
    expect(file('/etc/dhcp/dhcpd.conf').content).to contain 'include "/etc/dhcp/extra1.conf";'
    expect(file('/etc/dhcp/dhcpd.conf').content).to contain 'include "/etc/dhcp/extra2.conf";'
  end
end
