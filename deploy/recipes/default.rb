# include_recipe 'dependencies'
include_recipe "deploy"


node[:deploy].each do |application, deploy|

  opsworks_deploy_user do
    deploy_data deploy
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    app application
    deploy_data deploy
  end

  nginx_web_app application do
    application deploy
  end

  Chef::Log.info("Running composer update on #{deploy[:deploy_to]}")

end
