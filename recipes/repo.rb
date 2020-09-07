# Add the litespeed repo
apt_repository 'litespeed' do
  uri node[:olyn_litespeed][:repo][:url]
  keyserver node[:olyn_litespeed][:repo][:keyserver]
  key node[:olyn_litespeed][:repo][:key]
  components ['main']
end
