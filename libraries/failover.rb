
module DHCP
  module Failover
    class << self
      if  Chef::Version.new(Chef::VERSION) <= Chef::Version.new( "10.16.2" )
        include Chef::Mixin::Language
      else
        include Chef::DSL::DataQuery
      end

      attr :node
      def load(node)
        @node = node
      end

      def enabled?
        if role == "primary"
          return slaves.blank? ? false : true
        end
        if role == "secondary"
          return masters.blank? ? false : true
        end
        false
      end

      def role
        if node.has_key? :dhcp and  node[:dhcp].has_key? :slave and node[:dhcp][:slave] == true
          return "secondary"
        elsif node[:dhcp].has_key? :master and node[:dhcp][:master] == true
          return "primary"
        end
        nil
      end

      def peer
        slave  =  slaves.first
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



