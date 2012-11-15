module DHCP
  module Failover
    class << self 
     include Chef::Mixin::Language

      attr_accessor :run_context
      attr_reader :slaves, :masters, :role, :peer

      def load(run_context)
        @run_context =  run_context
      end

      def node
        run_context.node
      end

      def scoped_search(scope, *args, &block)
        # extract the original query
        query = args[1] || "*:*"

        # prepend the environment to the query based on scope
        case scope
        when /domain/i,/dc/i
          args[1] = "domain:#{node[:domain]}  AND (#{query})"
        when /environment/, /env/i
          args[1] = "chef_environment:#{node[:chef_environment]} AND (#{query})"
        else
          rasie ArgumentError  "restricted search does not know how to handle scope: #{scope} "
        end

        # call the original search method
        search(*args, &block)
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
        slave  =  slaves.sort.first
        Chef::Log.info "Slave: #{slave} "
        return nil if slave.blank? 
        slave.ipaddress 
      end

      def slaves
        scoped_search("domain", :node, "dhcp_slave:true")
      end

      def masters
        scoped_search("domain", :node, "dhcp_master:true")
      end

    end
  end
end



