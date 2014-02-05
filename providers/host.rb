# TODO: these should be put into a lib/mixin since we use it everywhere
def includes
  file_includes = []
  run_context.resource_collection.each do |resource|
    if resource.is_a?(Chef::Resource::DhcpHost) && resource.action == :add
      file_includes << "#{resource.conf_dir}/hosts.d/#{resource.hostname}.conf"
    end
  end
  file_includes
end

def write_include
  t = template "#{new_resource.conf_dir}/hosts.d/list.conf" do
    cookbook 'dhcp'
    source 'list.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(files: includes)
    notifies :restart, "service[#{node[:dhcp][:service_name]}]", :delayed
  end
  new_resource.updated_by_last_action(t.updated?)
end

action :add do
  directory "#{new_resource.conf_dir}/hosts.d/"

  t = template  "#{new_resource.conf_dir}/hosts.d/#{new_resource.hostname}.conf" do
    cookbook 'dhcp'
    source 'host.conf.erb'
    variables(
      name: new_resource.name,
      hostname: new_resource.hostname,
      macaddress: new_resource.macaddress,
      ipaddress: new_resource.ipaddress,
      options: new_resource.options,
      parameters: new_resource.parameters
    )
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, "service[#{node[:dhcp][:service_name]}]", :delayed
  end
  new_resource.updated_by_last_action(t.updated?)
  write_include
end

action :remove do
  f = file "#{new_resource.conf_dir}/hosts.d/#{new_resource.name}.conf" do
    action :delete
    notifies :restart, "service[#{node[:dhcp][:service_name]}]", :delayed
  end
  new_resource.updated_by_last_action(f.updated?)

  write_include
end
