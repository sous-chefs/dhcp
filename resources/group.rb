# encoding: UTF-8

actions :add, :remove
default_action :add

attribute :name, kind_of: String, name_attribute: true
attribute :parameters, kind_of: Array, default: []
attribute :evals, kind_of: Array, default: []
attribute :hosts, kind_of: Hash, default: {}
attribute :conf_dir, kind_of: String, default: '/etc/dhcp'
