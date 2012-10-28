def write_include 
  file_includes = []
  run_context.resource_collection.each do |resource|
    if resource.is_a? Chef::Resource::DhcpGroup and resource.action == :add
      file_includes << "#{resource.conf_dir}/groups.d/#{resource.name}.conf"
    end
  end

  template "#{new_resource.conf_dir}/groups.d/list.conf" do
    cookbook "dhcp"
    source "list.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables( :files => file_includes )
    notifies :restart, resources(:service => node[:dhcp][:service_name]), :delayed
    notifies :send_notification, new_resource, :immediately
  end
end


action :add do
  directory "#{new_resource.conf_dir}/groups.d"

  template "#{new_resource.conf_dir}/groups.d/#{new_resource.name}.conf" do
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
    notifies :send_notification, new_resource, :immediately
  end

  write_config
end

action :remove do

  file "#{new_resource.conf_dir}/groups.d/#{new_resource.name}.conf" do
    action :delete
    notifies :restart, resources(:service => node[:dhcp][:service_name]), :delayed
    notifies :send_notification, new_resource, :immediately
  end

  write_config
end

action :send_notification do
  new_resource.updated_by_last_action(true)
end
