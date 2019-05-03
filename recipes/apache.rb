if node['platform_family'] == 'rhel'
  file '/home/ec2-user/second.txt' do
    content 'redhat hello'
    action :create
  end
end
if node['platform_family'] == 'debian'
  file '/home/ubuntu/second.txt' do
    content 'ubuntu hello'
    action :create
  end
end
package_name = ''
if node['platform_family'] == 'rhel'
  package_name = 'httpd'
elsif node['platform_family'] == 'debian'
  package_name = 'apache2'
end
if node['platform_family'] == 'debian'
  apt_update 'update_packages' do
    action :update
  end
end

package package_name do
  action :install
end
service package_name do
  action :restart
end
