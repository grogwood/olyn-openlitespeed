# Add the litespeed repo
apt_repository 'litespeed' do
  uri node[:olyn_litespeed][:repo][:url]
  keyserver node[:olyn_litespeed][:repo][:keyserver]
  key node[:olyn_litespeed][:repo][:key]
  components ['main']
end

# Litespeed service
service 'litespeed' do
  restart_command "#{node[:olyn_litespeed][:install_path]}bin/lswsctrl restart"
  supports restart: true
  action :nothing
  only_if { File.exist?("#{node[:olyn_litespeed][:install_path]}bin/lswsctrl") }
end