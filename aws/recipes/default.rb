# This cookbook is no longer needed to load the aws-sdk and can be removed
# from node run_lists without any impact

include_recipe 'aws'

Chef::Log.warn('The default aws recipe does nothing. See the readme for information on using the aws resources')

# Create amazon linux 2 modified certbot from s3
aws_s3_file "/usr/local/bin/certbot-auto" do
  bucket "serend-codebuild-bucket"
  remote_path "certbot-auto"
  aws_access_key_id "#{node['aws_access_key_id']}"
  aws_secret_access_key "#{node['aws_secret_access_key']}"
  region "us-west-2"
  action :create
end