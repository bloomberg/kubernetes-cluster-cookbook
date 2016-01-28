#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

service 'kube-controller-manager' do
  action :enable
end

template '/etc/kubernetes/controller-manager' do
  mode '0640'
  source 'kube-controller-manager.erb'
  notifies :restart, 'service[kube-controller-manager]', :immediately
end
