#
# Cookbook Name:: kubernetes-cluster
# Recipe:: network
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
# All rights reserved - Do Not Redistribute
#

#Hackish way to pull flannel network config
Chef::Resource::Execute.send(:include, Flannel::Network)

execute 'getnetwork' do
  command "etcdctl get coreos.com/network/config | sed '/^$/d' > /etc/sysconfig/flannel-network"
  only_if { flannel_network? }
  action :nothing
end.run_action(:run)

execute 'setnetwork' do 
  command 'etcdctl set coreos.com/network/config < /etc/sysconfig/flannel-network'
  action :nothing
end

template '/etc/sysconfig/flannel-network' do
  mode '0640'
  source 'flannel-network.erb'
  variables(
    flannel_network: node['kubernetes']['master']['flannel-network'],
    flannel_netlength: node['kubernetes']['master']['flannel-netlength']
  )
  notifies :run, 'execute[setnetwork]', :immediately
end
