
#
# Cookbook:: dhcp
# Resource:: service
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

property :service_name, String, default: 'dhcp'

action_class do
  def do_action(service_action)
    service new_resource.service_name do
      action service_action
    end
  end
end

action :start do
  do_action(action)
end

action :stop do
  do_action(action)
end

action :enable do
  do_action(action)
end

action :disable do
  do_action(action)
end
