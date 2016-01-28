#
# Cookbook Name:: kubernetes-cluster
# Recipe:: default
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
# All rights reserved - Do Not Redistribute
#

case node['platform']
when 'redhat', 'centos', 'fedora'
  yum_package "flannel #{node['kubernetes_cluster']['package']['flannel']['version']}"
  service "firewalld" do
    action [ :disable, :stop]
  end
end

group 'kube-services' do
  only_if { node['kubernetes']['secure']['enabled'] == 'true' }
end

directory node['kubernetes']['secure']['directory'] do
  only_if { node['kubernetes']['secure']['enabled'] == 'true' }
  owner 'root'
  group 'kube-services'
  mode '0770'
  recursive true
  action :create
end
