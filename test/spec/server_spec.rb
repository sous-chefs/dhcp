require_relative 'helpers/default'

recipe = "dhcp::server"

describe recipe do
  let (:chef_run) { ChefSpec::ChefRunner.new(
    platform:'ubuntu', version:'12.04'
  ).converge recipe }
  before do
    Fauxhai.mock(platform:'ubuntu', version:'12.04') do |n|
      # Set node attributes
      n['chef_environment'] = 'production'
    end
  end

end

