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
    kubernetes_log_level: node['kubernetes']['log']['level'],
    kubernetes_master: node['fqdn'],
    kubernetes_api_port: node['kubernetes']['insecure']['apiport'],
    kubernetes_secure_api_port: node['kubernetes']['secure']['apiport'],
    etcd_cert_dir: node['kubernetes']['secure']['directory']
  )
end
