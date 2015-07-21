# encoding: UTF-8

include Dhcp::Helpers

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

  write_include 'groups.d'
end

action :remove do
  f = file "#{new_resource.conf_dir}/groups.d/#{new_resource.name}.conf" do
    action :delete
    notifies :restart, "service[#{node[:dhcp][:service_name]}]", :delayed
  end
  new_resource.updated_by_last_action(f.updated?)

  write_include 'groups.d'
end
