# frozen_string_literal: true
#
# Cookbook:: dhcp
# Resource:: pool
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

default_action :nothing

attribute :range, kind_of: [Array, String]
attribute :peer, kind_of: String, default: nil
attribute :deny, kind_of: [Array, String], default: [], coerce: proc { |prop|
  Array(prop).flatten
}
attribute :allow, kind_of: [Array, String], default: [], coerce: proc { |prop|
  Array(prop).flatten
}

# This resource has no actions, and is only used to verify properties
# for the dhcp_subnet pool subresource.
