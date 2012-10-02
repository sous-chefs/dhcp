
action :add do
  filename = "#{new_resource.conf_dir}/subnets.d/#{new_resource.subnet}.conf"
  template filename do 
    cookbook "dhcp"
    source "subnet.conf.erb"
    variables(
      :subnet => new_resource.subnet,
      :netmask => new_resource.netmask,
      :broadcast => new_resource.broadcast,
      :routers => new_resource.routers,
      :options => new_resource.options,
      :range => new_resource.range,
      :peer => new_resource.peer
    )
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => node[:dhcp][:service_name]), :delayed
  end
end

action :remove do
  filename = "#{new_resource.conf_dir}/subnets.d/#{new_resource.name}.conf"
  if ::File.exists?(filename)
    Chef::Log.info "Removing #{new_resource.name} subnet from #{new_resource.conf_dir}/subnets.d/"
    file filename do
      action :delete
      notifies :restart, resources(:service => node[:dhcp][:service_name]), :delayed
    end
    new_resource.updated_by_last_action(true)
  end
end

