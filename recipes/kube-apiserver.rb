#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

service 'kube-apiserver' do
  action :enable
end

node.default['kubernetes']['master']['fqdn'] = node['fqdn']

template '/etc/kubernetes/etcd.client.conf' do
  mode '0644'
  source 'kube-apiserver-etcd.erb'
  variables(
    etcd_cert_dir: node['kubernetes']['secure']['directory'],
    kubernetes_master: node['kubernetes']['master']['fqdn'],
    etcd_client_port: node['kubernetes']['etcd']['clientport']
  )
  only_if { node['kubernetes']['secure']['enabled'] == 'true' }
end

template '/etc/kubernetes/apiserver' do
  mode '0640'
  source 'kube-apiserver.erb'
  variables(
    etcd_client_port: node['kubernetes']['etcd']['clientport'],
    kubernetes_api_port: node['kubernetes']['insecure']['apiport'],
    kubernetes_secure_api_port: node['kubernetes']['secure']['apiport'],
    kubernetes_master: node['kubernetes']['master']['fqdn'],
    kubernetes_network: node['kubernetes']['master']['service-network'],
    kubelet_port: node['kubelet']['port'],
    etcd_cert_dir: node['kubernetes']['secure']['directory']
  )
  notifies :restart, 'service[kube-apiserver]', :immediately
end
