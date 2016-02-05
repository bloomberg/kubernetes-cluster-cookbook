#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

Chef::Resource::Execute.send(:include, KubernetesCookbook::Helpers)

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
