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

	aws_s3_file "/tmp/#{app['shortname']}.zip" do
	  bucket "serend-codebuild-bucket"
	  remote_path "/"
	  aws_access_key_id "#{node['aws_access_key_id']}"
	  aws_secret_access_key "#{node['aws_secret_access_key']}"
	  region "us-west-2"
	  action :create
	end

	# Chef::Log.info("********** #{aws['aws_access_key_id']} **********")
	# Chef::Log.info("********** #{aws['aws_secret_access_key']} **********")

	Chef::Log.info("********** #{node['aws_access_key_id']} **********")
	Chef::Log.info("********** #{node['aws_secret_access_key']} **********")

end