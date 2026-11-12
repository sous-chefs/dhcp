# frozen_string_literal: true

require 'spec_helper'

describe 'dhcp_service' do
  step_into :dhcp_service
  platform 'almalinux', '9'

  context 'an explicitly suffixed unit name' do
    recipe do
      dhcp_service 'custom' do
        service_name 'custom.service'
        action :create
      end
    end

    it 'does not append the systemd suffix twice' do
      is_expected.to create_systemd_unit('custom.service')
    end
  end

  context 'Oracle Linux' do
    platform 'oracle', '8'
    recipe { dhcp_service('server') { action :create } }

    it 'creates the supported RHEL family unit' do
      is_expected.to create_systemd_unit('dhcpd.service')
    end
  end

  context 'an older non-systemd host' do
    platform 'redhat', '6'
    recipe do
      dhcp_service 'server' do
        action [:create, :enable]
      end
    end

    it 'preserves the native service path without creating a systemd unit' do
      is_expected.to enable_service('dhcpd')
      is_expected.not_to create_systemd_unit('dhcpd.service')
    end
  end

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
      it { is_expected.to enable_systemd_unit('dhcpd.service') }
      it { is_expected.to_not start_systemd_unit('dhcpd.service') }
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
      it { is_expected.to enable_systemd_unit('dhcpd6.service') }
      it { is_expected.to_not start_systemd_unit('dhcpd6.service') }
    end
  end
end
