#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

template '/etc/kubernetes/inactive-manifests/controller-manager.yaml' do
  mode '0640'
  source 'kube-controller-manager.erb'
  variables(
    kube_controller_manager_image: node['kubernetes']['master']['controller-manager-source'],
    kubernetes_api_port: node['kubernetes']['insecure']['apiport']
end
