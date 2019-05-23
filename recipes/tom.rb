package 'tomcat8' do
    action :install
end

service 'tomcat8' do
    action :start
end

bash 'copy root.war to webapps' do
    code <<-EOH
    sudo wget -P /opt/tomcat/webapps/ https://s3.amazonaws.com/shopizer2/ROOT.war 
    sudo chmod 755 /opt/tomcat/webapps/ROOT.war
    EOH
    action :run
  end