#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

file '/var/log/kube-scheduler.log' do
  action :touch
end

template '/etc/kubernetes/inactive-manifests/scheduler.yaml' do
  mode '0640'
  source 'kube-scheduler.erb'
  variables(
    kube_scheduler_image: node['kubernetes']['master']['scheduler-source'],
    kubernetes_api_port: node['kubernetes']['insecure']['apiport'],
    etcd_cert_dir: node['kubernetes']['secure']['directory']
  )
end
