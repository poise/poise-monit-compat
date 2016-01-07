# Monit Cookbook

[![Build Status](https://img.shields.io/travis/poise/poise-monit-compat.svg)](https://travis-ci.org/poise/poise-monit-compat)
[![Gem Version](https://img.shields.io/gem/v/poise-monit-compat.svg)](https://rubygems.org/gems/poise-monit-compat)
[![Cookbook Version](https://img.shields.io/cookbook/v/monit.svg)](https://supermarket.chef.io/cookbooks/monit)
[![Coverage](https://img.shields.io/codecov/c/github/poise/poise-monit-compat.svg)](https://codecov.io/github/poise/poise-monit-compat)
[![Gemnasium](https://img.shields.io/gemnasium/poise/poise-monit-compat.svg)](https://gemnasium.com/poise/poise-monit-compat)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

A **deprecated** [Chef](https://www.chef.io/) cookbook to manage [Monit](https://mmonit.com/monit/).

**IMPORTANT:** This cookbook is deprecated in favor of
[`poise-monit`](https://github.com/poise/poise-monit/) and exists only for
compatibility with the [previous `monit` cookbook](https://github.com/apsoto/monit/).
Aside from critical fixes, no further development is planned.

Compatibility is provided for existing attributes, recipes, and the `monitrc`
definition (now a resource). Internal structure has changed so wrappers using
`chef-rewind` may not be compatible.

## Recipes

* `monit::default` – Install Monit. Included automatically by all other recipes.
* `monit::postfix` – Create a Monit service to monitor Postfix.
* `monit::postgresql` – Create a Monit service to monitor PostgreSQL.
* `monit::rabbitmq` – Create a Monit service to monitor RabbitMQ.
* `monit::resque` – Create a Monit service to monitor Resque.
* `monit::resque_scheduler` – Create a Monit service to monitor `rake resque:scheduler`.
* `monit::ssh` – Create a Monit service to monitor sshd.
* `monit::unicorn` – Create a Monit service to monitor Unicorn.

## Attributes

* `node['monit']['notify_email']` – Email address to send alert notifications to. If not set, no emails are generated. *(default: nil)*
* `node['monit']['alert_blacklist']` – Event types to add to the alert blacklist. *(default: %[action instance pid ppid])*
* `node['monit']['logfile']` – Path to log messages to. *(default: syslog facility log_daemon)*
* `node['monit']['poll_period']` – Interval in seconds to check all Monit services at. *(default: 60)*

* `node['monit']['mail_format']['subject']` – Subject for Monit alert emails. *(default: $SERVICE $EVENT)*
* `node['monit']['mail_format']['from']` – From address for Monit alert emails. *(default: monit@node['fqdn'])*
* `node['monit']['mail_format']['message']` – Email body for Monit alert emails. *(default: [see attributes.rb](https://github.com/poise/poise-monit-compat/blob/master/chef/attributes/default.rb#L29-L33))*

* `node['monit']['mailserver']['host']` – SMTP server to send emails. *(default: localhost)*
* `node['monit']['mailserver']['hostname']` – Hostname for SMTP HELO/EHLO. *(default: nil)*
* `node['monit']['mailserver']['port']` – SMTP port to send emails. *(default: nil)*
* `node['monit']['mailserver']['username']` – SMTP username to send emails. *(default: nil)*
* `node['monit']['mailserver']['password']` – SMTP password to send emails. *(default: nil)*
* `node['monit']['mailserver']['password_suffix']` – SMTP password suffix to send emails. *(default: nil)*
* `node['monit']['mailserver']['encryption']` – Monit TLS settings to send emails. *(default: nil)*
* `node['monit']['mailserver']['timeout']` – Timeout for sending emails. *(default: 60)*

* `node['monit']['eventqueue']['set']` – Enable Monit's on-disk event queue. *(default: true)*
* `node['monit']['eventqueue']['basedir']` – Base path for Monit's on-disk event queue. *(default: /var/monit)*
* `node['monit']['eventqueue']['slots']` – Number of slots for Monit's on-disk event queue. *(default: 1000)*

The following HTTPD settings are only used if either a password is set or at least
one value is added to the `allow` array. Otherwise a safer auto-generated
configuration is used. Setting these incorrectly may leave the `monit` command
line tool non-functional.

* `node['monit']['port']` – Port to listen on for Monit's HTTPD interface. *(default: 3737)*
* `node['monit']['address']` – Local address to bind to for Monit's HTTPD interface. *(default: nil)*
* `node['monit']['ssl']` – Enable TLS for Monit's HTTPD interface. *(default: false)*
* `node['monit']['cert']` – Path the TLS certificate for Monit's HTTPD interface. *(default: '/etc/monit/monit.pem')*
* `node['monit']['allow']` – Array of ACL values for Monit's HTTPD interface. *(default: [])*
* `node['monit']['username']` – Username to add to the ACL for Monit's HTTPD interface. *(default: nil)*
* `node['monit']['password']` – Password to add to the ACL for Monit's HTTPD interface. *(default: nil)*


For the `monit::postgres` recipe:

* `node['monit']['postgres']['pid_file']` – Path to the PID file to monitor for PostgreSQL. *(default: /var/run/postgresql/9.1-main.pid)*
* `node['monit']['postgres']['unix_socket_path']` – Path to the listener socket to monitor for PostgreSQL. *(default: /var/run/postgresql/.s.PGSQL)*
* `node['monit']['postgres']['port']` – Port to monitor for PostgreSQL. *(default: 5432)*

For the `monit::ssh` recipe:

* `node['monit']['ssh_port']` – Port to monitor for sshd. *(default: 22)*

For the `monit::unicorn` recipe:

* `node['monit']['unicorn']['pid_dir']` – Path to the PID file to monitor for Unicorn. *(default: /path/to/pids)*
* `node['monit']['unicorn']['worker_count']` – Number of Unicorn workers to create. *(default: 1)*

**NOTE:** The `monit::resque` and `monit::resque_scheduler` recipes require
additional attributes to function, however no default values are set so this
behavior is undocumented to match the original `monit` cookbook.

## Resources

### `monitrc`

The `monitrc` resource creates a Monit configuration file. This is a
compatibility wrapper for `monit_config` from `poise-monit`.

```ruby
monitrc 'myapp' do
  template_cookbook 'mycookbook'
  template_source 'myapp.conf.erb'
end
```

#### Actions

* `:enable` – Create the configuration. *(default)*
* `:disable` – Delete the configuration.

#### Properties

* `reload` – Unusued, present only for compatibility.
* `template_cookbook` – Cookbook to load the template from. *(default: monit)*
* `template_source` – Path to the template source file. *(default: $name.conf.erb)*
* `variables` – Variables for the template.

## Sponsors

Development sponsored by [Bloomberg](http://www.bloomberg.com/company/technology/).

The Poise test server infrastructure is sponsored by [Rackspace](https://rackspace.com/).

## License

Copyright 2015, Noah Kantrowitz

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Some code used under MIT license.

Copyright Alex Soto
