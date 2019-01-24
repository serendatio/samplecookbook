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


script 'amazon extras' do
	interpreter 'bash'
	code <<-EOH
		sudo amazon-linux-extras install nginx1.12 -y
		sudo amazon-linux-extras install epel -y
		sudo amazon-linux-extras install memcached1.5 -y
		sudo amazon-linux-extras install php7.2 -y
	EOH
end


package 'nginx' do
  action :install
end

service 'nginx' do
  action [ :enable, :start ]
end

