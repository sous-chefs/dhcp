# encoding: UTF-8
#
# Author:: Jesse Nelson <spheromak@gmail.com>
# Author:: Matt Ray <matt@chef.io>
# Cookbook:: dhcp
# Recipe:: server
#
# Copyright:: 2012-2017, Jesse Nelson
# Copyright:: 2011-2017, Chef Software, Inc
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

include_recipe 'dhcp::_package'
include_recipe 'dhcp::_service'
include_recipe 'dhcp::_config'
include_recipe 'dhcp::_networks'
include_recipe 'dhcp::_groups'
include_recipe 'dhcp::_hosts'
