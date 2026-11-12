# frozen_string_literal: true

require 'spec_helper'

describe 'dhcp_package' do
  step_into :dhcp_package

  context 'Debian installation' do
    platform 'debian', '12'
    recipe { dhcp_package 'server' }

    it 'installs both Debian server components' do
      is_expected.to install_package('ISC DHCPD').with(package_name: %w(isc-dhcp-server isc-dhcp-server-ldap))
    end
  end

  context 'RHEL installation' do
    platform 'almalinux', '9'
    recipe { dhcp_package 'server' }

    it 'selects the current RHEL family server package' do
      is_expected.to install_package('ISC DHCPD').with(package_name: ['dhcp-server'])
    end
  end

  context 'explicit package removal' do
    platform 'debian', '12'
    recipe do
      dhcp_package 'server' do
        packages ['custom-dhcp']
        action :remove
      end
    end

    it 'respects the caller package override on removal' do
      is_expected.to remove_package('ISC DHCPD').with(package_name: ['custom-dhcp'])
    end
  end
end
