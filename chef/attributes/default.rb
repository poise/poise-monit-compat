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

default['monit']['notify_email'] = nil
default['monit']['alert_blacklist'] = %w( action instance pid ppid )

default['monit']['logfile'] = 'syslog facility log_daemon'

default['monit']['poll_period'] = 60

default['monit']['mail_format']['subject'] = '$SERVICE $EVENT'
default['monit']['mail_format']['from'] = "monit@#{node['fqdn']}"
default['monit']['mail_format']['message'] = <<-EOS
Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
Yours sincerely,
monit
EOS

default['monit']['mailserver']['host'] = 'localhost'
default['monit']['mailserver']['hostname'] = nil
default['monit']['mailserver']['port'] = nil
default['monit']['mailserver']['username'] = nil
default['monit']['mailserver']['password'] = nil
default['monit']['mailserver']['password_suffix'] = nil
default['monit']['mailserver']['encryption'] = nil
default['monit']['mailserver']['timeout'] = 60

default['monit']['port'] = 3737
default['monit']['address'] = nil
default['monit']['ssl'] = false
default['monit']['cert'] = '/etc/monit/monit.pem'
default['monit']['allow'] = []
default['monit']['username'] = nil
default['monit']['password'] = nil

default['monit']['eventqueue']['set'] = true
default['monit']['eventqueue']['basedir'] = '/var/monit'
default['monit']['eventqueue']['slots'] = 1000

default['monit']['ssh_port'] = 22

default['monit']['postgres']['pid_file'] = '/var/run/postgresql/9.1-main.pid'
default['monit']['postgres']['unix_socket_path'] = '/var/run/postgresql/.s.PGSQL'
default['monit']['postgres']['port'] = 5432

default['monit']['unicorn']['pid_dir'] = '/path/to/pids'
default['monit']['unicorn']['worker_count'] = 1
