# Cookbook Name:: skystackrs
# Recipe:: skystackrs::default
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

group node['skystackrs']['group'] do
  system true
  action :create
end

user node['skystackrs']['user'] do
  gid node['skystackrs']['group']
  shell "/bin/bash"
  supports :manage_home => false
  system true
  action :create
end

execute "change perms" do
	command "chown -R skystack:skystack /opt/skystack"
end

#group node['skystackrs']['group'] do
#  action :modify
#  members "#{node['skystackrs']['user']}"
#  append true
#end

directory '/opt/skystack' do
    mode 00755
    action :create
    owner 'skystack'
    group 'skystack'
    recursive true
end

directory '/opt/skystack/logs/skystackrs' do
    mode 00755
    action :create
    owner 'skystack'
    group 'skystack'
    recursive true
end

execute "download skystackrs" do
	cwd "#{node['skystackrs']['path']}"
	command "wget #{node['skystackrs']['host']}/#{node['skystackrs']['version']}/client.skystackrs-master.zip"
	user "skystack"
	group "skystack"
end

execute "unzip skystackrs" do
	cwd "#{node['skystackrs']['path']}"
	command "unzip client.skystackrs-master.zip"
	user "skystack"
	group "skystack"
end

execute "delete zip skystackrs" do
    cwd node['skystackrs']['path']}
    command "rm client.skystackrs-master.zip"
    user "skystack"
    group "skystack"
end

execute "delete skystackrs if exists" do
	cwd node['skystackrs']['path']
	command "rm -rf #{node['skystackrs']['path']}/skystackrs"
	user "skystack"
	group "skystack"
	only_if do File.exists?("#{node['skystackrs']['path']}/skystackrs") end
end

execute "move new skystackrs" do
	cwd node['skystackrs']['path']
	command "mv #{node['skystackrs']['path']}/client.skystackrs-master #{node['skystackrs']['path']}/skystackrs"
	user "skystack"
	group "skystack"
	only_if do !File.exists?("#{node['skystackrs']['path']}/skystackrs") end
end

execute "change perms" do
	command "chown -R skystack:skystack /opt/skystack"
end

execute "move skystackrs" do
	cwd "#{node['skystackrs']['path']}/skystackrs"
	command "make"
	user "skystack"
	group "skystack"
end

link "#{node['skystackrs']['path']}/skystackrs/log" do
 	to "/opt/skystack/logs/skystackrs"
 	owner 'skystack'
 	group 'skystack'
end

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

service "skystackrs" do
  action :start
end 