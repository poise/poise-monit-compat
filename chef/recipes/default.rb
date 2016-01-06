#
# Copyright 2015, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Transfer over node attributes as needed.
node.force_override['poise-monit']['recipe']['daemon_interval'] = node['monit']['poll_period']
node.force_override['poise-monit']['recipe']['logfile'] = node['monit']['logfile']
if node['monit']['eventqueue']['set']
  node.force_override['poise-monit']['recipe']['var_path'] = node['monit']['eventqueue']['basedir']
  node.force_override['poise-monit']['recipe']['event_slots'] = node['monit']['eventqueue']['slots']
else
  node.force_override['poise-monit']['recipe']['var_path'] = false
end
# We're handling the HTTPD settings in the compat config.
node.force_override['poise-monit']['recipe']['httpd_port'] = false

# If no specific provider was requested, force it to use system.
unless node['poise-monit']['monit'] && node['poise-monit']['monit']['provider']
  node.force_override['poise-monit']['monit']['provider'] = 'system'
end

include_recipe 'poise-monit'

monit_config 'compat' do
  source 'compat.conf.erb'
  variables node['monit']
end