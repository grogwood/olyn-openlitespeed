# Litespeed repo
default[:olyn_litespeed][:repo][:url]       = 'http://rpms.litespeedtech.com/debian/'
default[:olyn_litespeed][:repo][:keyserver] = 'keyserver.ubuntu.com'
default[:olyn_litespeed][:repo][:key]       = 'EDA1F085'

# Litespeed paths
default[:olyn_litespeed][:install_path] = '/usr/local/lsws/'
default[:olyn_litespeed][:www_path]     = '/srv/www/'

# Name of example VHOST to delete from install
default[:olyn_litespeed][:example_vhost] = 'Example'

# SSL cert data bag item name
default[:olyn_litespeed][:ssl_certificates_data_bag_item] = 'www'

# Webadmin ports data bag item name
default[:olyn_litespeed][:webadmin_ports_data_bag_item] = 'litespeed_webadmin'

# PHP packages data bag item
default[:olyn_litespeed][:php_packages_data_bag_item] = 'litespeed_php'

# Main WWW folder user settings
default[:olyn_litespeed][:users][:owner_data_bag_item] = 'system_admin'

# Litespeed webadmin user data bag item
default[:olyn_litespeed][:users][:webadmin_data_bag_item] = 'litespeed_webadmin'

# Litespeed service user data bag item
default[:olyn_litespeed][:users][:service_data_bag_item] = 'litespeed_service'

# Litespeed run as user data bag item
default[:olyn_litespeed][:users][:runner_data_bag_item] = 'litespeed_runner'