#
# Cookbook Name:: deploy
# Recipe:: custom-php
#

include_recipe 'deploy'

Chef::Log.info("********* Running custom-ssl::deploy ***********")


node[:deploy].each do |application, deploy|

    # SSL Config
    directory "#{node[:custom_ssl][:dir]}" do
        action :create
        owner "root"
        group "root"
        mode '0600'
    end

    # Load Certificate (if specified by App)
    template "#{node[:custom_ssl][:dir]}/#{deploy[:application]}.crt" do
        mode '0600'
        source "ssl.erb"
        variables :data => deploy[:ssl_certificate]
        only_if do
            deploy[:ssl_support]
        end
    end

    # Load Certificate Key (if specified by App)
    template "#{node[:custom_ssl][:dir]}/#{deploy[:application]}.key" do
        mode '0600'
        source "ssl.erb"
        variables :data => deploy[:ssl_certificate_key]
        only_if do
            deploy[:ssl_support]
        end
    end

    # Load Certificate Authority (if specified by App)
    template "#{node[:custom_ssl][:dir]}/#{deploy[:application]}.ca" do
        mode '0600'
        source "ssl.erb"
        variables :data => deploy[:ssl_certificate_ca]
        only_if do
            deploy[:ssl_support] && deploy[:ssl_certificate_ca]
        end
    end

    # Create a Self-Signed Certificate (if one was NOT specified by App)
    script 'create self-signed certificate' do
        interpreter 'bash'
        not_if do
            deploy[:ssl_support]
        end
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
            rm -f #{deploy[:application]}.key
            rm -f #{deploy[:application]}.key.org
            rm -f #{deploy[:application]}.csr
            rm -f #{deploy[:application]}.crt

            # Generate a passphrase
            export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 128; echo)

            # Certificate details; replace items in angle brackets with your own info
            subj="/C=CA/ST=British Columbia/L=Vancouver/O=serend#{deploy[:domains].map{ |k| "/CN=#{k}" }.join}"

            # Generate the server private key
            openssl genrsa -des3 -out #{deploy[:application]}.key -passout env:PASSPHRASE 2048
            fail_if_error $?

            # Generate the CSR
            openssl req \
                -new \
                -batch \
                -subj "$(echo -n "$subj" | tr "\n" "/")" \
                -key #{deploy[:application]}.key \
                -out #{deploy[:application]}.csr \
                -passin env:PASSPHRASE
            fail_if_error $?
            cp #{deploy[:application]}.key #{deploy[:application]}.key.org
            fail_if_error $?

            # Strip the password so we don't have to type it every time we restart Apache
            openssl rsa -in #{deploy[:application]}.key.org -out #{deploy[:application]}.key -passin env:PASSPHRASE
            fail_if_error $?

            # Generate the certificate (good for 10 years)
            openssl x509 -req -days 3650 -in #{deploy[:application]}.csr -signkey #{deploy[:application]}.key -out #{deploy[:application]}.crt
            fail_if_error $?

            # Set Permissions
            chmod 600 #{deploy[:application]}.key
            chmod 600 #{deploy[:application]}.crt

            # Move Certificate in place
            mv -f #{deploy[:application]}.key #{node[:custom_ssl][:dir]}
            mv -f #{deploy[:application]}.crt #{node[:custom_ssl][:dir]}

            # Clean up
            rm -f #{deploy[:application]}.key.org
            rm -f #{deploy[:application]}.csr
        EOH
    end

end
