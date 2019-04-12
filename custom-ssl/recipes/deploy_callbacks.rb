#
# Cookbook Name:: deploy
# Recipe:: custom-php
#

include_recipe 'deploy'

Chef::Log.info("********* Running custom-ssl::deploy_callbacks ***********")


node[:deploy].each do |application, deploy|


    Chef::Log.info("********* Running custom_ssl for #{deploy[:application]} ***********")

    custom_ssl application do
        application deploy
        deploy_data deploy
    end

end
