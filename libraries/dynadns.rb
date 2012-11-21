
module DHCP
  module DynaDns 
    class  << self  
      if  Chef::Version.new(Chef::VERSION) <= Chef::Version.new( "10.16.2" )
        include Chef::Mixin::Language
      else
        include Chef::DSL::DataQuery
      end
 
      attr :node
      def load(node)
        @node = node
      end


      
      # need to refactor 
      # for all the zones this env has pull in the rndc_keys and push them out to dhcp config
      # as well as the zone master ip for ddns to work
      def rndc_keys
        # this only should fire if we actually have work to do 
        unless node.has_key? :dns and node[:dns].has_key? :zones and node[:dns][:zones].blank? != true 
          return nil
        end
        zones = {}
        rndc_keys = {}
        
        node[:dns][:zones].each do |zone|
          # load the zone
         
          bag_name = node[:dns][:bag_name] || "dns_zones" 
          zone_data = data_bag_item(bag_name, Helpers::DataBags.escape_bagname(zone) )
          name = zone_data["zone_name"]
          zones[name] ||= {}

          # use global/environment master by default, but let zones specify if they wish
          # this way we can host for zones that don't exist here.
          # do the same for key
          zones[name]["master"] = node[:dns][:master] if node[:dns].has_key? :master
          if zone_data.has_key? "master_address"
            zones[name]["master"] = zone_data["master_address"]
          end

          zones[name]["keys"] = node[:rndc_keys] if node.has_key? :rndc_keys
          if zone_data.has_key? "rndc_keys"
            zones[name]["keys"] =   zone_data["rndc_keys"]
          end
        end

        zones
      end

    end
  end
end
