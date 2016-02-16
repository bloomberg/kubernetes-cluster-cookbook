#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

service 'kubelet' do
  action :enable
end

template "#{node['kubernetes']['secure']['directory']}/kube.config" do
  mode '770'
  group 'kube-services'
  source 'kube-kubelet-kube-config.erb'
  variables(
    kubernetes_secure_api_port: node['kubernetes']['secure']['apiport'],
    etcd_cert_dir: node['kubernetes']['secure']['directory']
  )
  only_if { node['kubernetes']['secure']['enabled'] == 'true' }
end

template '/etc/kubernetes/kubelet' do
  mode '0640'
  source 'kube-kubelet.erb'
  variables(
    kubelet_hostname: node['kubelet']['hostname'],
    kubernetes_api_port: node['kubernetes']['insecure']['apiport'],
    kubelet_port: node['kubelet']['port'],
    pause_container: node['kubelet']['pause-source'],
    kubernetes_secure_api_port: node['kubernetes']['secure']['apiport'],
    etcd_cert_dir: node['kubernetes']['secure']['directory'],
    register_node: node['kubelet']['register']
  )
  notifies :restart, 'service[kubelet]', :immediately
end
