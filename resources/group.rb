
actions :add, :remove

attribute :name, :kind_of => String, :name_attribute => true
attribute :parameters, :kind_of => Hash, :default => []
attribute :hosts, :kind_of => Hash, :default => []

def initialize(*args)
  super
  @action = :add
end


