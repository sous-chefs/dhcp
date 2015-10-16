require 'chefspec'
require 'chefspec/policyfile'

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

require 'json'

def load_json(f)
  JSON.parse(IO.read(f)) || {}
end

def bag_dir
  File.expand_path(File.dirname(__FILE__)) + '/../test/integration/data_bags'
end

def blank_bags
  stub_data_bag_item('dhcp_networks', '192-168-1-0_24').and_return({})
  stub_data_bag_item('dns_zones', '192-168-1-0').and_return({})
  stub_data_bag_item('rndc_keys', nil).and_return({})
  stub_data_bag_item('dns_zones', '192-168-1-0').and_return({})
end

def file_bags
  stub_data_bag_item('rndc_keys', 'dhcp-key').and_return(
    load_json "#{bag_dir}/rndc_keys/dhcp-key.json")
  stub_data_bag_item('dns_zones', '192-168-1-0').and_return(
    load_json "#{bag_dir}/dns_zones/192-168-1-0.json")
  stub_data_bag_item('dns_zones', 'vm').and_return(
    load_json "#{bag_dir}/dns_zones/vm.json")
end

module Helpers
  # Extending Helpers::DataBags
  module DataBags
    class << self
      # escape  . -> - and / -> _
      # so 1.1/3 -> 1-1_3
      def escape(name)
        n = name.gsub(/\./, '-')
        n.gsub(%r{\/}, '_')
      end
      alias_method :escape_bagname, :escape
    end
  end
end
