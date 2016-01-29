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

describe PoiseMonitCompat::Resources::Monitrc do
  step_into(:monitrc)

  describe 'action :enable' do
    recipe do
      monit 'monit'
      monitrc 'myapp'
    end

    it { is_expected.to create_monit_config('myapp').with(parent: chef_run.monit('monit'), cookbook: 'monit', source: 'myapp.conf.erb', variables: {}) }
  end # /describe action :enable

  describe 'action :disable' do
    recipe do
      monit 'monit'
      monitrc 'myapp' do
        action :disable
      end
    end

    it { is_expected.to delete_monit_config('myapp').with(parent: chef_run.monit('monit')) }
  end # /describe action :disable
end
