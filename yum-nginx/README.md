yum-nginx Cookbook
====================
[![Build Status](https://travis-ci.org/st-isidore-de-seville/cookbook-yum-nginx.svg?branch=master)](https://travis-ci.org/st-isidore-de-seville/cookbook-yum-nginx)
[![Chef Cookbook](https://img.shields.io/cookbook/v/yum-nginx.svg)](https://supermarket.chef.io/cookbooks/yum-nginx)

Installs/Configures yum NGINX Vendor-Specific Repositories.

This cookbook installs & configures yum NGINX repositories per
http://nginx.org/en/linux_packages.html.

Requirements
------------
- Chef 11 or higher
- Ruby 1.9 or higher (preferably from the Chef full-stack installer)
- Network accessible package repositories
- [yum Cookbook](https://supermarket.chef.io/cookbooks/yum)

Attributes
----------
#### yum-nginx::default
The default recipe is for installing & configuring the yum NGINX repostories.
Any attribute supported by the [yum cookbook](https://github.com/chef-cookbooks/yum#parameters)
is supported by this cookbook and can be used to override attributes in this
cookbook.

Per http://wiki.nginx.org/Install, there are currently two versions of NGINX.
The mainline branch gets new features and bugfixes sooner but might introduce
new bugs as well.  Critical bugfixes are backported to the stable branch.  In
general, the stable release is recommended, but the mainline release is
typically quite stable as well.

- `['yum-nginx']['rhel']['supported-versions']`
  - _Type:_ Hash

  - _Description:_

    RHEL platform support for this cookbook and the NGINX repository.  Designed
    to be a private attribute however it can be overridden in the case NGINX
    supports additional versions and this cookbook has not been updated yet.

    This check was implemented as a result of the repo could be successfully
    installed yet not be valid for a given platform and an NGINX package could
    be successfully installed as a result of it being available natively on the
    platform it which it was run which results in a false positive for the
    consumer of the cookbook.

    The hash key is the major version of the OS.  If the hash value evaluates to
    true, the OS/version is considered supported.

  - _Default:_

    ```ruby
    {
      '5' => true,
      '6' => true,
      '7' => true
    }
    ```
- NGINX Stable Repo
  - `['yum-nginx']['repos']['nginx-stable']['managed']`
    - _Type:_ Boolean
    - _Description:_ Does this cookbook manage the install of the NGINX Stable
      Repo?
    - _Default:_ `true`
  - `['yum-nginx']['repos']['nginx-stable']['repositoryid']`
    - _Type:_ String
    - _Description:_ Unique Name for NGINX Stable Repo
    - _Default:_ `nginx-stable`
  - `['yum-nginx']['repos']['nginx-stable']['description']`
    - _Type:_ String
    - _Description:_ Description of NGINX Stable Repo
    - _Default:_ `nginx stable repo`
  - `['yum-nginx']['repos']['nginx-stable']['baseurl']`
    - _Type:_ String
    - _Description:_ URL of NGINX Stable Repo
    - _Default:_ `http://nginx.org/packages/#{node['platform']}/#{node['platform_version'].to_i}/$basearch/`
  - `['yum-nginx']['repos']['nginx-stable']['gpgcheck']`
    - _Type:_ Boolean
    - _Description:_ Whether or not NGINX Stable Repo should perform GPG check
      of packages?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-stable']['sslverify']`
    - _Type:_ Boolean
    - _Description:_ Whether or not yum will verify the NGINX Stable Repo SSL
      host?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-stable']['enabled']`
    - _Type:_ Boolean
    - _Description:_ Whether or not the NGINX Stable Repo is enabled?
    - _Default:_ `true`
- NGINX Stable Source Repo
  - `['yum-nginx']['repos']['nginx-stable-source']['managed']`
    - _Type:_ Boolean
    - _Description:_ Does this cookbook manage the install of the NGINX Stable
      Source Repo?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-stable-source']['repositoryid']`
    - _Type:_ String
    - _Description:_ Unique Name for NGINX Stable Source Repo
    - _Default:_ `nginx-stable-source`
  - `['yum-nginx']['repos']['nginx-stable-source']['description']`
    - _Type:_ String
    - _Description:_ Description of NGINX Stable Source Repo
    - _Default:_ `nginx stable source repo`
  - `['yum-nginx']['repos']['nginx-stable-source']['baseurl']`
    - _Type:_ String
    - _Description:_ URL of NGINX Stable Source Repo
    - _Default:_ `http://nginx.org/packages/#{node['platform']}/#{node['platform_version'].to_i}/SRPMS/`
  - `['yum-nginx']['repos']['nginx-stable-source']['gpgcheck']`
    - _Type:_ Boolean
    - _Description:_ Whether or not NGINX Stable Source Repo should perform GPG
      check of packages?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-stable-source']['sslverify']`
    - _Type:_ Boolean
    - _Description:_ Whether or not yum will verify the NGINX Stable Source Repo
      SSL host?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-stable-source']['enabled']`
    - _Type:_ Boolean
    - _Description:_ Whether or not the NGINX Stable Source Repo is enabled?
    - _Default:_ `true`
- NGINX Mainline Repo
  - `['yum-nginx']['repos']['nginx-mainline']['managed']`
    - _Type:_ Boolean
    - _Description:_ Does this cookbook manage the install of the NGINX Mainline
      Repo?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-mainline']['repositoryid']`
    - _Type:_ String
    - _Description:_ Unique Name for NGINX Mainline Repo
    - _Default:_ `nginx-mainline`
  - `['yum-nginx']['repos']['nginx-mainline']['description']`
    - _Type:_ String
    - _Description:_ Description for NGINX Mainline Repo
    - _Default:_ `nginx mainline repo`
  - `['yum-nginx']['repos']['nginx-mainline']['baseurl']`
    - _Type:_ String
    - _Description:_ URL of NGINX Mainline Repo
    - _Default:_ `http://nginx.org/packages/mainline/#{node['platform']}/#{node['platform_version'].to_i}/$basearch/`
  - `['yum-nginx']['repos']['nginx-mainline']['gpgcheck']`
    - _Type:_ Boolean
    - _Description:_ Whether or not NGINX Mainline Repo should perform GPG check
      of packages?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-mainline']['sslverify']`
    - _Type:_ Boolean
    - _Description:_ Whether or not yum will verify the NGINX Mainline Repo SSL
      host?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-mainline']['enabled']`
    - _Type:_ Boolean
    - _Description:_ Whether or not the NGINX Mainline Repo is enabled?
    - _Default:_ `true`
- NGINX Mainline Source Repo
  - `['yum-nginx']['repos']['nginx-mainline-source']['managed']`
    - _Type:_ Boolean
    - _Description:_ Does this cookbook manage the install of the NGINX Mainline
      Source Repo?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-mainline-source']['repositoryid']`
    - _Type:_ String
    - _Description:_ Unique Name for NGINX Mainline Source Repo
    - _Default:_ `nginx-mainline-source`
  - `['yum-nginx']['repos']['nginx-mainline-source']['description']`
    - _Type:_ String
    - _Description:_ Description of NGINX Mainline Source Repo
    - _Default:_ `nginx mainline source repo`
  - `['yum-nginx']['repos']['nginx-mainline-source']['baseurl']`
    - _Type:_ String
    - _Description:_ URL of NGINX Mainline Source Repo
    - _Default:_ `http://nginx.org/packages/mainline/#{node['platform']}/#{node['platform_version'].to_i}/SRPMS/`
  - `['yum-nginx']['repos']['nginx-mainline-source']['gpgcheck']`
    - _Type:_ Boolean
    - _Description:_ Whether or not NGINX Mainline Source Repo should perform
      GPG check of packages?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-mainline-source']['sslverify']`
    - _Type:_ Boolean
    - _Description:_ Whether or not yum will verify the NGINX Mainline Source
      Repo SSL host?
    - _Default:_ `false`
  - `['yum-nginx']['repos']['nginx-mainline-source']['enabled']`
    - _Type:_ Boolean
    - _Description:_ Whether or not the NGINX Mainline Source Repo is enabled?
    - _Default:_ `true`

Usage
-----
#### yum-nginx::default
Just include `yum-nginx` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[yum-nginx]"
  ]
}
```

Contributing
------------
1. Fork the repository on GitHub
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using GitHub

Development Environment
-------------------
This repository contains a Vagrantfile which can be used to spin up a
fully configured development environment in Vagrant.  

Vagrant requires the following:
- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

The Vagrant environment for this repository is based on:
- [st-isidore-de-seville/trusty64-rvm-docker](https://atlas.hashicorp.com/st-isidore-de-seville/boxes/trusty64-rvm-docker)

The Vagrant environment will initialize itself to:
- install required Ruby gems
- run integration testing via kitchen-docker when calling `kitchen`

The Vagrant environment can be spun up by performing the following commands:

1. `vagrant up`
2. `vagrant ssh`
3. `cd /vagrant`

Authors
-------------------
- Author:: St. Isidore de Seville (st.isidore.de.seville@gmail.com)

License
-------------------
```text
The MIT License (MIT)

Copyright (c) 2015 St. Isidore de Seville (st.isidore.de.seville@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
