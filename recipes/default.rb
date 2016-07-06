#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

case node['platform']
when 'redhat', 'centos', 'fedora'
  yum_package "flannel #{node['kubernetes']['package']['flannel']['version']}"
  yum_package "#{node['kubernetes']['package']['docker']['name']} #{node['kubernetes']['package']['docker']['version']}"
  yum_package "kubernetes-node #{node['kubernetes']['package']['kubernetes_node']['version']}"
  yum_package "bridge-utils #{node['kubernetes']['package']['bridge_utils']['version']}"
  service 'firewalld' do
    action [:disable, :stop]
  end
end

group 'kube-services'

directory node['kubernetes']['secure']['directory'] do
  only_if { node['kubernetes']['secure']['enabled'] }
  owner 'root'
  group 'kube-services'
  mode '0770'
  recursive true
  action :create
end
