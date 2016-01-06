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

monit_config 'ssh' do
  content <<-EOH
CHECK PROCESS sshd WITH PIDFILE /var/run/sshd.pid
  START PROGRAM "/usr/sbin/service ssh start"
  STOP PROGRAM "/usr/sbin/service ssh stop"
  # under load a check may fail intermittently, so give it a few tries before restarting
  IF FAILED PORT #{node['monit']['ssh_port']} PROTOCOL ssh 4 TIMES WITHIN 6 CYCLES THEN RESTART
EOH
end
