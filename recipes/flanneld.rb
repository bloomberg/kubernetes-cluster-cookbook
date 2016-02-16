#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

service 'flanneld' do
  action :enable
end

service 'docker' do
  action :nothing
end

service 'kubelet' do
  action :nothing
end

execute 'redo-docker-bridge' do
  command 'ifconfig docker0 down; brctl delbr docker0'
  action :nothing
  notifies :restart, 'service[docker]', :immediately
end

template '/etc/sysconfig/flanneld' do
  mode '0640'
  source 'flannel-flanneld.erb'
  variables(
    etcd_client_port: node['kubernetes']['etcd']['clientport'],
    etcd_cert_dir: node['kubernetes']['secure']['directory']
  )
  notifies :restart, 'service[flanneld]', :immediately
  notifies :run, 'execute[redo-docker-bridge]', :delayed
  notifies :restart, 'service[kubelet]', :delayed
end
