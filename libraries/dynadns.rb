# encoding: UTF-8
#
module DHCP
  # methods for managing rndc key data and dynadns bind masters
  module DynaDns
    class  << self
      if  Gem::Version.new(Chef::VERSION) <= Gem::Version.new('10.16.2')
        include Chef::Mixin::Language
      else
        include Chef::DSL::DataQuery
      end

      attr_accessor :node
      attr_accessor :zones, :keys

      def load(node)
        @node = node
        load_zones
      end

      #
      # Returns a hash of zone_name => master_addr
      # rubocop:disable CyclomaticComplexity, MethodLength, AbcSize, PerceivedComplexity
      def masters
        @zones ||= load_zones
        masters ||= {}
        return unless @zones
        @zones.each do |zone|
          name = zone['zone_name']
          masters[name] ||= {}

          # set to global master by default
          if node['dns'].key?(:master) && node['dns']['master'].blank? == false
            masters[name]['master'] = node['dns']['master']
          end

          if node['dns'].key?(:rndc_key) && node['dns']['rndc_key'].blank? == false
            masters[name]['key'] = node['dns']['rndc_key']
          end

          # use zone bag override if it exists
          if zone.key?('master_address') && zone['master_address'].blank? == false
            masters[name]['master'] = zone['master_address']
          end

          if zone.key?('rndc_key') && zone['rndc_key'].blank? == false
            masters[name]['key'] = zone['rndc_key']
          end

          # validate
          unless masters[name].key?('key') && masters[name].key?('master')
            masters.delete(name)
          end
        end

        masters
      end
      # rubocop:enable CyclomaticComplexity, MethodLength

      #
      # Fetch all keys this node requests
      # Returns a hash of key-names containing bag data for each key
      def keys
        k ||= {}
        @zones ||= load_zones
        return if @zones.blank?

        # global default keys if they exist
        # TODO: need to work out the namespace on dns stuff here.
        # TODO: be good to support knife-vault/encrypted bags for keys
        if node.key?(:dns) && node['dns'].key?(:rndc_key)
          k[node.normal['dns']['rndc_key']] = get_key node['dns']['rndc_key']
        end

        @zones.each do |zone|
          k[zone['rndc_key']] = get_key zone['rndc_key'] if zone.key? 'rndc_key'
        end
        k
      end
      # rubocop:enable MethodLength

      #
      # Get a key from bag or attributes
      #
      def get_key(name)
        key = nil
        if node['dhcp']['use_bags'] == true
          key = data_bag_item('rndc_keys', name).to_hash
        else
          key = node['dhcp']['rndc_keys'].fetch name, ''
        end
        key
      end

      #
      # Load all zone bags this node calls out
      #
      def load_zones
        unless node['dhcp']['use_bags'] == true && node.key?(:dns) && node['dns'].key?(:zones) && node['dns']['zones'].blank? != true
          return nil
        end

        @zones =  []
        node['dns']['zones'].each do |zone|
          bag_name = node['dns']['bag_name'] || 'dns_zones'
          zones << data_bag_item(bag_name, Helpers::DataBags.escape_bagname(zone)).to_hash
        end
        @zones
      end
    end
  end
end
