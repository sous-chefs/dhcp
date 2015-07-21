# encoding: UTF-8

include Dhcp::Helpers

action :add do
  directory "#{new_resource.conf_dir}/subnets.d/"

  range = new_resource.range
  range = [new_resource.range] if new_resource.range.is_a? String
  t = template "#{new_resource.conf_dir}/subnets.d/#{new_resource.name}.conf" do
    cookbook 'dhcp'
    source 'subnet.conf.erb'
    variables(
      subnet: new_resource.subnet,
      netmask: new_resource.netmask,
      broadcast: new_resource.broadcast,
      routers: new_resource.routers,
      options: new_resource.options,
      range: range,
      peer: new_resource.peer,
      evals: new_resource.evals,
      key: new_resource.key,
      zones: new_resource.zones,
      ddns: new_resource.ddns
    )
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, "service[#{node[:dhcp][:service_name]}]", :delayed
  end
  new_resource.updated_by_last_action(t.updated?)

  write_include 'subnets.d'
end

action :remove do
  f = file "#{new_resource.conf_dir}/subnets.d/#{new_resource.name}.conf" do
    action :delete
    notifies :restart, "service[#{node[:dhcp][:service_name]}]", :delayed
    notifies :send_notification, new_resource, :immediately
  end
  new_resource.updated_by_last_action(f.updated?)
  write_include 'subnets.d'
end
