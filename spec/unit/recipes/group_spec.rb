require 'spec_helper'

describe 'dhcp_group' do
  step_into :dhcp_group, :dhcp_host
  platform 'centos'

  context 'create a dhcpd group and verify config is created properly' do
    recipe do
      dhcp_group 'ip-phones' do
        options(
          'tftp-server-name' => '"192.0.2.10"'
        )
        hosts(
          'SEP010101010101' => {
            'identifier' => 'hardware ethernet 01:01:01:01:01:01',
          }
        )
      end
    end

    it 'Creates the group configuration file correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd.d/groups.d/ip-phones.conf')
        .with_content(/tftp-server-name "192.0.2.10";/)
        .with_content(%r{include "/etc/dhcp/dhcpd.d/groups.d/ip-phones_grouphost_SEP010101010101.conf";})
    end

    it 'Creates the nested host configuration file correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd.d/groups.d/ip-phones_grouphost_SEP010101010101.conf')
        .with_content(/host ip-phones_grouphost_SEP010101010101 {/)
        .with_content(/hardware ethernet 01:01:01:01:01:01;/)
    end
  end
end
