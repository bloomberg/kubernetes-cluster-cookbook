#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

# Enable security
# This will tell the cookbook to make your cluster more secure
# This enables SSL certificates, enables authn/authz, and disables insecure ports
# this will make the cookbook run far more complicated- and will require a lot of
# pre-work such as manually generating SSL certificates and figuring your own way
default['kubernetes']['secure']['enabled'] = false
default['kubernetes']['secure']['directory'] = '/etc/kubernetes/secrets'

# Set the ssl ca/cert/key for ETCD peer (master to master) communication when ['kubernetes']['secure']['enabled']
default['kubernetes']['secure']['data_bag_name'] = 'kubernetes'
default['kubernetes']['secure']['data_bag_item'] = 'kubernetes'

default['kubernetes']['secure']['peer']['item_name'] = 'peer'
default['kubernetes']['secure']['peer']['ca'] = 'ca'
default['kubernetes']['secure']['peer']['cert'] = 'cert'
default['kubernetes']['secure']['peer']['key'] = 'key'

# Set the ssl ca/cert/key for ETCD client (minion to master) communication when ['kubernetes']['secure']['enabled']
default['kubernetes']['secure']['client']['item_name'] = 'client'
default['kubernetes']['secure']['client']['ca'] = 'ca'
default['kubernetes']['secure']['client']['cert'] = 'cert'
default['kubernetes']['secure']['client']['key'] = 'key'

# Port to host/access Kubernetes API
default['kubernetes']['insecure']['apiport'] = '8080'
default['kubernetes']['secure']['apiport'] = '8443'

default['kubernetes']['insecure']['apihost'] = '127.0.0.1'
default['kubernetes']['secure']['apihost'] = '127.0.0.1'

default['kubernetes']['allow_privileged'] = false
default['kubernetes']['cluster_domain'] = 'cluster.local'
default['kubernetes']['cluster_dns'] = nil

# Set port for Kubelet communication
default['kubelet']['port'] = '10250'

# Tell kubelet to register node
default['kubelet']['register']['node'] = true

# Tell kubelet to schedule pods on this node
default['kubelet']['register']['schedulable'] = true

# Set pause container source in case of network connectivity issues (eg you are behind a firewall)
default['kubelet']['pause-source'] = nil

default['kubelet']['extra_args'] = []

# Set hostname for kubelet
default['kubelet']['hostname'] = node['fqdn']

default['docker']['environment'].tap do |environment|
  # Add custom docker registry- optionally insecure
  environment['docker-registry'] = nil
  environment['registry-insecure'] = nil

  # Set docker base directory for local storage- make sure this has plenty of space, optimally its own volume
  # This directory will be created if it does not exist
  environment['docker-basedir'] = nil

  # Set docker daemon proxy settings
  environment['proxy'] = nil
  environment['no-proxy'] = nil
end

# Set optional docker registry credentials
default['docker']['secure']['registry'] = nil
default['docker']['secure']['secret'] = nil
default['docker']['secure']['email'] = nil

# Set kubelet log level- 0 is lowest
default['kubernetes']['log']['level'] = '5'

# Package versions
default['kubernetes']['package']['flannel']['version'] = '>= 0.2.0'
default['kubernetes']['package']['docker']['name'] = 'docker'
default['kubernetes']['package']['docker']['version'] = '= 1.8.2'
default['kubernetes']['package']['kubernetes_master']['version'] = '= 1.0.3'
default['kubernetes']['package']['kubernetes_node']['version'] = '= 1.0.3'
default['kubernetes']['package']['etcd']['version'] = '>= 2.0.0'
default['kubernetes']['package']['cockpit']['enabled'] = true
default['kubernetes']['package']['cockpit']['version'] = '>= 0.71'
default['kubernetes']['package']['docker_registry']['version'] = '>= 0.9.1'
default['kubernetes']['package']['bridge_utils']['version'] = '>= 1.5'
default['kubernetes']['package']['haproxy']['version'] = '>= 1.5.4'
