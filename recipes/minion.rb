#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

node.tag('kubernetes.minion')
node.override['kubelet']['register'] = 'true'

include_recipe 'kubernetes-cluster::default'
include_recipe 'kubernetes-cluster::proxy'

if node['kubernetes']['secure']['enabled'] == 'true'
  group 'kube-services' do
    members ['kube']
    action :modify
  end
  file "#{node['kubernetes']['secure']['directory']}/client.ca.crt" do
    content node['kubernetes']['etcd']['client']['ca']
    owner 'root'
    group 'kube-services'
    mode '0770'
  end
  file "#{node['kubernetes']['secure']['directory']}/client.srv.crt" do
    content node['kubernetes']['etcd']['client']['cert']
    owner 'root'
    group 'kube-services'
    mode '0770'
  end
  file "#{node['kubernetes']['secure']['directory']}/client.srv.bundle.crt" do
    content "#{node['kubernetes']['etcd']['client']['cert']}\n#{node['kubernetes']['etcd']['client']['ca']}"
    owner 'root'
    group 'kube-services'
    mode '0770'
  end
  file "#{node['kubernetes']['secure']['directory']}/client.srv.key" do
    content node['kubernetes']['etcd']['client']['key']
    owner 'root'
    group 'kube-services'
    mode '0770'
  end
end

include_recipe 'kubernetes-cluster::kubernetes'
include_recipe 'kubernetes-cluster::kube-proxy'
include_recipe 'kubernetes-cluster::docker'
include_recipe 'kubernetes-cluster::flanneld'
include_recipe 'kubernetes-cluster::kubelet'
