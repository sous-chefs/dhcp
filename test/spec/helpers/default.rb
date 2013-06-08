require 'chefspec'


# add blank?
class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

def stub_search(result)
  Chef::Node.any_instance.stub(:search).and_return(result)
end

# Redirects stderr and stdout to /dev/null.
def silence_output
  @orig_stderr = $stderr.dup
  @orig_stdout = $stdout.dup
  $stderr = File.new('/dev/null', 'w')
  $stdout = File.new('/dev/null', 'w')
end

# Replace stdout and stderr so anything else is output correctly.
def enable_output
  $stderr = @orig_stderr
  $stdout = @orig_stdout
  @orig_stderr = nil
  @orig_stdout = nil
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


