# Include the common recipe
include_recipe 'olyn_litespeed::common'

# Install the base openlitespeed package
package 'openlitespeed' do
  options '-q -y'
  action :install
end

# Grab the litespeed webadmin user data bag item
litespeed_webadmin = data_bag_item('litespeed_users', node[:olyn_litespeed][:users][:webadmin_data_bag_item])

# Set the litespeed webadmin password
bash 'litespeed_admin_password' do
  code <<-ENDOFCODE
    ENCRYPT_PASS=`#{node[:olyn_litespeed][:install_path]}admin/fcgi-bin/admin_php -q #{node[:olyn_litespeed][:install_path]}admin/misc/htpasswd.php '#{litespeed_webadmin[:password]}'`
    echo "#{litespeed_webadmin[:username]}:$ENCRYPT_PASS" > #{node[:olyn_litespeed][:install_path]}admin/conf/htpasswd
    touch #{Chef::Config[:file_cache_path]}/litespeed.webadmin.credentials.lock
  ENDOFCODE
  user 'root'
  group 'root'
  sensitive true
  creates "#{Chef::Config[:file_cache_path]}/litespeed.webadmin.credentials.lock"
  notifies :restart, 'service[litespeed]', :delayed
end

# Load the litespeed service admin data bag item
litespeed_service = data_bag_item('litespeed_users', node[:olyn_litespeed][:users][:service_data_bag_item])

# Setup the litespeed admin VHOST and listener
template "#{node[:olyn_litespeed][:install_path]}admin/conf/admin_config.conf" do
  source 'admin_config.conf.erb'
  mode 0644
  owner litespeed_service[:username]
  group litespeed_service[:groups]['primary']
  variables(
    ssl_certificates_item: data_bag_item('ssl_certificates', node[:olyn_litespeed][:ssl_certificates_data_bag_item]),
    webadmin_ports_item:   data_bag_item('ports', node[:olyn_litespeed][:webadmin_ports_data_bag_item])
  )
  notifies :restart, 'service[litespeed]', :delayed
end

# Write the main server config
template "#{node[:olyn_litespeed][:install_path]}conf/httpd_config.conf" do
  source 'httpd_config.conf.erb'
  mode 0644
  owner litespeed_service[:username]
  group litespeed_service[:groups]['primary']
  variables(
    server_name:            node[:hostname],
    memory_io_buffer:       node[:olyn_litespeed][:server_configs][:memory_io_buffer],
    show_version_number:    node[:olyn_litespeed][:server_configs][:show_version_number],
    use_ip_in_proxy_header: node[:olyn_litespeed][:server_configs][:use_ip_in_proxy_header],
    index_files:            node[:olyn_litespeed][:server_configs][:index_files],
    php_packages_item:      data_bag_item('packages', node[:olyn_litespeed][:php_packages_data_bag_item]),
    vhosts_data_bag:        data_bag('litespeed_vhosts'),
    runner_item:            data_bag_item('litespeed_users', node[:olyn_litespeed][:users][:runner_data_bag_item])
  )
  notifies :restart, 'service[litespeed]', :delayed
end

# Load the WWW owner user data bag item
www_admin_user = data_bag_item('system_users', node[:olyn_litespeed][:users][:owner_data_bag_item])

# Create the base WWW folder
directory node[:olyn_litespeed][:www_path] do
  mode 0755
  owner www_admin_user[:username]
  group www_admin_user[:groups]['primary']
  recursive true
  action :create
end

# Delete the example vhost
directory "#{node[:olyn_litespeed][:install_path]}#{node[:olyn_litespeed][:example_vhost]}" do
  recursive true
  action :delete
  only_if { !node[:olyn_litespeed][:example_vhost].nil? }
  notifies :restart, 'service[litespeed]', :delayed
end

# Delete the example vhost configuration directory
directory "#{node[:olyn_litespeed][:install_path]}conf/vhosts/#{node[:olyn_litespeed][:example_vhost]}" do
  recursive true
  action :delete
  only_if { !node[:olyn_litespeed][:example_vhost].nil? }
  notifies :restart, 'service[litespeed]', :delayed
end
