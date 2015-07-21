# encoding: UTF-8

def includes
  run_context.resource_collection.map do |resource|
    next if Gem::Version.new(Chef::VERSION) >= Gem::Version.new('12.0.0') && resource.declared_type != new_resource.declared_type
    next if Gem::Version.new(Chef::VERSION) < Gem::Version.new('12.0.0') && resource.resource_name != new_resource.resource_name
    next unless resource.action == :add || resource.action.include?(:add)
    "#{resource.conf_dir}/groups.d/#{resource.name}.conf"
  end.compact
end

def write_include
  t = template "#{new_resource.conf_dir}/groups.d/list.conf" do
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
  directory "#{new_resource.conf_dir}/groups.d"

  t = template "#{new_resource.conf_dir}/groups.d/#{new_resource.name}.conf" do
    cookbook 'dhcp'
    source 'group.conf.erb'
    variables(
      name: new_resource.name,
      parameters: new_resource.parameters,
      evals: new_resource.evals,
      hosts: new_resource.hosts
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

  f = file "#{new_resource.conf_dir}/groups.d/#{new_resource.name}.conf" do
    action :delete
    notifies :restart, "service[#{node[:dhcp][:service_name]}]", :delayed
  end
  new_resource.updated_by_last_action(f.updated?)

  write_include
end
