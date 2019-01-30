#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

#package 'nginx' do
#  action :install
#end

# service 'nginx' do
#   action [ :enable, :start ]
# end


# Create directory for app's nginx config file
directory '/etc/nginx/sites-available' do
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    recursive true
end