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
	  bucket "https://s3-us-west-2.amazonaws.com/serend-codebuild-bucket"
	  remote_path "#{app['app_source']['url']}"
	  aws_access_key_id node[:custom_access_key]
	  aws_secret_access_key node[:custom_secret_key]
	end

end