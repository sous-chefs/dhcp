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

property :range, [Array, String]
property :peer, String
property :deny, String
property :allow, String

# This resource has no actions, and is only used to verify properties
# for the dhcp_subnet pool subresource.
