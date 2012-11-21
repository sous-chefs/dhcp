require "chef/dsl/data_query"

module DHCP
  module Failover
    class << self
      include Chef::DSL::DataQuery 

      attr :node
      def load(node)
        @node = node
      end

      def enabled?
        puts "Role: #{role}"
        if role == "primary"
          return slaves.blank? ? false : true
        end
        if role == "scondary"
          return masters.blank? ? false : true
        end
        # if no match disable
        false
      end

      def role
        if node[:dhcp].has_key? :slave and node[:dhcp][:slave] == true
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
        slave.ipaddress
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



