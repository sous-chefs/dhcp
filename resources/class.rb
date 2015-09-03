actions :add
default_action :add

attribute :match, kind_of: String, required: true
attribute :conf_dir, kind_of: String, default: '/etc/dhcp'

attr_accessor :subclasses

def subclass(value)
  @subclasses ||= []
  @subclasses << value
end
