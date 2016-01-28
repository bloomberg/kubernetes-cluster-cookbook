#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

template '/etc/kubernetes/config' do
  mode '0640'
  source 'kube-config.erb'
  variables(
    kubernetes_master: node['fqdn'],
    kubernetes_api_port: node['kubernetes']['apiport']
  )
end
