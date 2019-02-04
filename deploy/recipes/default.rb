#
# Cookbook:: deploy
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

include_recipe 'aws'

Chef::Log.info("********* Running deploy::default ***********")

node[:deploy].each do |application, deploy|

	Chef::Log.info("********* #{application}, #{deploy[:application]} ***********")
	Chef::Log.info("********* #{node[:deploy][application]} ***********")
	

	# aws_s3_file "/tmp/#{deploy[:application]}" do
	#   bucket "test-site-config"
	#   remote_path "vhost.map"
	#   aws_access_key_id node[:custom_access_key]
	#   aws_secret_access_key node[:custom_secret_key]
	# end

end