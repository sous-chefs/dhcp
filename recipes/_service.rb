
service node[:dhcp][:service_name] do
  supports :restart => true, :status => true, :reload => true
  action [ :enable ]
  # use upstart on ubuntu > 9.10
  case node[:platform]
  when "ubuntu"
    if node[:platform_version].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
end

template node[:dhcp][:init_config] do
  owner "root"
  group "root"
  mode 0644
  source "init_config.erb"
  variables(
    :interfaces => node[:dhcp][:interfaces],
    :var => node[:dhcp][:init_iface]
  )
end
