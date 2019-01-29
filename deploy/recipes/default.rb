include_recipe 'aws'

aws_s3_file "/tmp" do
  bucket "serend-codebuild-bucket"
  remote_path "serend-dev.zip"
  aws_access_key_id "AKIAIYFNRVWFW6K3GQAA"
  aws_secret_access_key "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"
end