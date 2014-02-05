# make sure ifconfig is there on deb/ubu 
# my docker images don't have it
if node.platform_family == 'debian'
  package 'net-tools'
end

ifconfig "192.168.9.1" do
  device 'eth0:0'
end
