# Cookbook Name:: outpost
# Recipe:: outpost::default
# 
# Copyright 2012, Skystack, Ltd.
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

include_recipe "erlang"

execute "cd #{node['skystackrs']['path']}; wget #{node['outpost']['host']}/#{node['outpost']['version']}/client.skystackrs-master.zip"
execute "cd #{node['skystackrs']['path']}; unzip client.skystackrs-master.zip"
execute "mv #{node['skystackrs']['path']}/client.skystackrs-master #{node['skystackrs']['path']}/skystackrs"
execute "cd #{node['skystackrs']['path']}/skystackrs; make;"

service "skystackrs" do
  supports :start => true, :stop => true, :debug => true
  action :nothing
end 

template "skystackrs" do
  path "/etc/init.d/skystackrs"
  source "skystackrs.init.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[skystackrs]"
  notifies :start, "service[skystackrs]"
end