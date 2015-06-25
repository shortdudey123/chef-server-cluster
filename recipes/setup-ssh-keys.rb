#
# Cookbook Name:: chef-server-cluster
# Recipes:: setup-ssh-keys
# Author: Joshua Timberman <joshua@getchef.com>
# Copyright (C) 2014, Chef Software, Inc. <legal@getchef.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This needs to move to a chef_vault_item, and use our internal `data`
# convention for the sub-key of where the secrets are. It should also
# use an attribute for the name, so basically uncomment this line when
# we're ready for that.
# ssh_keys = chef_vault_item('vault', node['chef-server-cluster']['chef-provisioner-key-name'])['data']
ssh_keys = data_bag_item('secrets', node['chef-server-cluster']['chef-provisioner-key-name'])
key_dir  = File.join(Dir.home, '.ssh')
key_name = node['chef-server-cluster']['driver']['machine_options']['bootstrap_options']['key_name']

directory key_dir do
  recursive true
end

file File.join(key_dir, key_name) do
  content ssh_keys['private_ssh_key']
  sensitive true
end

file File.join(key_dir, "#{key_name}.pub") do
  content ssh_keys['public_ssh_key']
  sensitive true
end
