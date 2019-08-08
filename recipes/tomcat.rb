#
# Cookbook:: .
# Recipe:: tomcat8
#
# Copyright:: 2019, The Authors, All Rights Reserved.
apt_update 'update' do 
  action :update
end
package 'openjdk-8-jdk' do
  action :install
end
ENV['JAVA_HOME'] = '/usr/lib/jvm/java-8-openjdk-amd64'
bash 'name' do
  code <<-EOH
  export JAVA_HOME
  echo $JAVA_HOME
  EOH
  action :run
end


t
group 'tomcat' do
  action :create
end
user 'tomcat' do
  comment 'user created'
  group 'tomcat'
  home '/home/user'
  shell '/bin/false '
  password 'tomcat'
  action :create
end
remote_file '/tmp/apache-tomcat-8.5.43.tar.gz' do
  source 'http://apachemirror.wuchna.com/tomcat/tomcat-8/v8.5.43/bin/apache-tomcat-8.5.43.tar.gz'
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  action :create
end
directory '/opt/tomcat' do
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  action :create
end

execute 'extract_apache-tomcat-8.5.43.tar.gz' do
  command 'sudo tar xzvf /tmp/apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  cwd '/opt/tomcat/'
  not_if { File.exists?("/home/ubuntu/tat.txt") }
end
bash 'exeute those commands' do
  code <<-EOH
  sudo chgrp -R tomcat /opt/tomcat/
  sudo chmod -R g+r /opt/tomcat/conf
  sudo chmod g+x /opt/tomcat/conf   
  sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
  EOH
  action :run
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
  mode '0755'
  action :create
end
bash 'reload daemon' do
  code <<-EOH
  sudo systemctl daemon-reload
  sudo ufw allow 8080
  EOH
  action :run
end

service 'tomcat' do
  action :start
end
template '/opt/tomcat/conf/tomcat-users.xml' do
  source 'tomcat-users.xml.erb'
  mode '0755'
  action :create
end
template '/opt/tomcat/webapps/manager/META-INF/context.xml' do
  source 'manager-context.xml.erb'
  mode '0755'
  action :create
end
template '/opt/tomcat/webapps/host-manager/META-INF/context.xml' do
  source 'host-manager-context.xml.erb'
  mode '0755'
  action :create
end
bash 'copy root.war to webapps' do
  cwd '/opt/'
  code <<-EOH
  wget https://github.com/srinivas-reddy-mula/warfiles/raw/master/SampleWebApp.war
  cp SampleWebApp.jar /opt/tomcat/webapps/
  EOH
  action :run
end
bash 'deploy' do
  code <<-EOH
  sudo chmod 755 /opt/tomcat/webapps/SampleWebApp.war
    EOH
  action :run
end

service 'tomcat.serviceagain' do
  service_name 'tomcat'     
  action :restart
end