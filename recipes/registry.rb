#
# Cookbook Name:: kubernetes-cluster
# Recipe:: registry
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
# All rights reserved - Do Not Redistribute

node.tag('docker.registry')

case node['platform']
when 'redhat', 'centos', 'fedora'
  yum_package "docker-registry #{node['kubernetes_cluster']['package']['docker_registry']['version']}"
  yum_package "cockpit #{node['kubernetes_cluster']['package']['cockpit']['version']}"
end

service 'docker-registry' do
  action :enable
end

template '/etc/sysconfig/docker-registry' do
  mode '0640'
  source 'docker-registry.erb'
  variables(
    registry_port: node['docker']['registry']['port'],
    registry_workers: node['docker']['registry']['workers'],
    registry_storage: node['docker']['registry']['storage']
  )
  notifies :restart, 'service[docker-registry]', :immediately
end
