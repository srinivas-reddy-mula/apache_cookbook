## tomcat installtion

group 'tomcat' do
  action :create
end
user 'tomcat' do
  comment 'user tomcat created'
  group 'tomcat'
  home '/home/user'
  shell '/bin/false'
  password 'tomcat'
  action :create
end

remote_file '/tmp/apache-tomcat-8.5.41.tar.gz' do
  source 'https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.41/bin/apache-tomcat-8.5.41.tar.gz'
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

execute 'extracting apache tomcat 8.5.41' do
  command 'tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  action :run
end
bash 'changing permissions' do
  code <<-EOH
  chgrp -R tomcat /opt/tomcat
  chmod -R g+r conf
  chmod g+x conf
  chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
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
  code <<-EOH
  sudo wget -P /opt/tomcat/webapps/ https://s3.amazonaws.com/shopizer2/ROOT.war 
  sudo chmod 755 /opt/tomcat/webapps/ROOT.war
  EOH
  action :run
end
service 'tomcat.serviceagain' do
  service_name 'tomcat'    
  action :restart
end

