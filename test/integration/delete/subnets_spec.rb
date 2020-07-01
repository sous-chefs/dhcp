describe file('/etc/dhcp/override/overrides.conf') do
  it { should_not exist }
  it { should_not be_file }
end
