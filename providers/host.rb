action :add do
  filename = "#{new_resource.conf_dir}/hosts.d/#{new_resource.hostname}.conf"
  template filename do 
    cookbook "dhcp"
    source "host.conf.erb"
    variables(
      :hostname => new_resource.hostname,
      :macaddress => new_resource.macaddress,
      :ipaddress => new_resource.ipaddress,
      :options => new_resource.options
    )
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => node[:dhcp][:service_name] ), :delayed
  end
  utils_line "include \"#{filename}\";" do
    action :add
    file "#{new_resource.conf_dir}/hosts.d/host_list.conf"
    notifies :restart, resources(:service => node[:dhcp][:service_name]), :delayed
  end
end

action :remove do
  filename = "#{new_resource.conf_dir}/hosts.d/#{new_resource.name}.conf"
  if ::File.exists?(filename)
    Chef::Log.info "Removing #{new_resource.name} host from #{new_resource.conf_dir}/hosts.d/"
    file filename do
      action :delete
      notifies :restart, resources(:service => node[:dhcp][:service_name]), :delayed
    end
    new_resource.updated_by_last_action(true)
  end
  utils_line "include \"#{filename}\";" do
    action :remove
    file "#{new_resource.conf_dir}/hosts.d/host_list.conf"
    notifies :restart, resources(:service => node[:dhcp][:service_name]), :delayed
  end
end

