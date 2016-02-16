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
end

default['kubernetes']['etcd'].tap do |etcd|
  # etcd client and peer communication ports
  etcd['clientport'] = '2379'
  etcd['peerport'] = '2380'

  # etcd client name for etcd membership
  etcd['clientname'] = node['fqdn']

  # etcd directory for data storage
  etcd['basedir'] = '/var/lib/etcd'

  # etcd token for initial cluster creation
  etcd['token'] = 'newtoken'

  # List of etcd members
  # This defaults to chef server search capabilities in etcd.rb unless run in chef solo mode
  # If you override this, set this to ALL masters eg:
  # etcd['members'] = ["node1.example.com", "node2.example.com", "node3.example.com"]
  etcd['members'] = nil

  # Set the ssl ca/cert/key for ETCD peer (master to master) communication when ['kubernetes']['secure']['enabled'] = 'true'
  etcd['peer']['ca'] = nil
  etcd['peer']['cert'] = nil
  etcd['peer']['key'] = nil

  # Set the ssl ca/cert/key for ETCD client (minion to master) communication when ['kubernetes']['secure']['enabled'] = 'true'
  etcd['client']['ca'] = nil
  etcd['client']['cert'] = nil
  etcd['client']['key'] = nil
end

# Tell kubelet not to register on master
override['kubelet']['register'] = 'false'
