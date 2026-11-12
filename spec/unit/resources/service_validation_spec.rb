# frozen_string_literal: true

require 'spec_helper'

describe 'DHCP service configuration validation' do
  platform 'almalinux', '9'

  recipe do
    dhcp_service 'server' do
      config_file '/etc/dhcp/config with spaces.conf'
      action :nothing
    end
  end

  let(:resource) { chef_run.dhcp_service('server') }
  let(:provider) { resource.provider_for_action(:start) }
  let(:command) { double('configuration test', stderr: 'invalid configuration') }

  before do
    provider
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/etc/dhcp/config with spaces.conf').and_return(true)
    allow(command).to receive(:run_command).and_return(command)
    allow(command).to receive(:error!)
  end

  it 'keeps a configuration path with spaces as one command argument' do
    expect(Mixlib::ShellOut).to receive(:new)
      .with(['dhcpd', '-4', '-d', '-t', '-T', '-cf', '/etc/dhcp/config with spaces.conf'], user: 'root')
      .and_return(command)
    expect(provider.configuration_valid?).to be true
  end

  it 'does not start a service whose configuration is absent' do
    allow(File).to receive(:exist?).with('/etc/dhcp/config with spaces.conf').and_return(false)
    expect(Mixlib::ShellOut).not_to receive(:new)
    expect(provider.configuration_valid?).to be false
  end

  it 'respects disabled configuration validation' do
    resource.config_test false
    expect(Mixlib::ShellOut).not_to receive(:new)
    expect(provider.configuration_valid?).to be true
  end

  context 'removal after the package and unit are already absent' do
    before do
      allow(File).to receive(:exist?).with('/etc/systemd/system/dhcpd.service').and_return(false)
      allow(provider).to receive(:shell_out).with('systemctl', 'is-active', '--quiet', 'dhcpd.service')
                                            .and_return(double(exitstatus: 3))
      allow(provider).to receive(:shell_out).with('systemctl', 'is-enabled', '--quiet', 'dhcpd.service')
                                            .and_return(double(exitstatus: 1))
    end

    it 'does not repeatedly disable a residual distro init script' do
      expect(provider.service_present_or_enabled?).to be false
    end

    it 'still stops an active service whose custom unit was removed separately' do
      allow(provider).to receive(:shell_out).with('systemctl', 'is-active', '--quiet', 'dhcpd.service')
                                            .and_return(double(exitstatus: 0))
      expect(provider.service_present_or_enabled?).to be true
    end
  end

  context 'a failed configuration test' do
    before do
      allow(Mixlib::ShellOut).to receive(:new).and_return(command)
      allow(command).to receive(:error!).and_raise(Mixlib::ShellOut::ShellCommandFailed)
    end

    it 'raises by default and prevents the service action' do
      expect { provider.configuration_valid? }.to raise_error(RuntimeError, /invalid configuration/)
    end

    it 'logs and prevents the service action when requested' do
      resource.config_test_fail_action :log
      expect(Chef::Log).to receive(:error).with(/invalid configuration/)
      expect(provider.configuration_valid?).to be false
    end
  end
end
