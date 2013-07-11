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

File.open('/opt/skystack/etc/userdata.conf').each_line{ |s|

      config = s.split("=")
      key = config[0]

      if !config[1].nil?
        
          quoted = config[1].strip
          v = quoted.gsub(/"/,"")
          value = v

          if ! value.nil?
            node.set['userdata'][config[0]] = value
          end

      end
}


case node['kernel']['machine']
  when "x86_64"
    if node['userdata']['CLOUD'] == 'Linode'
      get_skystackrs_file =  "skystackrs-linode-v#{node['skystackrs']['version']}-x86_64.tgz"
    else
      get_skystackrs_file =  "skystackrs-v#{node['skystackrs']['version']}-x86_64.tgz"
    end

  when "i686"
      get_skystackrs_file =  "skystackrs-v#{node['skystackrs']['version']}-i686.tgz"
else
      get_skystackrs_file =  "skystackrs-v#{node['skystackrs']['version']}-i686.tgz"
end

execute "remove old skystackrs package" do
    cwd "/opt/skystack/downloads"
    command "rm #{get_skystackrs_file}"
    only_if do File.exists?("/opt/skystack/downloads/#{get_skystackrs_file}") end
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

directory "/tmp#{node['skystackrs']['path']}/skystackrs" do
   mode 00755
   action :create
   recursive true
   user "skystack"
   group "skystack"
end

execute "change perms" do
  command "chown -R skystack:skystack /tmp#{node['skystackrs']['path']}/skystackrs"
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