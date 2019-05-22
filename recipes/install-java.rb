apt_update 'update' do
    ignore_failure true
    action :update
    only_if { node['platform'] == 'ubuntu'} 
end

apt_repository 'openjdk-r' do
    uri 'ppa:openjdk-r/ppa'
    action :add
end

apt_package node['maven']['package_java'] do
    action :install
end


cookbook_file '/etc/environment' do
    source 'environment'
    action :create
end

bash 'reloading' do
    cwd '/etc/'
    code <<-EOH
      source environment
      EOH
    action :run
end