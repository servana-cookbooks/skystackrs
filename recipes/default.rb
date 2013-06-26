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

case node['kernel']['machine']
  when "x86_64"
      get_skystackrs_file =  "skystackrs-v#{node['skystackrs']['version']}-x86_64.tgz"
  when "i686"
      get_skystackrs_file =  "skystackrs-v#{node['skystackrs']['version']}-i686.tgz"
else
      get_skystackrs_file =  "skystackrs-v#{node['skystackrs']['version']}-i686.tgz"
end

execute "download skystackrs" do
    cwd "/opt/skystack/downloads"
    command "wget --tries=3 #{node['skystackrs']['host']}/#{get_skystackrs_file}"
    user "skystack"
    group "skystack"
end

execute "unzip skystackrs" do
  cwd node['skystackrs']['path']
  command "tar -xzf /opt/skystack/downloads/#{get_skystackrs_file}"
  user "skystack"
  group "skystack"
end

link "/etc/init.d/skystackrs" do
  to "#{node['skystackrs']['path']}/skystackrs/bin/skystackrs"
end

execute "change perms" do
  command "chown -R skystack:skystack /tmp/#{node['skystackrs']['path']}/skystackrs"
end

execute "change perms" do
  command "chown -R skystack:skystack #{node['skystackrs']['path']}/skystackrs"
end

service "skystackrs" do
  supports :start => true, :stop => true, :console => true
  action :nothing
end

service "skystackrs" do
  action :start
end