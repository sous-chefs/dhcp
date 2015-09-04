if defined?(ChefSpec)
  ChefSpec.define_matcher :dhcp_subnet
  ChefSpec.define_matcher :dhcp_shared_network
  ChefSpec.define_matcher :dhcp_pool

  def add_dhcp_subnet(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:dhcp_subnet, :add, resource_name)
  end

  def remove_dhcp_subnet(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:dhcp_subnet, :remove, resource_name)
  end

  def add_dhcp_shared_network(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:dhcp_shared_network, :add, resource_name)
  end

  def remove_dhcp_shared_network(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:dhcp_shared_network, :remove, resource_name)
  end

  def add_dhcp_class(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:dhcp_class, :add, resource_name)
  end
end
