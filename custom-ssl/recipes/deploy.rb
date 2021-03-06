#
# Cookbook Name:: deploy
# Recipe:: custom-php
#

include_recipe 'deploy'

Chef::Log.info("********* Running custom-ssl::deploy ***********")

search("aws_opsworks_app").each do |app|

    Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
    Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")
    Chef::Log.info("********** The app's URL is '#{app['attributes']}' **********")
    Chef::Log.info("********** The app's URL is '#{app['data_sources']}' **********")
    Chef::Log.info("********** The app's URL is '#{app['domains']}' **********")
    Chef::Log.info("********** The app's URL is '#{app['enable_ssl']}' **********")
    Chef::Log.info("********** The app's URL is '#{app['environment']}' **********")

    # SSL Config
    directory "#{node[:custom_ssl][:dir]}" do
        action :create
        owner "root"
        group "root"
        mode '0600'
    end

    # # Load Certificate (if specified by App)
    # template "#{node[:custom_ssl][:dir]}/#{app['shortname']}.crt" do
    #     mode '0600'
    #     source "ssl.erb"
    #     variables :data => deploy[:ssl_certificate]
    #     only_if do
    #         deploy[:ssl_support]
    #     end
    # end

    # # Load Certificate Key (if specified by App)
    # template "#{node[:custom_ssl][:dir]}/#{app['shortname']}.key" do
    #     mode '0600'
    #     source "ssl.erb"
    #     variables :data => deploy[:ssl_certificate_key]
    #     only_if do
    #         deploy[:ssl_support]
    #     end
    # end

    # # Load Certificate Authority (if specified by App)
    # template "#{node[:custom_ssl][:dir]}/#{app['shortname']}.ca" do
    #     mode '0600'
    #     source "ssl.erb"
    #     variables :data => deploy[:ssl_certificate_ca]
    #     only_if do
    #         deploy[:ssl_support] && deploy[:ssl_certificate_ca]
    #     end
    # end

    # Create a Self-Signed Certificate (if one was NOT specified by App)
    script 'create self-signed certificate' do
        interpreter 'bash'
        # not_if do
        #     deploy[:ssl_support]
        # end
        code <<-EOH
            # Bash shell script for generating self-signed certs.
            #
            # Large portions of this script were taken from the following article:
            # http://usrportage.de/archives/919-Batch-generating-SSL-certificates.html
            #
            # Additional alterations by: Brad Landers
            # Date: 2012-01-27
            #
            # Additional alterations by: Serend Software Inc
            # Date: 2016-08-26


            # Function to clean up PASSPHRASE ENV var if the script fails
            fail_if_error() {
                [ $1 != 0 ] && {
                    unset PASSPHRASE
                    exit 10
                }
            }

            # Prepare
            cd /var/tmp
            rm -f #{app['shortname']}.key
            rm -f #{app['shortname']}.key.org
            rm -f #{app['shortname']}.csr
            rm -f #{app['shortname']}.crt

            # Generate a passphrase
            export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 128; echo)

            # Certificate details; replace items in angle brackets with your own info
            subj="/C=CA/ST=British Columbia/L=Vancouver/O=serend.io"

            # Generate the server private key
            openssl genrsa -des3 -out #{app['shortname']}.key -passout env:PASSPHRASE 2048
            fail_if_error $?

            # Generate the CSR
            openssl req \
                -new \
                -batch \
                -subj "$(echo -n "$subj" | tr "\n" "/")" \
                -key #{app['shortname']}.key \
                -out #{app['shortname']}.csr \
                -passin env:PASSPHRASE
            fail_if_error $?
            cp #{app['shortname']}.key #{app['shortname']}.key.org
            fail_if_error $?

            # Strip the password so we don't have to type it every time we restart Apache
            openssl rsa -in #{app['shortname']}.key.org -out #{app['shortname']}.key -passin env:PASSPHRASE
            fail_if_error $?

            # Generate the certificate (good for 10 years)
            openssl x509 -req -days 3650 -in #{app['shortname']}.csr -signkey #{app['shortname']}.key -out #{app['shortname']}.crt
            fail_if_error $?

            # Set Permissions
            chmod 600 #{app['shortname']}.key
            chmod 600 #{app['shortname']}.crt

            # Move Certificate in place
            mv -f #{app['shortname']}.key #{node[:custom_ssl][:dir]}
            mv -f #{app['shortname']}.crt #{node[:custom_ssl][:dir]}

            # Clean up
            rm -f #{app['shortname']}.key.org
            rm -f #{app['shortname']}.csr
        EOH
    end

    # Install Cert Bot
    # Usage :  /usr/local/bin/certbot-auto certonly --debug --agree-tos --email devops@serend.io --webroot --webroot-path /mnt/nginx/app/current -d app.serend.io -n
    # --debug is required to run certbot on aws linux
    # Removing existing cerfitifate - TEMP
    script 'certbot_install' do
        interpreter 'bash'
        # not_if do
        #     "'#{app['enable_ssl']}'"
        # end
        code <<-EOH
            # Set permission
            chmod +x /usr/local/bin/certbot-auto

            # Make symlink to accept acme test
            ln -sf #{node[:efs][:rootdir]}/letsencrypt/.well-known/ /mnt/nginx/#{app['shortname']}/current/web/

            # Request ssl certifiate
            /usr/local/bin/certbot-auto certonly --debug --agree-tos --email devops@serend.io --webroot --webroot-path /mnt/nginx/#{app['shortname']}/current/web/ -d #{app['domains'][0]} -n --cert-name #{app['shortname']}
            
            # Check for existing self signed certificate
            exitsting_certificate=#{node[:custom_ssl][:dir]}/#{app['shortname']}.crt
            new_certificate=#{node[:efs][:rootdir]}/letsencrypt/live/#{app['shortname']}/fullchain.pem 
            if [ -e "$exitsting_certificate" ] && [ -e "$new_certificate" ]; then
                # Remove self signed certificate
                rm -f #{node[:custom_ssl][:dir]}/#{app['shortname']}.crt
                rm -f #{node[:custom_ssl][:dir]}/#{app['shortname']}.key

                # Symlink valid certifiate to the #{node[:custom_ssl][:dir]} folder
                ln -sf #{node[:efs][:rootdir]}/letsencrypt/live/#{app['shortname']}/fullchain.pem #{node[:custom_ssl][:dir]}/#{app['shortname']}.crt
                ln -sf #{node[:efs][:rootdir]}/letsencrypt/live/#{app['shortname']}/privkey.pem #{node[:custom_ssl][:dir]}/#{app['shortname']}.key
                
            fi

            # Restart nginx after symlink
            sudo systemctl reload nginx
        EOH
        ignore_failure true
    end

    # Setup cron job for certificate renewal
    cron "certbot_renewal" do
        hour "8"
        minute "0"
        command "/usr/local/bin/certbot-auto renew"
        mailto "devops@serend.io"
    end

end



node[:deploy].each do |application, deploy|


end
