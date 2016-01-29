#
# Copyright 2015-2016, Noah Kantrowitz
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

require 'spec_helper'

describe 'monit::default' do
  step_into(:monit)
  step_into(:monit_config)
  recipe { include_recipe 'monit' }
  before do
    allow_any_instance_of(PoiseMonit::Resources::Monit::Resource).to receive(:monit_version).and_return(Gem::Version.create('5.15'))
    override_attributes['monit'] ||= {}
    override_attributes['monit']['eventqueue'] ||= {}
  end

  context 'with defaults' do
    it { is_expected.to enable_monit('monit').with(daemon_interval: 60, event_slots: 1000, httpd_port: '/var/run/monit.sock', logfile: 'syslog facility log_daemon', var_path: '/var/monit') }
    it { is_expected.to install_package('monit') }
    it { is_expected.to render_file('/etc/monit/monitrc') }
    it { is_expected.to render_file('/etc/monit/conf.d/compat.conf').with_content(/\A\s*\Z/) }
  end # /context with defaults

  context 'with node["monit"]["logfile"]' do
    before { override_attributes['monit']['logfile'] = '/log' }
    it { is_expected.to enable_monit('monit').with(logfile: '/log') }
  end # /context with node["monit"]["logfile"]

  context 'with node["monit"]["poll_period"]' do
    before { override_attributes['monit']['poll_period'] = 200 }
    it { is_expected.to enable_monit('monit').with(daemon_interval: 200) }
  end # /context with node["monit"]["poll_period"]

  context 'with node["monit"]["eventqueue"]["set"]' do
    before { override_attributes['monit']['eventqueue']['set'] = false }
    it { is_expected.to enable_monit('monit').with(event_slots: 0) }
  end # /context with node["monit"]["eventqueue"]["set"]

  context 'with node["monit"]["eventqueue"]["basedir"]' do
    before { override_attributes['monit']['eventqueue']['basedir'] = '/events' }
    it { is_expected.to enable_monit('monit').with(var_path: '/events') }
  end # /context with node["monit"]["eventqueue"]["basedir"]

  context 'with node["monit"]["eventqueue"]["slots"]' do
    before { override_attributes['monit']['eventqueue']['slots'] = 200 }
    it { is_expected.to enable_monit('monit').with(event_slots: 200) }
  end # /context with node["monit"]["eventqueue"]["slots"]

  context 'with basic httpd config' do
    before do
      override_attributes['monit']['username'] = 'super'
      override_attributes['monit']['password'] = 'secretz'
    end
    it { is_expected.to enable_monit('monit').with(httpd_port: false) }
    it { is_expected.to render_file('/etc/monit/conf.d/compat.conf').with_content(<<-EOH) }
set httpd port 3737
  allow super:secretz
EOH
  end # /context with basic httpd config

  context 'with complex httpd config' do
    before do
      override_attributes['monit']['address'] = '10.0.0.1'
      override_attributes['monit']['allow'] = %w{192.168.0.0/16}
      override_attributes['monit']['password'] = 'secretz'
      override_attributes['monit']['ssl'] = true
      override_attributes['monit']['username'] = 'super'
    end
    it { is_expected.to enable_monit('monit').with(httpd_port: false) }
    it { is_expected.to render_file('/etc/monit/conf.d/compat.conf').with_content(<<-EOH) }
set httpd port 3737
  use address 10.0.0.1
  allow 192.168.0.0/16
  allow super:secretz
  ssl enable
  pemfile /etc/monit/monit.pem
EOH
  end # /context with complex httpd config

  context 'with a notification config' do
    before { override_attributes['monit']['notify_email'] = 'admins@example.com' }
    it { is_expected.to render_file('/etc/monit/conf.d/compat.conf').with_content(<<-EOH) }
set mailserver localhost
  with timeout 60 seconds

set mail-format {
  from: monit@chefspec.local
  subject: $SERVICE $EVENT
  message: Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
Yours sincerely,
monit

}

set alert admins@example.com NOT ON { action, instance, pid, ppid }
EOH
  end # /context with a notification config
end
