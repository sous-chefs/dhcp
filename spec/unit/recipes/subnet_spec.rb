require 'spec_helper'

describe 'dhcp_subnet' do
  step_into :dhcp_subnet
  platform 'centos'

  context 'create a dhcpd subnet for listening only and verify config is created properly' do
    recipe do
      dhcp_subnet '192.168.9.0' do
        comment 'Listen Subnet Declaration'
        subnet '192.168.9.0'
        netmask '255.255.255.0'
      end
    end

    it 'Creates the subnet configuration file correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd.d/subnets.d/192.168.9.0.conf')
        .with_content(/# 192.168.9.0 - Listen Subnet Declaration/)
        .with_content(/subnet 192.168.9.0 netmask 255.255.255.0 {\n}/)
    end
  end

  context 'create a dhcpd subnet with options as hash and verify config is created properly' do
    recipe do
      dhcp_subnet 'overrides' do
        comment 'Overrides Subnet Declaration'
        subnet '192.168.1.0'
        netmask '255.255.255.0'
        options(
          'routers' => '192.168.1.1',
          'time-offset' => 10,
          'broadcast-address' => '192.168.0.255'
        )
        pools(
          'peer' => '192.168.0.2',
          'range' => '192.168.1.100 192.168.1.200',
          'deny' => 'members of "RegisteredHosts"',
          'allow' => ['members of "UnregisteredHosts"', 'members of "OtherHosts"']
        )
        parameters(
          'ddns-domainname' => '"test.com"',
          'next-server' => '192.168.0.3'
        )
        evals [ 'if exists user-class and option user-class = "iPXE" {
    filename "bootstrap.ipxe";
  } else {
    filename "undionly.kpxe";
  }' ]
        key 'name' => 'test_key', 'algorithm' => 'hmac-sha256', 'secret' => 'c7nBOcB2rbJh7lYCI65/PGrS6QdlLMCPe2xunZ4dij8='
        zones 'test' => { 'primary' => 'test_pri', 'key' => 'test_key' }
        conf_dir '/etc/dhcp_override'
      end
    end

    it 'Creates the subnet configuration file correctly' do
      is_expected.to render_file('/etc/dhcp_override/overrides.conf')
        .with_content(/subnet 192.168.1.0 netmask 255.255.255.0 {/)
        .with_content(/option routers 192.168.1.1;/)
        .with_content(/if exists user-class and option user-class = "iPXE" {/)
        .with_content(/key test_key {/)
        .with_content(/zone test {/)
        .with_content(/deny members of "RegisteredHosts";/)
    end
  end

  context 'create a dhcpd subnet with parameters as array and verify config is created properly' do
    recipe do
      dhcp_subnet 'overrides' do
        comment 'Overrides Subnet Declaration'
        subnet '192.168.1.0'
        netmask '255.255.255.0'
        options(
          'routers' => '192.168.1.1',
          'time-offset' => 10,
          'broadcast-address' => '192.168.0.255'
        )
        pools(
          'peer' => '192.168.0.2',
          'range' => '192.168.1.100 192.168.1.200',
          'deny' => 'members of "RegisteredHosts"',
          'allow' => ['members of "UnregisteredHosts"', 'members of "OtherHosts"']
        )
        parameters [
          'ddns-domainname "test.com"',
          'next-server 192.168.0.3',
        ]
        evals [ 'if exists user-class and option user-class = "iPXE" {
    filename "bootstrap.ipxe";
  } else {
    filename "undionly.kpxe";
  }' ]
        key 'name' => 'test_key', 'algorithm' => 'hmac-sha256', 'secret' => 'c7nBOcB2rbJh7lYCI65/PGrS6QdlLMCPe2xunZ4dij8='
        zones 'test' => { 'primary' => 'test_pri', 'key' => 'test_key' }
        conf_dir '/etc/dhcp_override'
      end
    end

    it 'Creates the subnet configuration file correctly' do
      is_expected.to render_file('/etc/dhcp_override/overrides.conf')
        .with_content(/subnet 192.168.1.0 netmask 255.255.255.0 {/)
        .with_content(/option routers 192.168.1.1;/)
        .with_content(/if exists user-class and option user-class = "iPXE" {/)
        .with_content(/key test_key {/)
        .with_content(/zone test {/)
        .with_content(/deny members of "RegisteredHosts";/)
    end
  end
end
