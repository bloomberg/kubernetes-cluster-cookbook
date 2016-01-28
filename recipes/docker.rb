#
# Cookbook Name:: kubernetes-cluster
# Recipe:: docker
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
# All rights reserved - Do Not Redistribute

service 'docker' do
  action :enable
end

template '/etc/sysconfig/docker' do
  mode '0640'
  source 'docker.erb'
  variables(
    docker_basedir: node['kubernetes']['minion']['docker-basedir'],
    docker_registry: node['kubernetes']['minion']['docker-registry'],
    docker_insecureregistry: node['kubernetes']['minion']['registry-insecure']
  )
  notifies :restart, 'service[docker]', :delayed
end

