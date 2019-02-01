#
# Cookbook:: nginx
# Recipe:: configure
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Create the folder for nginx root if it does not already exist
directory node[:nginx][:root_dir] do
    owner  'root'
    group  'root'
    mode   '0755'
    action :create
    recursive true
end