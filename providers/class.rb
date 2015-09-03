include Dhcp::Helpers

action :add do
  run_context.include_recipe 'dhcp::_service'

  directory "#{new_resource.conf_dir}/classes.d"

  t = template "#{new_resource.conf_dir}/classes.d/#{new_resource.name}.conf" do
    cookbook 'dhcp'
    source 'class.conf.erb'
    variables name: new_resource.name, match: new_resource.match, subclasses: new_resource.subclasses
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
  end
  new_resource.updated_by_last_action(t.updated?)

  write_include 'classes.d'
end
