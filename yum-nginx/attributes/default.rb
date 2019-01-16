#
# Cookbook Name:: yum-nginx
# Attributes:: default
#

# RHEL platform support for this cookbook and the NGINX repository.  Designed
# to be a private attribute however it can be overridden in the case NGINX
# supports additional versions and this cookbook has not been updated yet.
#
# This check was implemented as a result of the repo could be successfully
# installed yet not be valid for a given platform and an NGINX package could
# be successfully installed as a result of it being available natively on the
# platform it which it was run which results in a false positive for the
# consumer of the cookbook.
#
# The hash key is the major version of the OS.  If the hash value evaluates to
# true, the OS/version is considered supported.

default['yum-nginx']['rhel']['supported-versions'] = {
  '5' => true,
  '6' => true,
  '7' => true
}

baseurl_prefix = 'http://nginx.org/packages'
baseurl_suffix = "#{node['platform']}/#{node['platform_version'].to_i}"

default['yum-nginx']['repos'].tap do |repo|
  repo['nginx-stable'].tap do |value|
    # Does this cookbook manage the install of the NGINX Stable Repo?
    value['managed'] = true
    # Unique Name for NGINX Stable Repo
    value['repositoryid'] = 'nginx-stable'
    # Description of NGINX Stable Repo
    value['description'] = 'nginx stable repo'
    # URL of NGINX Stable Repo
    value['baseurl'] = "#{baseurl_prefix}/#{baseurl_suffix}/$basearch/"
    # Whether or not NGINX Stable Repo should perform GPG check of packages?
    value['gpgcheck'] = false
    # Whether or not yum will verify the NGINX Stable Repo SSL host?
    value['sslverify'] = false
    # Whether or not the NGINX Stable Repo is enabled?
    value['enabled'] = true
  end

  repo['nginx-stable-source'].tap do |value|
    # Does this cookbook manage the install of the NGINX Stable Source Repo?
    value['managed'] = false
    # Unique Name for NGINX Stable Source Repo
    value['repositoryid'] = 'nginx-stable-source'
    # Description of NGINX Stable Source Repo
    value['description'] = 'nginx stable source repo'
    # URL of NGINX Stable Source Repo
    value['baseurl'] = "#{baseurl_prefix}/#{baseurl_suffix}/SRPMS/"
    # Whether or not NGINX Stable Source Repo should perform GPG check of
    #  packages?
    value['gpgcheck'] = false
    # Whether or not yum will verify the NGINX Stable Source Repo SSL host?
    value['sslverify'] = false
    # Whether or not the NGINX Stable Source Repo is enabled?
    value['enabled'] = true
  end

  repo['nginx-mainline'].tap do |value|
    # Does this cookbook manage the install of the NGINX Mainline Repo?
    value['managed'] = false
    # Unique Name for NGINX Mainline Repo
    value['repositoryid'] = 'nginx-mainline'
    # Description for NGINX Mainline Repo
    value['description'] = 'nginx mainline repo'
    # URL of NGINX Mainline Repo
    value['baseurl'] = "#{baseurl_prefix}/mainline/#{baseurl_suffix}/$basearch/"
    # Whether or not NGINX Mainline Repo should perform GPG check of packages?
    value['gpgcheck'] = false
    # Whether or not yum will verify the NGINX Mainline Repo SSL host?
    value['sslverify'] = false
    # Whether or not the NGINX Mainline Repo is enabled?
    value['enabled'] = true
  end

  repo['nginx-mainline-source'].tap do |value|
    # Does this cookbook manage the install of the NGINX Mainline Source Repo?
    value['managed'] = false
    # Unique Name for NGINX Mainline Source Repo
    value['repositoryid'] = 'nginx-mainline-source'
    # Description of NGINX Mainline Source Repo
    value['description'] = 'nginx mainline source repo'
    # URL of NGINX Mainline Source Repo
    value['baseurl'] = "#{baseurl_prefix}/mainline/#{baseurl_suffix}/SRPMS/"
    # Whether or not NGINX Mainline Source Repo should perform GPG check of
    #  packages?
    value['gpgcheck'] = false
    # Whether or not yum will verify the NGINX Mainline Source Repo SSL host?
    value['sslverify'] = false
    # Whether or not the NGINX Mainline Source Repo is enabled?
    value['enabled'] = true
  end
end
