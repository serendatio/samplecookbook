define :opsworks_deploy_user do
  deploy = params[:deploy_data]

  group deploy[:group]

  user deploy[:user] do
    action :create
    comment "deploy user"
    uid next_free_uid
    gid deploy[:group]
    home deploy[:home]
    # supports :manage_home => true
    manage_home true
    shell deploy[:shell]
    not_if do
      existing_usernames = []
      Etc.passwd {|user| existing_usernames << user['name']}
      existing_usernames.include?(deploy[:user])
    end
  end
end

# Helper
def next_free_uid(starting_from = 4000)
  candidate = starting_from
  existing_uids = @@allocated_uids
  (node[:passwd] || node[:etc][:passwd]).each do |username, entry|
    existing_uids << entry[:uid] unless existing_uids.include?(entry[:uid])
  end
  while existing_uids.include?(candidate) do
    candidate += 1
  end
  @@allocated_uids << candidate
  candidate
end