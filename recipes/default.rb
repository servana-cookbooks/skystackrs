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

cookbook_file "/opt/skystack/local/skystackrs.zip" do
  source "skystackrs.zip"
  owner "root"
  group "skystack"
  mode "0644"
  ignore_failure true
end

execute "cd /opt/skystack/local; unzip skystackrs.zip"
execute "cd /opt/skystack/local/skystackrs; make; ./start.sh"

#get source for outpost

#install it

#start it