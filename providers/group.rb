
action :add do
  filename = "#{new_resource.conf_dir}/groups.d/#{new_resource.name}.conf"
  Chef::Log.info "Generating group #{new_resource.name}: #{filename} "
  template filename do 
    cookbook "dhcp"
    source "group.conf.erb"
    variables(
      :name => new_resource.name,
      :parameters => new_resource.parameters,
      :hosts => new_resource.hosts
    )
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => node[:dhcp][:service_name]), :delayed
  end
end

action :remove do
  filename = "#{new_resource.conf_dir}/groups.d/#{new_resource.name}.conf"
  if ::File.exists?(filename)
    Chef::Log.info "Removing #{new_resource.name} group from #{new_resource.conf_dir}/groups.d/"
    file filename do
      action :delete
      notifies :restart, resources(:service => node[:dhcp][:service_name]), :delayed
    end
    new_resource.updated_by_last_action(true)
  end
end

