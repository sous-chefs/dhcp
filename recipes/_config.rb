# encoding: UTF-8

DHCP::Failover.load(node)
DHCP::DynaDns.load(node)

#
# Global DHCP config settings
#
template node[:dhcp][:config_file] do
  owner 'root'
  group 'root'
  mode 0644
  source 'dhcpd.conf.erb'
  variables(
    allows: node[:dhcp][:allows] || [],
    parameters: node[:dhcp][:parameters] || [],
    options: node[:dhcp][:options] || [],
    masters: DHCP::DynaDns.masters,
    keys: DHCP::DynaDns.keys,
    my_ip: node[:ipaddress],
    role: DHCP::Failover.role,
    peer_ip: DHCP::Failover.peer,
    failover: DHCP::Failover.enabled?
    )
  action :create
  notifies :restart, "service[#{node[:dhcp][:service_name]}]", :delayed
end

#
# Create the dirs and stub files for each resource type
#
%w{groups.d hosts.d subnets.d}.each do |dir|
  directory "#{node[:dhcp][:dir]}/#{dir}"
  file "#{node[:dhcp][:dir]}/#{dir}/list.conf" do
    action :create_if_missing
    content ''
  end
end
