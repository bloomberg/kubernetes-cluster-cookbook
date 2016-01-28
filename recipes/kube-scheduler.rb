#
# Cookbook Name:: kubernetes-cluster
# Recipe:: kube-scheduler
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
# All rights reserved - Do Not Redistribute
#

service 'kube-scheduler' do
  action :enable
end

template '/etc/kubernetes/scheduler' do
  mode '0640'
  source 'kube-scheduler.erb'
  notifies :restart, 'service[kube-scheduler]', :immediately
end

