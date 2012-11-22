
module DHCP
  module DynaDns 
    class  << self  
      if  Chef::Version.new(Chef::VERSION) <= Chef::Version.new( "10.16.2" )
        include Chef::Mixin::Language
      else
        include Chef::DSL::DataQuery
      end

      attr :node, :zones, :keys

      def load(node)
        @node = node
        load_zones
      end

      #
      # Returns a hash of zone_name => master_addr
      #
      def masters
        @zones ||= load_zones
        masters ||= Hash.new
        return unless @zones
        @zones.each do |zone|
          name = zone["zone_name"]
          masters[name] ||= Hash.new

          # set to global master by default
          if node[:dns].has_key? :master and node[:dns][:master].blank? != true
            masters[name]["master"] = node[:dns][:master] 
          end

          if node[:dns].has_key? :rndc_key and node[:dns][:rndc_key].blank? != true
            masters[name]["key"] = node[:dns][:rndc_key]
          end

          # use zone bag override if it exists
          if zone.has_key? "master_address" and  zone["master_address"].blank? != true
            masters[name]["master"] = zone["master_address"]
          end

          if zone.has_key? "rndc_key" and zone["rndc_key"].blank? != true
             masters[name]["key"] = zone["rndc_key"]
          end

          # validate
          unless masters[name].has_key? "key" and masters[name].has_key? "master" 
            masters.delete(name)
          end
        end

        masters
      end

      #
      # Fetch all keys this node requests
      # Returns a hash of key-names containing bag data for each key
      #
      def keys
        k ||= Hash.new
        @zones ||= load_zones
        return unless @zones 

        # global default keys if they exist
        if node.has_key? :dns  and node[:dns].has_key? :rndc_key
          k[node[:dns][:rndc_key]] = data_bag_item("rndc_keys", node[:dns][:rndc_key])
        end

        @zones.each do |zone|
          name = zone["zone_name"]
          if zone.has_key? "rndc_key" 
            k[zone['rndc_key']] = data_bag_item("rndc_keys", zone["rndc_key"]).to_hash
          end
        end
        k
      end

      # 
      # Load all zone bags this node calls out
      # 
      def load_zones
        unless node.has_key? :dns and node[:dns].has_key? :zones and node[:dns][:zones].blank? != true 
          return nil
        end

        @zones =  Array.new
        node[:dns][:zones].each do |zone|
          bag_name = node[:dns][:bag_name] || "dns_zones" 
          zones << data_bag_item(bag_name, Helpers::DataBags.escape_bagname(zone) ).to_hash
        end
        @zones
      end

    end
  end
end
