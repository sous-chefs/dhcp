# ib dhcp server only setup


# NOTE: static config for now
# TODO: refactor!!

include_recipe "network"

ifconfig "192.168.11.1" do 
  mask "255.255.255.0"
  device "ib0"
end


# enable forwarding 
sysctl "net.ipv4.ip_forward" do 
  value  1 
end

service "iptables" do 
  action :nothing 
end

#
# put out iptables configureation
# NOTE: this clobbers iptables rght now
#
template "/etc/sysconfig/iptables" do
  source "ib_masq_iptables.erb"
  owner "root"
  group "root"
  mode  0644
  notifies :restart, resources(:service =>"iptables" )
end

service "iptables" do
  action [ :enable, :start ]
end
