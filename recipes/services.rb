# Litespeed service
service 'litespeed' do
  restart_command "#{node[:olyn_litespeed][:application][:dir]}/bin/lswsctrl restart"
  supports restart: true
  action :nothing
  only_if { File.exist?("#{node[:olyn_litespeed][:application][:dir]}/bin/lswsctrl") }
end
