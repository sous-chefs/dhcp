require 'spec_helper'

# simple example
describe package('yum') do
  case os[:family]
  when 'redhat'
    it { should be_installed }
  else
    it { should_not be_installed }
  end
end
