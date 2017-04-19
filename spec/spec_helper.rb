require 'chefspec'
require 'chefspec/policyfile'
require 'json'
require 'pry'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
  config.log_level = :error
end

def parse_data_bag(path)
  data_bags_path = File.expand_path(File.join(File.dirname(__FILE__), '../test/integration/data_bags'))
  JSON.parse(File.read("#{data_bags_path}/#{path}.json"))
end
