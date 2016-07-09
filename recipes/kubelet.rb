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
  only_if { node['kubernetes']['secure']['enabled'] }
end

kubelet_args = [
  '--config=/etc/kubernetes/manifests',
  "--register-node=#{node['kubelet']['register']['node']}",
  "--register-schedulable=#{node['kubelet']['register']['schedulable']}",
]

if node['kubernetes']['secure']['enabled']
  kubelet_args << "--kubeconfig=#{node['kubernetes']['secure']['directory']}/kube.config"
  kubelet_args << "--tls-cert-file=#{node['kubernetes']['secure']['directory']}/client.srv.bundle.crt"
  kubelet_args << "--tls-private-key-file=#{node['kubernetes']['secure']['directory']}/client.srv.key"
end

kubelet_args << "--pod-infra-container-image=#{node['kubelet']['pause-source']}" if node['kubelet']['pause-source']
kubelet_args << "--cluster-dns=#{node['kubernetes']['cluster_dns']} --cluster-domain=#{node['kubernetes']['cluster_domain']}" if node['kubernetes']['cluster_dns']
kubelet_args << "--node-labels=#{node['kubernetes']['minion']['labels'].join(' ')}" if node['kubernetes']['minion']['labels'] and not node['kubernetes']['minion']['labels'].empty?
kubelet_args << node['kubelet']['extra_args'].join(' ') if node['kubelet']['extra_args'] and not node['kubelet']['extra_args'].empty?

template '/etc/kubernetes/kubelet' do
  mode '0640'
  source 'kube-kubelet.erb'
  variables(
    kubelet_hostname: node['kubelet']['hostname'],
    kubernetes_api_port: node['kubernetes']['insecure']['apiport'],
    kubernetes_api_host: node['kubernetes']['insecure']['apihost'],
    kubernetes_secure_api_port: node['kubernetes']['secure']['apiport'],
    kubernetes_secure_api_host: node['kubernetes']['secure']['apihost'],
    kubelet_args: kubelet_args.join(' ')
  )
  notifies :restart, 'service[kubelet]', :delayed
end
