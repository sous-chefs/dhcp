
actions :add, :remove 
default_action :add

attribute :name, :kind_of => String, :name_attribute => true
attribute :parameters, :kind_of => Hash, :default => []
attribute :hosts, :kind_of => Hash, :default => []
attribute :conf_dir, :kind_of => String, :default => "/etc/dhcp"

