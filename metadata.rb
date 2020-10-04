name 'olyn_litespeed'
maintainer 'Scott Richardson'
maintainer_email 'dev@grogwood.com'
chef_version '~> 16'
license 'GPL-3.0'
supports 'debian', '>= 10'
source_url 'https://gitlab.com/olyn/olyn_litespeed'
description 'Installs and configures Openlitespeed locally on the server'
version '1.2.4'

provides 'olyn_litespeed::default'
provides 'olyn_litespeed::install'
provides 'olyn_litespeed::php'
provides 'olyn_litespeed::repo'
provides 'olyn_litespeed::services'
provides 'olyn_litespeed::vhosts'
recipe 'olyn_litespeed::default', 'Installs and configures Openlitespeed locally on the server'
recipe 'olyn_litespeed::install', 'Installs and configures the Openlitespeed server'
recipe 'olyn_litespeed::php', 'Installs and configures the PHP for openlitespeed'
recipe 'olyn_litespeed::repo', 'Installs litespeed repos'
recipe 'olyn_litespeed::services', 'Shared service definitions'
recipe 'olyn_litespeed::vhosts', 'Configures vhosts in openlitespeed'
