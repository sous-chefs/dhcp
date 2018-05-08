include Dhcp::Helpers

action :add do
  with_run_context :root do
    directory "#{new_resource.conf_dir}/groups.d #{new_resource.name}" do
      path "#{new_resource.conf_dir}/groups.d"
    end

    template "#{new_resource.conf_dir}/groups.d/#{new_resource.name}.conf" do
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
      mode '0644'
      notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
    end

    write_include 'groups.d', new_resource.name
  end
end

action :remove do
  with_run_context :root do
    file "#{new_resource.conf_dir}/groups.d/#{new_resource.name}.conf" do
      action :delete
      notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
    end

    write_include 'groups.d', new_resource.name
  end
end
