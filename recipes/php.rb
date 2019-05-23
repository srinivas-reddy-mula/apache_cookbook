# Cookbook::
# Recipe:: php
#
# Copyright:: 2019, The Authors, All Rights Reserved.

bash 'php installtion' do
  code <<-EOH
  sudo apt install php libapache2-mod-php php-mysql -y
  sudo apt install php-cli -y
  EOH
  action :run
end


cookbook_file '/var/www/html/info.php' do
  source 'info.php'
  owner 'root'
  action :create
end