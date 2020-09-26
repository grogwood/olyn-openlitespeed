# Include the services recipe
include_recipe 'olyn_litespeed::services'

# Grab the litespeed PHP packages data bag item
php_packages = data_bag_item('packages', node[:olyn_litespeed][:php][:package][:data_bag_item])

# Install all PHP packages in the data bag
php_packages[:packages].each do |package|
  package package do
    action :install
    notifies :restart, 'service[litespeed]', :delayed
  end
end

# Place the php.ini override file into the package version of PHP
template "#{node[:olyn_litespeed][:application][:dir]}/#{php_packages[:options][:base]}/etc/php/#{php_packages[:options][:version]}/mods-available/php-overrides.ini" do
  source 'php-overrides.ini.erb'
  mode 0644
  owner 'root'
  group 'root'
  notifies :restart, 'service[litespeed]', :delayed
end

# Create a bin symlink so PHP can be used on the command line
link '/usr/bin/php' do
  to "#{node[:olyn_litespeed][:application][:dir]}/#{php_packages[:options][:base]}/bin/lsphp"
  notifies :restart, 'service[litespeed]', :delayed
end

# Download the Composer PHAR
remote_file node[:olyn_litespeed][:php][:composer][:path] do
  source node[:olyn_litespeed][:php][:composer][:url]
  mode '0755'
  action :create_if_missing
end

# Create a bin symlink so Composer can be used on the command line
link '/usr/local/bin/composer' do
  to node[:olyn_litespeed][:php][:composer][:path]
end
