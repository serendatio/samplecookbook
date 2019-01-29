include_recipe 'aws'

aws_s3_file "/tmp" do
  bucket "serend-codebuild-bucket"
  remote_path "serend-dev.zip"
  aws_access_key_id node[:custom_access_key]
  aws_secret_access_key node[:custom_secret_key]
end