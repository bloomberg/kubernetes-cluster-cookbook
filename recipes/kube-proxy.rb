#
# Cookbook Name:: kubernetes-cluster
# Recipe:: kube-proxy
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
# All rights reserved - Do Not Redistribute

service 'kube-proxy' do
  action :enable
end

template '/etc/kubernetes/proxy' do
  mode '0640'
  source 'kube-proxy.erb'
  notifies :restart, 'service[kube-proxy]', :immediately
end

