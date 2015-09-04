# encoding: UTF-8

actions :add, :remove
default_action :add

attribute :subnet, kind_of: String, name_attribute: true
attribute :broadcast, kind_of: String
attribute :netmask, kind_of: String, required: true
attribute :routers, kind_of: Array, default: []
attribute :options, kind_of: Array, default: []
attribute :ddns, kind_of: String, default: nil
attribute :evals, kind_of: Array, default: []
attribute :key, kind_of: Hash, default: {}
attribute :zones, kind_of: Array, default: []
attribute :conf_dir, kind_of: String, default: '/etc/dhcp'
attribute :next_server, kind_of: String

include Chef::DSL::Recipe

attr_accessor :pools

def pool(&block)
  @pools ||= []
  p = dhcp_pool("#{@name}-pool#{@pools.count}", &block)
  p.action :nothing
  @pools << p
  p
end
