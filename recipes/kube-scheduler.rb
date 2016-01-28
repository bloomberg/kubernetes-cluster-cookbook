#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

service 'kube-scheduler' do
  action :enable
end

template '/etc/kubernetes/scheduler' do
  mode '0640'
  source 'kube-scheduler.erb'
  notifies :restart, 'service[kube-scheduler]', :immediately
end
