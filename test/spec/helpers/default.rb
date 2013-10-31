require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '12.04'
end

# add blank?
class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end
