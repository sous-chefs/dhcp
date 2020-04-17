describe file('/etc/dhcp_override/overrides.conf') do
  it { should_not exist }
  it { should_not be_file }
end
