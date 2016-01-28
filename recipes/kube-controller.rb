#
# Cookbook Name:: kubernetes-cluster
# Recipe:: kube-controller
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
# All rights reserved - Do Not Redistribute

service 'kube-controller-manager' do
  action :enable
end

template '/etc/kubernetes/controller-manager' do
  mode '0640'
  source 'kube-controller-manager.erb'
  notifies :restart, 'service[kube-controller-manager]', :immediately
end


