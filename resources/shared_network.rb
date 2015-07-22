actions :add, :remove
default_action :add

attribute :name, kind_of: String
attribute :conf_dir, kind_of: String, default: '/etc/dhcp'

include Chef::DSL::Recipe

attr_accessor :subnets

def subnet(name, &block)
  @subnets ||= []
  Chef::Log.debug "Creating subnet #{name}"
  s = dhcp_subnet(name, &block)
  s.action :nothing
  @subnets << s
  s
end
