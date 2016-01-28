#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

node.tag('kubernetes.proxy')

case node['platform']
when 'redhat', 'centos', 'fedora'
  yum_package "haproxy #{node['kubernetes_cluster']['package']['haproxy']['version']}"
end

service 'haproxy' do
  action :enable
end

template '/etc/haproxy/haproxy.cfg' do
  mode '0644'
  source 'proxy.erb'
  variables(
    kubernetes_api_port: node['kubernetes']['insecure']['apiport'],
    api_servers: node['kubernetes']['master']['fqdn'],
    etcd_client_port: node['kubernetes']['etcd']['clientport'],
    kubernetes_secure_api_port: node['kubernetes']['secure']['apiport']
  )
  notifies :restart, 'service[haproxy]', :immediately
end
