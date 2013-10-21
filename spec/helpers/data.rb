require 'chefspec'
require 'fauxhai'


Chef::Config[:data_bag_path] = File.dirname(__FILE__) + "/../../examples/data_bags"

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

