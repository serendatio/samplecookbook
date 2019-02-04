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

	Chef::Log.info("********* #{application}, #{deploy[:application]} ***********")
	Chef::Log.info("********* #{node[:app][:name]} ***********")
	

	# aws_s3_file "/tmp/#{deploy[:application]}" do
	#   bucket "test-site-config"
	#   remote_path "vhost.map"
	#   aws_access_key_id node[:custom_access_key]
	#   aws_secret_access_key node[:custom_secret_key]
	# end

end