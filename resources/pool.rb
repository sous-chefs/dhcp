default_action :nothing

attribute :range, kind_of: [Array, String]
attribute :peer, kind_of: String, default: nil
attribute :deny, kind_of: [Array, String], default: [], coerce: proc { |prop|
  Array(prop).flatten
}
attribute :allow, kind_of: [Array, String], default: [], coerce: proc { |prop|
  Array(prop).flatten
}
