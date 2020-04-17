require 'spec_helper'

describe 'dhcp_class' do
  step_into :dhcp_class
  platform 'centos'

  context 'create a dhcpd class with no subclass and verify config is created properly' do
    recipe do
      dhcp_class 'BlankClass' do
        match 'hardware'
      end
    end

    it 'Creates the class configuration file correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd.d/classes.d/BlankClass.conf')
        .with_content(/class "BlankClass" {/)
        .with_content(/  match hardware;/)
    end
  end

  context 'create a dhcpd class with subclass and verify config is created properly' do
    recipe do
      dhcp_class 'RegisteredHosts' do
        match 'hardware'
        subclass [
          '1:10:bf:48:42:55:01',
          '1:10:bf:48:42:55:02',
        ]
      end
    end

    it 'Creates the class configuration file correctly' do
      is_expected.to render_file('/etc/dhcp/dhcpd.d/classes.d/RegisteredHosts.conf')
        .with_content(/class "RegisteredHosts" {/)
        .with_content(/  match hardware;/)
        .with_content(/subclass "RegisteredHosts" 1:10:bf:48:42:55:01;/)
    end
  end
end
