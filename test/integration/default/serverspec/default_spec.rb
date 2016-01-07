# #
# # Copyright 2015, Noah Kantrowitz
# #
# # Licensed under the Apache License, Version 2.0 (the "License");
# # you may not use this file except in compliance with the License.
# # You may obtain a copy of the License at
# #
# # http://www.apache.org/licenses/LICENSE-2.0
# #
# # Unless required by applicable law or agreed to in writing, software
# # distributed under the License is distributed on an "AS IS" BASIS,
# # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# # See the License for the specific language governing permissions and
# # limitations under the License.
# #

require 'serverspec'
set :backend, :exec

describe file('/usr/bin/monit') do
  it { is_expected.to exist }
  it { is_expected.to be_a_file }
end

describe file('/etc/monit/monitrc') do
  it { is_expected.to exist }
  it { is_expected.to be_a_file }
end

describe command('monit -c /etc/monit/monitrc -V') do
  its(:exit_status) { is_expected.to eq 0 }
end

describe command('monit -c /etc/monit/monitrc status') do
  its(:exit_status) { is_expected.to eq 0 }
  its(:stdout) { is_expected.to include 'System' }
end
