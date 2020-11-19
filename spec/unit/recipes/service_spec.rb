require 'spec_helper'

describe 'dhcp_service' do
  step_into :dhcp_service
  platform 'centos'

  context 'create a dhcpd service' do
    recipe do
      dhcp_service 'dhcpd' do
        action [:create, :enable, :start]
      end
    end

    describe 'creates a systemd unit file' do
      it { is_expected.to create_systemd_unit('dhcpd.service') }
    end

    describe 'enables and starts dhcpd' do
      it { is_expected.to enable_service('dhcpd') }
      it { is_expected.to_not start_service('dhcpd') }
      it { is_expected.to nothing_ruby_block('Run pre dhcpd.service start configuration test') }
    end
  end

  context 'create a dhcpd6 service ' do
    recipe do
      dhcp_service 'dhcpd6' do
        ip_version :ipv6
        action [:create, :enable, :start]
      end
    end

    describe 'creates a systemd unit file' do
      it { is_expected.to create_systemd_unit('dhcpd6.service') }
    end

    describe 'enables and starts dhcpd6' do
      it { is_expected.to enable_service('dhcpd6') }
      it { is_expected.to_not start_service('dhcpd6') }
      it { is_expected.to nothing_ruby_block('Run pre dhcpd6.service start configuration test') }
    end
  end
end
