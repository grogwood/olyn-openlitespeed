# Litespeed service
service 'litespeed' do
  restart_command "#{node[:olyn_litespeed][:install_path]}bin/lswsctrl restart"
  supports restart: true
  action :nothing
  only_if { File.exist?("#{node[:olyn_litespeed][:install_path]}bin/lswsctrl") }
end
