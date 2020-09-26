# Include the services recipe
include_recipe 'olyn_litespeed::services'

# Load the litespeed service admin data bag item
litespeed_service = data_bag_item('litespeed_users', node[:olyn_litespeed][:service][:user][:data_bag_item])

# Loop through each VHOST in the data bag
data_bag('litespeed_vhosts').each do |vhost_item|

  # Grab the data bag item
  vhost = data_bag_item('litespeed_vhosts', vhost_item)

  # Grab the vhost's user data bag item
  vhost_user = data_bag_item('system_users', vhost[:user_data_bag_item])

  # Create the base vhost folder
  directory "#{node[:olyn_litespeed][:www][:dir]}/#{vhost[:name]}" do
    mode 0755
    owner vhost_user[:username]
    group vhost_user[:groups]['primary']
    recursive true
    action :create
  end

  # Create the vhost logs root
  directory "#{node[:olyn_litespeed][:www][:dir]}/#{vhost[:name]}/logs" do
    mode 0755
    owner vhost_user[:username]
    group vhost_user[:groups]['primary']
    recursive true
    action :create
  end

  # Create the vhost document root
  directory "#{node[:olyn_litespeed][:www][:dir]}/#{vhost[:name]}/#{vhost[:document_root]}" do
    mode 0755
    owner vhost_user[:username]
    group vhost_user[:groups]['primary']
    recursive true
    action :create
  end

  # Create the vhost folder
  directory "#{node[:olyn_litespeed][:application][:dir]}/conf/vhosts/#{vhost[:name]}" do
    mode 0750
    owner litespeed_service[:username]
    group litespeed_service[:groups]['primary']
    recursive true
    action :create
  end

  # Loop through realms
  vhost [:realms].each do |realm|

    # Grab the realm's user data bag item
    realm_user = data_bag_item('litespeed_users', realm[:user_data_bag_item])

    # Write the HTPASSWD file
    bash "generate_#{realm[:name]}_htpasswd" do
      code <<-ENDOFCODE
          printf "#{realm_user[:username]}:`openssl passwd -apr1 #{realm_user[:password]}`\n" > #{node[:olyn_litespeed][:application][:dir]}/conf/vhosts/#{vhost[:name]}/#{realm[:name]}
          touch #{Chef::Config[:olyn_application_data_path]}/lock/olyn_litespeed.generate_#{realm[:name]}_htpasswd.lock
      ENDOFCODE
      user 'root'
      group 'root'
      sensitive true
      creates "#{Chef::Config[:olyn_application_data_path]}/lock/olyn_litespeed.generate_#{realm[:name]}_htpasswd.lock"
      action :run
      notifies :restart, 'service[litespeed]', :delayed
    end

    # Set our file permissions on the generated htpasswd file
    file "#{node[:olyn_litespeed][:application][:dir]}/conf/vhosts/#{vhost[:name]}/#{realm[:name]}" do
      mode 0750
      owner litespeed_service[:username]
      group litespeed_service[:groups]['primary']
      notifies :restart, 'service[litespeed]', :delayed
    end

  end

  # Write the VHOST config
  template "#{node[:olyn_litespeed][:application][:dir]}/conf/vhosts/#{vhost[:name]}/#{vhost[:name]}.conf" do
    source 'vhost.conf.erb'
    mode 0750
    owner litespeed_service[:username]
    group litespeed_service[:groups]['primary']
    variables(
      vhost_item:        vhost,
      rewrites_data_bag: begin
                           data_bag('litespeed_rewrites')
                         rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
                           []
                         end
    )
    notifies :restart, 'service[litespeed]', :delayed
  end
end
