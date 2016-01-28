#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

service 'kube-proxy' do
  action :enable
end

template '/etc/kubernetes/proxy' do
  mode '0640'
  source 'kube-proxy.erb'
  notifies :restart, 'service[kube-proxy]', :immediately
end
