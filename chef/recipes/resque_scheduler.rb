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
# Some code used under MIT license
# Copyright Alex Soto
#

include_recipe 'monit'

monit_config 'resque_scheduler' do
  content <<-EOH
check process resque_scheduler with pidfile #{node['monit']['resque']['app_root']}/tmp/pids/resque_scheduler.pid
  group resque_scheduler
  start program = "/usr/bin/env PATH=/usr/local/bin:/usr/local/ruby/bin:/usr/bin:/bin:$PATH RACK_ENV=#{node.chef_environment} /bin/sh -l -c 'cd #{node['monit']['resque']['app_root']} && nohup bundle exec rake environment resque:scheduler RAILS_ENV=#{node.chef_environment} QUEUE=* VERBOSE=1 INITIALIZER_PATH=#{node['monit']['resque']['app_root']}/config/initializers/resque.rb PIDFILE=#{node['monit']['resque']['app_root']}/tmp/pids/resque_scheduler.pid & >> log/resque_scheduler.log 2>&1'" with timeout 90 seconds
  stop program = "/bin/sh -c 'cd #{node['monit']['resque']['app_root']} && kill -9 `cat tmp/pids/resque_scheduler.pid` && rm -f tmp/pids/resque_scheduler.pid; exit 0;'"
  if totalmem is greater than 300 MB for 10 cycles then restart
EOH
end
