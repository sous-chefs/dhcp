#
# Cookbook:: dhcp
# Resource:: class
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

property :match, String, required: true
property :conf_dir, String, default: '/etc/dhcp'
property :vendor_option_space, String
property :options, Array

attr_accessor :subclasses

def subclass(value)
  @subclasses ||= []
  @subclasses << value
end

action :add do
  directory "#{new_resource.conf_dir}/classes.d #{new_resource.name}" do
    path "#{new_resource.conf_dir}/classes.d"
  end

  template "#{new_resource.conf_dir}/classes.d/#{new_resource.name}.conf" do
    cookbook 'dhcp'
    source 'class.conf.erb'
    variables(
      name: new_resource.name,
      match: new_resource.match,
      options: new_resource.options,
      vendor_option_space: new_resource.vendor_option_space,
      subclasses: new_resource.subclasses
    )
    owner 'root'
    group 'root'
    mode '0644'
  end
end
