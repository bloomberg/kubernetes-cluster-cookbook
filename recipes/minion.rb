#
# Cookbook Name:: kubernetes-cluster
# Recipe:: minion
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
# All rights reserved - Do Not Redistribute
node.tag('kubernetes.minion')

#Get hostname for kubernetes master DEFAULT REQUIRES CHEF SERVER
include_recipe 'kubernetes-cluster::default'
include_recipe 'kubernetes-cluster::proxy'

case node['platform']
when 'redhat', 'centos', 'fedora'
  yum_package "#{node['kubernetes_cluster']['package']['docker']['name']} #{node['kubernetes_cluster']['package']['docker']['version']}"
  yum_package "kubernetes-node #{node['kubernetes_cluster']['package']['kubernetes_node']['version']}"
  yum_package "bridge-utils #{node['kubernetes_cluster']['package']['bridge_utils']['version']}"
end

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
