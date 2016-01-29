#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

node.tag('kubernetes.master')

include_recipe 'kubernetes-cluster::default'

case node['platform']
when 'redhat', 'centos', 'fedora'
  yum_package "cockpit #{node['kubernetes_cluster']['package']['cockpit']['version']}" do
    only_if { node['kubernetes_cluster']['package']['cockpit']['enabled'] }
  end
  yum_package "etcd #{node['kubernetes_cluster']['package']['etcd']['version']}"
  yum_package "kubernetes-master #{node['kubernetes_cluster']['package']['kubernetes_master']['version']}"
  yum_package "#{node['kubernetes_cluster']['package']['docker']['name']} #{node['kubernetes_cluster']['package']['docker']['version']}"
end

group 'kube-services' do
  only_if { node['kubernetes']['secure']['enabled'] == 'true' }
  members %w(etcd kube)
  action :modify
end

if node['kubernetes']['secure']['enabled'] == 'true'
  file "#{node['kubernetes']['secure']['directory']}/client.ca.crt" do
    content node['kubernetes']['etcd']['client']['ca']
    owner 'root'
    group 'kube-services'
    mode '0770'
  end
  file "#{node['kubernetes']['secure']['directory']}/client.srv.crt" do
    content node['kubernetes']['etcd']['peer']['cert']
    owner 'root'
    group 'kube-services'
    mode '0770'
  end
  file "#{node['kubernetes']['secure']['directory']}/client.srv.key" do
    content node['kubernetes']['etcd']['peer']['key']
    owner 'root'
    group 'kube-services'
    mode '0770'
  end
  file "#{node['kubernetes']['secure']['directory']}/peer.ca.crt" do
    content node['kubernetes']['etcd']['peer']['ca']
    owner 'root'
    group 'kube-services'
    mode '0770'
  end
  file "#{node['kubernetes']['secure']['directory']}/peer.srv.crt" do
    content node['kubernetes']['etcd']['peer']['cert']
    owner 'root'
    group 'kube-services'
    mode '0770'
  end
  file "#{node['kubernetes']['secure']['directory']}/peer.srv.key" do
    content node['kubernetes']['etcd']['peer']['key']
    owner 'root'
    group 'kube-services'
    mode '0770'
  end
end

include_recipe 'kubernetes-cluster::etcd'
include_recipe 'kubernetes-cluster::kubernetes'
include_recipe 'kubernetes-cluster::kube-apiserver'
include_recipe 'kubernetes-cluster::kube-controller'
include_recipe 'kubernetes-cluster::kube-scheduler'
include_recipe 'kubernetes-cluster::network'
