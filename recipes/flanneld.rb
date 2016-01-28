#
# Cookbook Name:: kubernetes-cluster
# Recipe:: flanneld
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
# All rights reserved - Do Not Redistribute
#

service 'flanneld' do
  action :enable
end

service 'docker' do
  action :nothing
  only_if { node.run_list.include?('recipe[kubernetes-cluster::minion]') }
end

service 'kubelet' do
  action :nothing
  only_if { node.run_list.include?('recipe[kubernetes-cluster::minion]') }
end

execute 'redo-docker-bridge' do
  command 'ifconfig docker0 down; brctl delbr docker0'
  action :nothing
  notifies :restart, 'service[docker]', :immediately
  only_if { node.run_list.include?('recipe[kubernetes-cluster::minion]') }
end

template '/etc/sysconfig/flanneld' do
  mode '0640'
  source 'flannel-flanneld.erb'
  variables(
    etcd_client_port: node['kubernetes']['etcd']['clientport'],
    etcd_cert_dir: node['kubernetes']['secure']['directory']
  )
  notifies :restart, 'service[flanneld]', :immediately
  notifies :run, 'execute[redo-docker-bridge]', :immediately
  notifies :restart, 'service[kubelet]', :delayed
end
