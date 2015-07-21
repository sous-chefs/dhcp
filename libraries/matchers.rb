if defined?(ChefSpec)
  ChefSpec.define_matcher :dhcp_subnet

  def add_dhcp_subnet(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:dhcp_subnet, :add, resource_name)
  end

  def remove_dhcp_subnet(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:dhcp_subnet, :remove, resource_name)
  end
end
