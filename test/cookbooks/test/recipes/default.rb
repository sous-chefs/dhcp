#
# Cookbook:: dhcp_test
# Recipe:: default
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

include_recipe '::net_setup'

include_recipe '::package'

# Work around issue with apparmor on Ubuntu
apparmor_policy 'usr.sbin.dhcpd' if platform?('ubuntu')

include_recipe '::include_files'

include_recipe '::dhcp_config'
include_recipe '::dhcp_subnet'
include_recipe '::dhcp_host'
include_recipe '::dhcp_class'
include_recipe '::dhcp_shared_network'
include_recipe '::dhcp_group'

include_recipe '::service'
