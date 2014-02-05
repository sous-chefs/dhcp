
module DHCP
  module Failover
    class << self
      if  Chef::Version.new(Chef::VERSION) <= Chef::Version.new('11.0.0')
        include Chef::Mixin::Language
      else
        include Chef::DSL::DataQuery
      end

      attr_reader :node
      def load(node)
        @node = node
      end

      def enabled?
        if role == 'primary'
          return slaves.blank? ? false : true
        end
        if role == 'secondary'
          return masters.blank? ? false : true
        end
        false
      end

      def role
        if node[:dhcp].key? :slave and node[:dhcp][:slave] == true
          return 'secondary'
        elsif node[:dhcp].key? :master and node[:dhcp][:master] == true
          return 'primary'
        end
        nil
      end

      def peer
        if node[:dhcp].key? :slave and node[:dhcp][:slave] == true
          slave = masters.first
        elsif node[:dhcp].key? :master and node[:dhcp][:master] == true
          slave  =  slaves.first
        end
        Chef::Log.info "Dhcp Slave: #{slave}"
        return nil if slave.blank?
        slave[:ipaddress]
      end

      def slaves
        search(:node, "domain:#{node[:domain]} AND dhcp_slave:true")
      end

      def masters
        search(:node, "domain:#{node[:domain]} AND dhcp_master:true")
      end
    end
  end
end
