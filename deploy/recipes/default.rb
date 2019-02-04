#
# Cookbook:: deploy
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

Chef::Log.info("********* Running deploy::default ***********")

node[:deploy].each do |application, deploy|

	Chef::Log.info("********* #{application}, #{deploy} ***********")

end