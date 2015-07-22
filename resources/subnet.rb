# encoding: UTF-8

actions :add, :remove
default_action :add

attribute :subnet, kind_of: String, name_attribute: true
attribute :broadcast, kind_of: String
attribute :netmask, kind_of: String, required: true
attribute :routers, kind_of: Array, default: []
attribute :options, kind_of: Array, default: []
attribute :range, kind_of: [Array, String]
attribute :ddns, kind_of: String, default: nil
attribute :peer, kind_of: String, default: nil
attribute :evals, kind_of: Array, default: []
attribute :key, kind_of: Hash, default: {}
attribute :zones, kind_of: Array, default: []
attribute :conf_dir, kind_of: String, default: '/etc/dhcp'
attribute :next_server, kind_of: String
