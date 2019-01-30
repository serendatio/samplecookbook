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

# Install remi repo for yum
script 'update yum' do
    interpreter 'bash'
    code <<-EOH
    	sudo yum update -y
    EOH
end


# Install remi repo for yum
script 'install libsystemd' do
    interpreter 'bash'
    code <<-EOH
    	sudo yum install libsystemd -y
    	sudo yum install libsystemd-devel -y
    EOH
end


# Install remi repo for yum
script 'install php72' do
    interpreter 'bash'
    code <<-EOH
    	sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
		sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
		sudo yum -y install yum-utils
		sudo subscription-manager repos --enable=rhel-7-server-optional-rpms
		sudo yum-config-manager --enable remi-php72
		sudo yum -y update
		sudo yum -y search php72 | more
		sudo yum -y install php72 php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd php72-php-xml php72-php-xmlrpc php72-php-opcache
    EOH
end