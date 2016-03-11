#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

template '/etc/kubernetes/manifests/podmaster.yaml' do
  mode '0640'
  source 'podmaster.yaml.erb'
  variables(
    podmaster_image: node['kubernetes']['master']['podmaster-source'],
    etcd_client_port: node['kubernetes']['etcd']['clientport'],
    etcd_cert_dir: node['kubernetes']['secure']['directory']
  )
end
