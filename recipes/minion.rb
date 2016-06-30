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
  {
    "#{node['kubernetes']['secure']['directory']}/client.ca.crt" => node['kubernetes']['etcd']['client']['ca'],
    "#{node['kubernetes']['secure']['directory']}/client.srv.crt" => node['kubernetes']['etcd']['client']['cert'],
    "#{node['kubernetes']['secure']['directory']}/client.srv.bundle.crt" => "#{node['kubernetes']['etcd']['client']['cert']}\n#{node['kubernetes']['etcd']['client']['ca']}",
    "#{node['kubernetes']['secure']['directory']}/client.srv.key" => node['kubernetes']['etcd']['client']['key']
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
include_recipe 'kubernetes-cluster::kube-proxy'
include_recipe 'kubernetes-cluster::docker'
include_recipe 'kubernetes-cluster::flanneld'
include_recipe 'kubernetes-cluster::kubelet'
