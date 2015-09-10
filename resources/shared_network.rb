actions :add, :remove
default_action :add

attribute :name, kind_of: String
attribute :conf_dir, kind_of: String, default: '/etc/dhcp'

include Chef::DSL::Recipe

attr_accessor :subnets

def subnet(name, &block)
  @subnets ||= []
  s = dhcp_subnet("#{@name}-#{name}", &block)
  s.action :nothing
  s.subnet name
  @subnets << s
  s
end
