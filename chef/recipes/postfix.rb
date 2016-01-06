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

monit_config 'postfix' do
  content <<-EOH
CHECK PROCESS postfix WITH PIDFILE /var/spool/postfix/pid/master.pid
  start program = "/etc/init.d/postfix start"
  stop  program = "/etc/init.d/postfix stop"
  GROUP mail
  IF FAILED PORT 25 PROTOCOL smtp THEN restart
  IF 5 RESTARTS WITHIN 5 CYCLES THEN timeout
EOH
end
