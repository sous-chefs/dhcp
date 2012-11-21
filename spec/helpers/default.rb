require 'chefspec'
require 'fauxhai'

# add blank?
class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

def stub_search(result)
  Chef::Node.any_instance.stub(:search).and_return(result)
end

def dummy_nodes
  @slave = Fauxhai::mock do |node| 
    node[:dhcp] ||= Hash.new
    node[:dhcp][:slave] = true
    node[:ipaddress] = "10.1.1.20"
  end

  @master = Fauxhai::mock do |node| 
    node[:dhcp] ||= Hash.new
    node[:dhcp][:master] = true
    node[:ipaddress] = "10.1.1.10"
  end
end


