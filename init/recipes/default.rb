#
# Cookbook:: init
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Update yum
script 'update yum' do
    interpreter 'bash'
    code <<-EOH
    	sudo yum update -y
    EOH
end

# Install Amazon Extras 
script 'amazon extras' do
	interpreter 'bash'
	code <<-EOH
		sudo amazon-linux-extras install nginx1.12 -y
		sudo amazon-linux-extras install epel -y
		sudo amazon-linux-extras install memcached1.5 -y
		sudo amazon-linux-extras install php7.2 -y
		sudo yum install php-pear php-devel gcc libzip-devel zlib-devel php-zip php-gd -y
	EOH
end