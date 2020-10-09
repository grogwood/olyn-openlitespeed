# Include the services recipe
include_recipe 'olyn_litespeed::services'

# Install the base openlitespeed package
package 'openlitespeed' do
  options '-q -y'
  action :install
end

# Grab the litespeed webadmin user data bag item
litespeed_webadmin = data_bag_item('litespeed_users', node[:olyn_litespeed][:webadmin][:user][:data_bag_item])

# Set the litespeed webadmin password
bash 'litespeed_webadmin_password' do
  code <<-ENDOFCODE
    ENCRYPT_PASS=`#{node[:olyn_litespeed][:application][:dir]}/admin/fcgi-bin/admin_php -q #{node[:olyn_litespeed][:application][:dir]}/admin/misc/htpasswd.php '#{litespeed_webadmin[:password]}'`
    echo "#{litespeed_webadmin[:username]}:$ENCRYPT_PASS" > #{node[:olyn_litespeed][:application][:dir]}/admin/conf/htpasswd
    touch #{Chef::Config[:olyn_application_data_path]}/lock/olyn_litespeed.litespeed_webadmin_password.lock
  ENDOFCODE
  user 'root'
  group 'root'
  sensitive true
  creates "#{Chef::Config[:olyn_application_data_path]}/lock/olyn_litespeed.litespeed_webadmin_password.lock"
  action :run
  notifies :restart, 'service[litespeed]', :delayed
end

# Remove the plain text file with the default admin/password that the installer creates
file "#{node[:olyn_litespeed][:application][:dir]}/adminpasswd" do
  action :delete
end

# Load the litespeed service admin data bag item
litespeed_service = data_bag_item('litespeed_users', node[:olyn_litespeed][:service][:user][:data_bag_item])

# Setup the litespeed admin VHOST and listener
template "#{node[:olyn_litespeed][:application][:dir]}/admin/conf/admin_config.conf" do
  source 'admin_config.conf.erb'
  mode 0750
  owner litespeed_service[:username]
  group litespeed_service[:groups]['primary']
  variables(
    ssl_certificates_item: data_bag_item('ssl_certificates', node[:olyn_litespeed][:ssl][:data_bag_item]),
    webadmin_ports_item:   data_bag_item('ports', node[:olyn_litespeed][:webadmin][:port][:data_bag_item])
  )
  notifies :restart, 'service[litespeed]', :delayed
end

# Write the main server config
template "#{node[:olyn_litespeed][:application][:dir]}/conf/httpd_config.conf" do
  source 'httpd_config.conf.erb'
  mode 0750
  owner litespeed_service[:username]
  group litespeed_service[:groups]['primary']
  variables(
    configs: {
      server_name:            node[:hostname],
      memory_io_buffer:       node[:olyn_litespeed][:server][:config][:memory_io_buffer],
      show_version_number:    node[:olyn_litespeed][:server][:config][:show_version_number],
      use_ip_in_proxy_header: node[:olyn_litespeed][:server][:config][:use_ip_in_proxy_header],
      index_files:            node[:olyn_litespeed][:server][:config][:index_files],
      auto_load_htaccess:     node[:olyn_litespeed][:server][:config][:auto_load_htaccess],
      expires: {
        enable: node[:olyn_litespeed][:server][:config][:expires][:enable],
        types: node[:olyn_litespeed][:server][:config][:expires][:types]
      }
    },
    php_packages_item: data_bag_item('packages', node[:olyn_litespeed][:php][:package][:data_bag_item]),
    vhosts_data_bag:   data_bag('litespeed_vhosts'),
    runner_item:       data_bag_item('litespeed_users', node[:olyn_litespeed][:runner][:user][:data_bag_item])
  )
  notifies :restart, 'service[litespeed]', :delayed
end

# Load the WWW owner user data bag item
www_admin_user = data_bag_item('system_users', node[:olyn_litespeed][:www][:user][:data_bag_item])

# Create the base WWW folder
directory node[:olyn_litespeed][:www][:dir] do
  mode 0755
  owner www_admin_user[:username]
  group www_admin_user[:groups]['primary']
  recursive true
  action :create
end

# Delete the example vhost
directory "#{node[:olyn_litespeed][:application][:dir]}/#{node[:olyn_litespeed][:vhost][:example][:name]}" do
  recursive true
  action :delete
  only_if { !node[:olyn_litespeed][:vhost][:example][:name].nil? }
  notifies :restart, 'service[litespeed]', :delayed
end

# Delete the example vhost configuration directory
directory "#{node[:olyn_litespeed][:application][:dir]}/conf/vhosts/#{node[:olyn_litespeed][:vhost][:example][:name]}" do
  recursive true
  action :delete
  only_if { !node[:olyn_litespeed][:vhost][:example][:name].nil? }
  notifies :restart, 'service[litespeed]', :delayed
end
