#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Install remi repo for yum
script 'update yum' do
    interpreter 'bash'
    code <<-EOH
    	sudo yum update -y
    EOH
end


package 'nginx' do
  action :install
end

service 'nginx' do
  action [ :enable, :start ]
end

