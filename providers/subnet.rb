include Dhcp::Helpers

action :add do
  with_run_context :root do
    run_context.include_recipe 'dhcp::_service'

    directory "#{new_resource.conf_dir}/subnets.d #{new_resource.name}" do
      path "#{new_resource.conf_dir}/subnets.d"
    end

    template "#{new_resource.conf_dir}/subnets.d/#{new_resource.name}.conf" do
      cookbook 'dhcp'
      source 'subnet.conf.erb'
      variables(
        subnet: new_resource.subnet,
        netmask: new_resource.netmask,
        broadcast: new_resource.broadcast,
        pools: new_resource.pools,
        routers: new_resource.routers,
        options: new_resource.options,
        evals: new_resource.evals,
        key: new_resource.key,
        zones: new_resource.zones,
        ddns: new_resource.ddns,
        next_server: new_resource.next_server
      )
      owner 'root'
      group 'root'
      mode '0644'
      notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
    end

    write_include 'subnets.d', new_resource.name
  end
end

action :remove do
  with_run_context :root do
    file "#{new_resource.conf_dir}/subnets.d/#{new_resource.name}.conf" do
      action :delete
      notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
      notifies :send_notification, new_resource, :immediately
    end

    write_include 'subnets.d', new_resource.name
  end
end
