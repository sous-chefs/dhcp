# encoding: UTF-8

include_recipe 'dhcp::_service'

DHCP::Failover.load(node)
DHCP::DynaDns.load(node)

#
# Global DHCP config settings
#
template node['dhcp']['config_file'] do
  owner 'root'
  group 'root'
  mode 0644
  source 'dhcpd.conf.erb'
  variables(
    allows: node['dhcp']['allows'] || [],
    parameters: node['dhcp']['parameters'] || [],
    options: node['dhcp']['options'] || [],
    hooks: node['dhcp']['hooks'],
    masters: DHCP::DynaDns.masters,
    keys: DHCP::DynaDns.keys,
    my_ip: node['dhcp']['my_ip'] || node['ipaddress'],
    role: DHCP::Failover.role,
    peer_ip: DHCP::Failover.peer,
    failover: DHCP::Failover.enabled?
  )
  action :create
  notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
end

if node['dhcp']['failover_lease_hack']
  template node['dhcp']['dhcpd_leases'] do
    owner 'root'
    group 'root'
    mode 0644
    source 'dhcpd.leases-hack.erb'
    action :create
    notifies :restart, "service[#{node['dhcp']['service_name']}]"
    not_if { ::File.exist?("#{node['dhcp']['dhcpd_leases']}-hack.lock") }
  end

  file "#{node['dhcp']['dhcpd_leases']}-hack.lock" do
    owner 'root'
    group 'root'
    mode '0755'
    action :touch
  end
end

#
# Create the dirs and stub files for each resource type
#
%w(groups.d hosts.d subnets.d shared_networks.d classes.d).each do |dir|
  directory "#{node['dhcp']['dir']}/#{dir}"
  file "#{node['dhcp']['dir']}/#{dir}/list.conf" do
    action :create_if_missing
    content ''
  end
end
