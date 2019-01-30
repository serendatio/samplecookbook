# frozen_string_literal: true

name 'opsworks_php'
maintainer 'Igor Rzegocki'
maintainer_email 'igor@rzegocki.pl'
license 'MIT'
description 'Set of chef recipes for OpsWorks based Ruby projects'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.10.1'
chef_version '~> 14.9.13' if respond_to?(:chef_version)

#depends 'apt', '< 7.0'
depends 'nginx'
depends 'logrotate'
#depends 'ruby-ng'
depends 's3_file'
#depends 'sudo'

#depends 'php'
#depends 'composer'

supports 'amazon', '>= 2017.03'
supports 'ubuntu', '>= 16.04'

source_url 'https://github.com/ajgon/opsworks_php'
issues_url 'https://github.com/ajgon/opsworks_php/issues'
