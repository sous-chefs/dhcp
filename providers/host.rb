include Dhcp::Helpers

action :add do
  directory "#{new_resource.conf_dir}/hosts.d #{new_resource.name}" do
    path "#{new_resource.conf_dir}/hosts.d"
  end

  template "#{new_resource.conf_dir}/hosts.d/#{new_resource.name}.conf" do
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
    mode '0644'
    notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
  end
  write_include 'hosts.d', new_resource.name
end

action :remove do
  file "#{new_resource.conf_dir}/hosts.d/#{new_resource.name}.conf" do
    action :delete
    notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
  end

  write_include 'hosts.d', new_resource.name
end
