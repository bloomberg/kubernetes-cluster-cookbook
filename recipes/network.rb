#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

if node['kubernetes']['secure']['enabled'] == 'true'
  etcdcmd = "etcdctl --peers=https://127.0.0.1:2379 --cert-file=#{node['kubernetes']['secure']['directory']}/client.srv.crt --key-file=#{node['kubernetes']['secure']['directory']}/client.srv.key --ca-file=#{node['kubernetes']['secure']['directory']}/client.ca.crt"
elsif node['kubernetes']['secure']['enabled'] == 'false'
  etcdcmd = 'etcdctl'
end

execute 'getnetwork' do
  command "#{etcdcmd} get coreos.com/network/config | sed '/^$/d' > /etc/sysconfig/flannel-network"
  only_if { flannel_network? }
  action :nothing
end.run_action(:run)

execute 'setnetwork' do
  command "#{etcdcmd} set coreos.com/network/config < /etc/sysconfig/flannel-network"
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
