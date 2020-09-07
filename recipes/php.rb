# Include the services recipe
include_recipe 'olyn_litespeed::services'

# Grab the litespeed PHP packages data bag item
php_packages = data_bag_item('packages', node[:olyn_litespeed][:php_packages_data_bag_item])

# Install all PHP packages in the data bag
php_packages[:packages].each do |package|
  package package do
    action :install
    notifies :restart, 'service[litespeed]', :delayed
  end
end

# Create the processor path symlink to the package version of PHP
link "#{node[:olyn_litespeed][:install_path]}fcgi-bin/#{php_packages[:options][:base]}" do
  to "#{node[:olyn_litespeed][:install_path]}#{php_packages[:options][:base]}/bin/lsphp"
  notifies :restart, 'service[litespeed]', :delayed
end

# Place the php.ini override file into the package version of PHP
template "#{node[:olyn_litespeed][:install_path]}#{php_packages[:options][:base]}/etc/php/#{php_packages[:options][:version]}/mods-available/php-overrides.ini" do
  source 'php-overrides.ini.erb'
  mode 0644
  owner 'root'
  group 'root'
  notifies :restart, 'service[litespeed]', :delayed
end
