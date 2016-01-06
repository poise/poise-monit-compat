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

[todo]

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
