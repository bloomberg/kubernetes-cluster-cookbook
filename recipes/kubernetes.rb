#
# Cookbook Name:: kubernetes-cluster
# Recipe:: kubernetes
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
# All rights reserved - Do Not Redistribute

template '/etc/kubernetes/config' do
  mode '0640'
  source 'kube-config.erb'
  variables(
    kubernetes_master: node['fqdn'],
    kubernetes_api_port: node['kubernetes']['apiport']
  )
end

