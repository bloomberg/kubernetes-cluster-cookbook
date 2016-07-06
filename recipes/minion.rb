#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

node.tag('kubernetes.minion')
node.override['kubelet']['register']['node'] = true
node.override['kubelet']['register']['schedulable'] = true

include_recipe 'kubernetes-cluster::default'
include_recipe 'kubernetes-cluster::proxy' if node['kubernetes']['haproxy']['enabled']

group 'kube-services' do
  members ['kube']
  action :modify
  only_if { node['kubernetes']['secure']['enabled'] }
end

if node['kubernetes']['secure']['enabled']
  data_bag = Chef::EncryptedDataBagItem.load(node['kubernetes']['secure']['data_bag_name'], node['kubernetes']['secure']['data_bag_item'])
  client_certs = data_bag[node['kubernetes']['secure']['client']['item_name']]
  client_ca = client_certs[node['kubernetes']['secure']['client']['ca']]
  client_cert = client_certs[node['kubernetes']['secure']['client']['cert']]
  client_key = client_certs[node['kubernetes']['secure']['client']['key']]

  {
    "#{node['kubernetes']['secure']['directory']}/client.ca.crt" => client_ca,
    "#{node['kubernetes']['secure']['directory']}/client.srv.crt" => node['kubernetes']['etcd']['client']['cert'],
    "#{node['kubernetes']['secure']['directory']}/client.srv.bundle.crt" => "#{client_cert}\n#{client_ca}",
    "#{node['kubernetes']['secure']['directory']}/client.srv.key" => client_key
  }.each do |filepath, contents|
    file filepath do
      content contents
      owner 'root'
      group 'kube-services'
      mode '0770'
      sensitive true
    end
  end
end

include_recipe 'kubernetes-cluster::kubernetes'
include_recipe 'kubernetes-cluster::kube-proxy' if node['kubernetes']['kube-proxy']['enabled']
include_recipe 'kubernetes-cluster::docker'
include_recipe 'kubernetes-cluster::flanneld'
include_recipe 'kubernetes-cluster::kubelet'
