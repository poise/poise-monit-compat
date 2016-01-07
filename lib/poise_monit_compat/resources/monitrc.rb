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

require 'chef/provider'
require 'chef/resource'
require 'poise'


module PoiseMonitCompat
  module Resources
    # (see Monitrc::Resource)
    # @since 1.0.0
    module Monitrc

      # A `monitrc` resource to install and configure Monit.
      #
      # @provides monitrc
      # @action enable
      # @action disable
      # @example
      #   monitrc 'postfix'
      class Resource < Chef::Resource
        include Poise(parent: :monit)
        provides(:monitrc)
        actions(:enable, :disable)

        # @!attribute reload
        #   Unusued, only present for compat.
        #   @return [nil]
        attribute(:reload)
        # @!attribute template_cookbook
        #   Cookbook to load the template from. Defaults to "monit".
        #   @return [String]
        attribute(:template_cookbook, kind_of: String, default: 'monit')
        # @!attribute template_source
        #   Path to the template source file. Defaults to "$name.conf.erb".
        #   @return [String]
        attribute(:template_source, kind_of: String, default: lazy { "#{name}.conf.erb" })
        # @!attribute variables
        #   Variables for the template.
        #   @return [Hash]
        attribute(:variables, kind_of: Hash, default: lazy { {} })
      end

      # The provider for `monitrc`.
      #
      # @see Resource
      # @provides monitrc
      class Provider < Chef::Provider
        include Poise
        provides(:monitrc)

        # An `enable` action for `monitrc`.
        #
        # @return [void]
        def action_enable
          notifying_block do
            monit_config new_resource.name do
              cookbook new_resource.template_cookbook
              options new_resource.variables
              parent new_resource.parent
              source new_resource.template_source
            end
          end
        end

        # A `disable` action for `monitrc`.
        #
        # @return [void]
        def action_disable
          notifying_block do
            monit_config new_resource.name do
              action :delete
              parent new_resource.parent
            end
          end
        end
      end

    end
  end
end
