# encoding: UTF-8

module DHCP
  # methods for detecthing and reporting on failover role/peers
  module Failover
    class << self
      if  Chef::Version.new(Chef::VERSION) <= Chef::Version.new('11.0.0')
        include Chef::Mixin::Language
      else
        include Chef::DSL::DataQuery
      end

      attr_reader :node

      # rubocop:disable TrivialAccessors
      # TODO: depricate this for initialize/node accessor
      def load(node)
        @node = node
      end
      # rubocop:enable

      def enabled?
        case role
        when 'primary'
          return slaves.blank? ? false : true
        when 'secondary'
          return masters.blank? ? false : true
        end
        false
      end

      def role
        if node[:dhcp].key?(:slave) && node[:dhcp][:slave] == true
          return 'secondary'
        elsif node[:dhcp].key?(:master) && node[:dhcp][:master] == true
          return 'primary'
        end
        nil
      end

      def peer
        if node[:dhcp].key?(:slave) && node[:dhcp][:slave] == true
          peer_node = masters.first
        elsif node[:dhcp].key?(:master) && node[:dhcp][:master] == true
          peer_node  =  slaves.first
        end
        Chef::Log.info "Dhcp Peer: #{peer_node}"
        return nil if peer_node.blank?
        peer_node[:ipaddress]
      end

      def slaves
        if node[:dhcp].key?(:slaves) && !node[:dhcp][:slaves].empty?
          node[:dhcp][:slaves]
        else
          search(:node, "domain:#{node[:domain]} AND dhcp_slave:true")
        end
      end

      def masters
        if node[:dhcp].key?(:masters) && !node[:dhcp][:masters].empty?
          node[:dhcp][:masters]
        else
          search(:node, "domain:#{node[:domain]} AND dhcp_master:true")
        end
      end
    end
  end
end
