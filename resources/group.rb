# frozen_string_literal: true
#
# Cookbook:: dhcp
# Resource:: group
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default_action :add

property :parameters, Array, default: []
property :evals, Array, default: []
property :hosts, Hash, default: {}
property :conf_dir, String, default: '/etc/dhcp'

action_class do
  include Dhcp::Helpers
end

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
