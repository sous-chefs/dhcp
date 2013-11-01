require 'spec_helper'

# simple example
describe package( "yum" ) do
  case backend(Serverspec::Commands::Base).check_os
  when "RedHat"
    it { should be_installed }
  else
    it { should_not be_installed }
  end
end
