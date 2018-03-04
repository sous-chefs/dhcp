module DHCP
  # methods for managing rndc key data and dynadns bind masters
  module DynaDns
    class << self
      include Chef::DSL::DataQuery

      attr_accessor :node
      attr_accessor :zones, :keys

      def load(node)
        @node = node
        load_zones
      end

      #
      # @return [Hash] of zone_name => master_addr
      #
      def masters
        @zones ||= load_zones
        masters ||= {}
        return unless @zones
        @zones.each do |zone|
          name = zone['zone_name']
          masters[name] ||= {}

          # set to global master by default
          if node['dns'].key?(:master) && !node['dns']['master'].empty?
            masters[name]['master'] = node['dns']['master']
          end

          if node['dns'].key?(:rndc_key) && !node['dns']['rndc_key'].empty?
            masters[name]['key'] = node['dns']['rndc_key']
          end

          # use zone bag override if it exists
          if zone.key?('master_address') && !zone['master_address'].empty?
            masters[name]['master'] = zone['master_address']
          end

          if zone.key?('rndc_key') && !zone['rndc_key'].empty?
            masters[name]['key'] = zone['rndc_key']
          end

          # validate
          unless masters[name].key?('key') && masters[name].key?('master')
            masters.delete(name)
          end
        end

        masters
      end

      #
      # Fetch all keys this node requests
      #
      # @return [Hash] of key-names containing bag data for each key
      #
      def keys
        k ||= {}
        @zones ||= load_zones
        return if @zones.nil? || @zones.empty?

        # global default keys if they exist
        # TODO: need to work out the namespace on dns stuff here.
        # TODO: be good to support knife-vault/encrypted bags for keys
        if node.key?(:dns) && node['dns'].key?(:rndc_key)
          default_key = node['dns']['rndc_key']
          k[default_key] = get_key(default_key)
        end

        @zones.each { |zone| k[zone['rndc_key']] = get_key zone['rndc_key'] if zone.key? 'rndc_key' }
        k
      end

      #
      # Get a key from bag or attributes
      #
      def get_key(name)
        return data_bag_item('rndc_keys', name).to_hash if node['dhcp']['use_bags']
        node['dhcp']['rndc_keys'].fetch name, ''
      end

      #
      # Should we load zones?
      #   We only want to load zones if configured to use databags and node attribute node['dns']['zones'] is populated
      #
      def load_zones?
        return false unless node['dhcp']['use_bags']
        has_zones_attr = node['dns'] && node['dns']['zones']
        return true if has_zones_attr && !node['dns']['zones'].empty?
      end

      #
      # Load all zone bags this node calls out
      #
      def load_zones
        return nil unless load_zones?

        @zones = []
        node['dns']['zones'].each do |zone|
          bag_name = node['dns']['bag_name'] || 'dns_zones'
          zones << data_bag_item(bag_name, Dhcp::Helpers.escape(zone)).to_hash
        end
        @zones
      end
    end
  end
end
