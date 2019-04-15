define :custom_ssl do

    deploy = params[:deploy_data]
    application = params[:application]
    application_name = params[:name]

    Chef::Log.info("********* Running custom-ssl - custom_ssl ***********")


    deploy deploy[:deploy_to] do

        # Callback after the server has restart
        after_restart do

            if node[:letsencrypt_efs_volume_id]

                # Prepare domains
                domains = Array.new()
                deploy[:domains].each do |domain|
                    domains.push('-d ' + domain)
                end
                # Drop last default app name from domain array
                custom_domains = domains.reverse.drop(1).reverse
                
                # Turn domain arrays to string with argument
                custom_domains = custom_domains.join(' ')
                
                # Output domains string
                Chef::Log.info(custom_domains)

                Chef::Log.info("********* Running custom-ssl::default ***********")

                # Install Cert Bot
                # Usage :  /usr/local/bin/certbot-auto certonly --debug --agree-tos --email devops@serend.io --webroot --webroot-path /mnt/nginx/app/current -d app.serend.io -n
                # --debug is required to run certbot on aws linux
                # Removing existing cerfitifate - TEMP
                script 'certbot_install' do
                    interpreter 'bash'
                    not_if do
                        deploy[:ssl_support]
                    end
                    code <<-EOH
                        # Get certbot
                        curl -O https://dl.eff.org/certbot-auto
                    
                        # Set permission and move it the bin folder
                        chmod +x certbot-auto
                        sudo mv certbot-auto /usr/local/bin/certbot-auto
                        
                        # Make symlink to accept acme test
                        ln -sf #{node[:efs][:rootdir]}/letsencrypt/.well-known/ /mnt/nginx/#{deploy[:application]}/current/

                        # Request ssl certifiate
                        /usr/local/bin/certbot-auto certonly --debug --agree-tos --email devops@serend.io --webroot --webroot-path /mnt/nginx/#{deploy[:application]}/current #{custom_domains} -n --cert-name #{deploy[:application]}
                        
                        # Check for existing self signed certificate
                        exitsting_certificate=#{node[:custom_ssl][:dir]}/#{deploy[:application]}.crt
                        new_certificate=#{node[:efs][:rootdir]}/letsencrypt/live/#{deploy[:application]}/fullchain.pem 
                        if [ -e "$exitsting_certificate" ] && [ -e "$new_certificate" ]; then
                            # Remove self signed certificate
                            rm -f #{node[:custom_ssl][:dir]}/#{deploy[:application]}.crt
                            rm -f #{node[:custom_ssl][:dir]}/#{deploy[:application]}.key

                            # Symlink valid certifiate to the #{node[:custom_ssl][:dir]} folder
                            ln -sf #{node[:efs][:rootdir]}/letsencrypt/live/#{deploy[:application]}/fullchain.pem #{node[:custom_ssl][:dir]}/#{deploy[:application]}.crt
                            ln -sf #{node[:efs][:rootdir]}/letsencrypt/live/#{deploy[:application]}/privkey.pem #{node[:custom_ssl][:dir]}/#{deploy[:application]}.key
                            
                        fi

                        # Restart nginx after symlink
                        service nginx restart
                    EOH
                    ignore_failure false
                    action :nothing
                end

                # Setup cron job for certificate renewal
                cron "certbot_renewal" do
                    hour "8"
                    minute "0"
                    command "/usr/local/bin/certbot-auto renew"
                    mailto "devops@serend.io"
                end

                Chef::Log.info("********* Running custom-ssl - custom_ssl (restart nginx again after certbot certificate creation) ***********")

                # Reload nginx service
                service 'nginx' do
                    supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
                    action [:start, :reload]
                    notifies :run, "script[certbot_install]"
                end
            end   

        end
        
    end
end
