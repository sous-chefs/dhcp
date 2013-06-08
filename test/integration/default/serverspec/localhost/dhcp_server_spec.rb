require 'spec_helper'

%w{ apache2 git-core curl unzip }.each do |i|
  describe package( i ) do
    it { should be_installed }
  end
end

%w{ /etc/apache2/ports.conf /etc/apache2/sites-available/default }.each do |i|
  describe file( i ) do
    it { should be_file }
  end
end

describe file( '/var/www/index.html' ) do
  it { should be_file }
end

describe file( '/var/www/img' ) do
  it { should be_directory }
end

describe service( 'apache2' ) do
  it { should be_enabled }
  it { should be_running }
end
