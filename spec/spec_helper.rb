require 'chefspec'
require 'chefspec/policyfile'
require 'json'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '12.04'
  config.log_level = :error
end

# add blank?
class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

def parse_data_bag(path)
  data_bags_path = File.expand_path(File.join(File.dirname(__FILE__), '../test/integration/data_bags'))
  JSON.parse(File.read("#{data_bags_path}/#{path}.json"))
end
