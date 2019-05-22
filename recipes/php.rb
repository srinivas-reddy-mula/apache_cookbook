# Cookbook::
# Recipe:: php
#
# Copyright:: 2019, The Authors, All Rights Reserved.

package 'php' do
  action :install
end
cookbook_file '/var/www/html/info.php' do
  source 'info.php'
  action :create
end