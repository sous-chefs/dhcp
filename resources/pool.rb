default_action :nothing

attribute :range, kind_of: [Array, String]
attribute :peer, kind_of: String, default: nil
attribute :deny, kind_of: String, default: nil
