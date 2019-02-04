#
# Cookbook:: deploy
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

include_recipe 'aws'

Chef::Log.info("********* Running deploy::default ***********")

app = search("aws_opsworks_app").first
Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")

search("aws_opsworks_app").each do |app|
  Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
  Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")
end


node[:deploy].each do |application, deploy|

	# Transfer source file from S3
	aws_s3_file "/tmp/#{app['shortname']}-#{node['env']}.zip" do
	  bucket "serend-codebuild-bucket"
	  remote_path "#{app['shortname']}-#{node['env']}.zip"
	  aws_access_key_id "#{node['aws_access_key_id']}"
	  aws_secret_access_key "#{node['aws_secret_access_key']}"
	  region "us-west-2"
	  action :create
	end

	# Timestamp variable
	time =  Time.new.strftime("%Y%m%d%H%M%S")

	# Create the folder for nginx root if it does not already exist
	directory "/mnt/nginx/#{app['shortname']}/"+time do
	    owner  'root'
	    group  'root'
	    mode   '0755'
	    action :create
	    recursive true
	end

	# Move files and symlink to current target
	bash "deploy_application" do 
		user "root"
        code <<-EOH
            unzip /tmp/#{app['shortname']}-#{node['env']}.zip -d /mnt/nginx/#{app['shortname']}/#{time}
            ln -sfn /mnt/nginx/#{app['shortname']}/#{time} /mnt/nginx/#{app['shortname']}/current
            ln -sfn /mnt/nginx/#{app['shortname']}/current/nginx.conf /etc/nginx/conf.d/#{app['shortname']}.conf
            rm /tmp/#{app['shortname']}-#{node['env']}.zip 
        EOH
	end

	# Reload nginx service
    service 'nginx' do
        supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
        action [:reload]
    end

    # Restart php-fpm service
    service 'php-fpm' do
        supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
        action [:restart]
    end

end