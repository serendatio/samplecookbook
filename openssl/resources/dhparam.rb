#
# Copyright:: Copyright 2009-2018, Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

chef_version_for_provides '< 14.0' if respond_to?(:chef_version_for_provides)
resource_name :openssl_dhparam

include OpenSSLCookbook::Helpers

property :path,        String, name_property: true
property :key_length,  equal_to: [1024, 2048, 4096, 8192], default: 2048
property :generator,   equal_to: [2, 5], default: 2
property :owner,       String
property :group,       String
property :mode,        [Integer, String], default: '0640'

action :create do
  unless dhparam_pem_valid?(new_resource.path)
    converge_by("Create a dhparam file #{new_resource.path}") do
      dhparam_content = gen_dhparam(new_resource.key_length, new_resource.generator).to_pem

      log "Generating #{new_resource.key_length} bit "\
          "dhparam file at #{new_resource.path}, this may take some time"

      file new_resource.path do
        action :create
        owner new_resource.owner unless new_resource.owner.nil?
        group new_resource.group unless new_resource.group.nil?
        mode new_resource.mode
        sensitive true
        content dhparam_content
      end
    end
  end
end
