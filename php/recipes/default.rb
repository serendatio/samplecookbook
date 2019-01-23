#
# Author::  Joshua Timberman (<joshua@chef.io>)
# Author::  Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: php
# Recipe:: default
#
# Copyright:: 2009-2018, Chef Software, Inc.
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

# include_recipe "php::#{node['php']['install_method']}"

# # update the main channels
# node['php']['pear_channels'].each do |channel|
#   php_pear_channel channel do
#     binary node['php']['pear']
#     action :update
#     only_if { node['php']['pear_setup'] }
#   end
# end

# include_recipe 'php::ini'


# ## Set package names to install PHP 7.0 on Amazon Linux
# node.default['php']['packages'] = %w[
#   php70 php70-common php70-curl php70-devel php70-mbstring
#   php70-mcrypt php70-mysqlnd php70-opcache php70-pdo php7-pear
#   php70-pecl-apcu php70-readline
# ]

# # Set PECL and PEAR binary for Amazon Linux PHP 7.0
# node.default['php']['pear'] = 'pear7'
# node.default['php']['pecl'] = 'pecl7'

# # Run default recipe
# include_recipe 'php'

script 'add remi repo for yum' do
    interpreter 'bash'
    code <<-EOH
        cd /tmp
        wget http://rpms.remirepo.net/enterprise/remi-release-6.rpm
        sudo rpm -Uvh remi-release*rpm
    EOH
end

# Install php yaml
script 'install php-yaml' do
    interpreter 'bash'
    code <<-EOH
        sudo yum -y --enablerepo=remi-php72 install php72-php-pecl-yaml
        sudo mv /opt/remi/php72/root/usr/lib64/php/modules/yaml.so /usr/lib64/php/7.2/modules/yaml.so
    EOH

    not_if { ::File.exists?("/usr/lib64/php/7.2/modules/yaml.so") }
end