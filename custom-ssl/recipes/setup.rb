#
# Cookbook Name:: custom-ssl
# Recipe:: setup
#
# Copyright 2019, Serend Software Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


Chef::Log.info("********* Running custom-ssl::setup ***********")

# Mount LetsEncypt EFS Volume (if defined)
if node[:letsencrypt_efs_volume_id]

    Chef::Log.info("Mounting LetsEncrypt EFS volume #{node[:letsencrypt_efs_volume_id]} to #{node[:efs][:rootdir]}/letsencrypt")

    # Create the EFS letsencrypt folder
    # e.g. creates /efs/letsencrypt
    directory "#{node[:efs][:rootdir]}/letsencrypt" do
        owner 'nginx'
        group 'nginx'
        mode  '0755'
        recursive true
        action :create
    end

    # Mount the EFS volume for LetsEncrypt (if it's not already mounted)
    # e.g. mounts the EFS drive to /efs/letsencrypt
    bash "efs_mount_letsencrypt" do
        user "root"
        code <<-EOH
            if ! mount|grep #{node[:efs][:rootdir]}/letsencrypt; then
                rm -rf #{node[:efs][:rootdir]}/letsencrypt/*
                mount -t nfs4 -o nfsvers=4.1 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).#{node[:letsencrypt_efs_volume_id]}.efs.us-west-2.amazonaws.com:/ #{node[:efs][:rootdir]}/letsencrypt
            fi            

            # Symlink to /etc/letsencrypt
            ln -sf #{node[:efs][:rootdir]}/letsencrypt/ /etc/
        EOH
    end



    Chef::Log.info("Creating LetsEncrypt .well-known folder in #{node[:efs][:rootdir]}/letsencrypt/.well-known")

    # Create the LetsEncrypt .well-known folder
    # e.g. creates /efs/letsencrypt/.well-known
    directory "#{node[:efs][:rootdir]}/letsencrypt/.well-known" do
        owner 'nginx'
        group 'nginx'
        mode  '0755'
        recursive true
        action :create
    end
end
