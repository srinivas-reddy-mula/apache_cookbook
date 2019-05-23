
apt_update 'update_packages' do
    action :update
end

apt_package 'apache2' do
  action :install
end

service "apache2" do
  action :restart
end





