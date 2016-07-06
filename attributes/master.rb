#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

default['kubernetes']['master'].tap do |master|
  # Set the flannel network size of the cluster, and netlength of each node
  master['flannel-network'] = '1.80.0.0/16'
  master['flannel-netlength'] = '24'

  # Set the Kubernetes service network size
  master['service-network'] = '1.90.0.0/16'

  # Get the Kubernetes master hostname
  master['fqdn'] = node['fqdn']

  # Set the source for the podmaster controller-manager, and scheduler container images
  # Override this in case of network connectivity issues (eg you are behind a firewall and cannot reach gcr.io)
  master['podmaster-source'] = 'gcr.io/google_containers/podmaster:1.1'
  master['scheduler-source'] = 'gcr.io/google_containers/kube-scheduler:34d0b8f8b31e27937327961528739bc9'
  master['controller-manager-source'] = 'gcr.io/google_containers/kube-controller-manager:fda24638d51a48baa13c35337fcd4793'
  master['use_etc_config'] = true

  master['enabled_recipes'] = %w(
      etcd
      kubernetes
      kube-apiserver
      network
      docker
      flanneld
      kubelet
      kube-controller
      kube-scheduler
    )
end

default['kubernetes']['etcd'].tap do |etcd|
  # etcd client and peer communication ports
  etcd['clientport'] = '2379'
  etcd['clienthost'] = '127.0.0.1'
  etcd['peerport'] = '2380'

  # etcd client name for etcd membership
  etcd['clientname'] = node['fqdn']
  etcd['bind_address'] = '127.0.0.1'

  # etcd directory for data storage
  etcd['basedir'] = '/var/lib/etcd'

  # etcd token for initial cluster creation
  etcd['token'] = 'newtoken'
  etcd['clusterstate'] = 'new'

  # List of etcd members
  # This defaults to chef server search capabilities in etcd.rb unless run in chef solo mode
  # If you override this, set this to ALL masters eg:
  # etcd['members'] = ["node1.example.com", "node2.example.com", "node3.example.com"]
  etcd['members'] = nil

  etcd['heartbeat_interval'] = 100
  etcd['election_timeout'] = 1000
end

# Tell kubelet not to schedule pods on master
override['kubelet']['register']['schedulable'] = false
