service node['dhcp']['service_name'] do
  supports restart: true, status: true, reload: true
  action [:enable]
end

template node['dhcp']['init_config'] do
  owner 'root'
  group 'root'
  mode '0644'
  source 'init_config.erb'
  variables(
    interfaces: node['dhcp']['interfaces'],
    var: node['dhcp']['init_iface']
  )
end
