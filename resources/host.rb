
actions :add, :remove, :send_notification
default_action :add

attribute :hostname, :kind_of => String, :name_attribute => true
attribute :macaddress, :kind_of => String
attribute :ipaddress, :kind_of => String
attribute :options, :kind_of => Array, :default => []
attribute :parameters, :kind_of => Array, :default => []
attribute :conf_dir, :kind_of => String, :default => "/etc/dhcp"

