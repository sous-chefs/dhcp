require 'chefspec'
require 'json'

blank_bags = Proc.new do
  stub_data_bag_item("dhcp_networks", "192-168-1-0_24").and_return({})
  stub_data_bag_item("dns_zones", "192-168-1-0").and_return({})
  stub_data_bag_item("rndc_keys", nil).and_return({})
  stub_data_bag_item("dns_zones", "192-168-1-0").and_return({})
end

def load_json(f)
  JSON.parse( IO.read(f) )
end

def bag_dir
  "../../integration/data_bags"
end

file_bags = Proc.new do
  stub_data_bag_item("dns_zones", "192-168-1-0").and_return(
    load_json "#{bag_dir}/dns_zones/192-168-1-0.json")
  stub_data_bag_item("dns_zones", "vm").and_return(
    load_json "#{bag_dir}/dns_zones/vm.json")
end

module Helpers
  module DataBags
    class << self

      # escape  . -> - and / -> _
      # so 1.1/3 -> 1-1_3
      def escape(name)
        n = name.gsub(/\./,'-')
        n.gsub(/\//,'_')
      end
      alias :escape_bagname :escape

    end
  end
end

