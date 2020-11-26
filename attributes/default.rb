# Litespeed repo
default[:olyn_litespeed][:repo][:url] = 'http://rpms.litespeedtech.com/debian/'
default[:olyn_litespeed][:repo][:keyserver] = 'keyserver.ubuntu.com'
default[:olyn_litespeed][:repo][:key] = 'EDA1F085'

# Litespeed application directory
default[:olyn_litespeed][:application][:dir] = '/usr/local/lsws'

# Litespeed service user data bag item
default[:olyn_litespeed][:service][:user][:data_bag_item] = 'litespeed_service'

# Litespeed run as user data bag item
default[:olyn_litespeed][:runner][:user][:data_bag_item] = 'litespeed_runner'

# Name of example VHOST to delete after fresh install
default[:olyn_litespeed][:vhost][:example][:name] = 'Example'

# WWW root
default[:olyn_litespeed][:www][:dir] = '/srv/www'

# Main WWW folder user
default[:olyn_litespeed][:www][:user][:data_bag_item] = 'system_admin'

# SSL cert data bag item name
default[:olyn_litespeed][:ssl][:data_bag_item] = 'www'

# Webadmin ports data bag item name
default[:olyn_litespeed][:webadmin][:port][:data_bag_item] = 'litespeed_webadmin'

# Litespeed webadmin user data bag item
default[:olyn_litespeed][:webadmin][:user][:data_bag_item] = 'litespeed_webadmin'

# Server configurations in httpd_config
default[:olyn_litespeed][:server][:config][:memory_io_buffer] = '120M'
default[:olyn_litespeed][:server][:config][:show_version_number] = 2
default[:olyn_litespeed][:server][:config][:use_ip_in_proxy_header] = 1
default[:olyn_litespeed][:server][:config][:index_files] = ['index.php', 'index.html', 'index.htm']
default[:olyn_litespeed][:server][:config][:auto_load_htaccess] = false

# Server default expirations
default[:olyn_litespeed][:server][:config][:expires][:enable] = true
default[:olyn_litespeed][:server][:config][:expires][:types]  = [
  'image/*=A604800',
  'text/css=A604800',
  'application/x-javascript=A604800',
  'application/javascript=A604800',
  'font/*=A604800',
  'application/x-font-ttf=A604800',
  'application/font-woff=A604800',
  'application/font-woff2=A604800'
]

# PHP packages data bag item
default[:olyn_litespeed][:php][:package][:data_bag_item] = 'litespeed_php'

# PHP Composer configurations
default[:olyn_litespeed][:php][:composer][:url] = 'https://getcomposer.org/composer-stable.phar'
default[:olyn_litespeed][:php][:composer][:path] = '/usr/local/lsws/php/composer.phar'
