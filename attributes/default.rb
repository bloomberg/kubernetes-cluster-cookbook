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
default['kubernetes']['secure']['enabled'] = 'false'
default['kubernetes']['secure']['directory'] = '/etc/kubernetes/secrets'

# Port to host/access Kubernetes API
default['kubernetes']['insecure']['apiport'] = '8080'
default['kubernetes']['secure']['apiport'] = '8443'

# Set port for Kubelet communication
default['kubelet']['port'] = '10250'

# Set pause container source in case of network connectivity issues (eg you are behind a firewall)
default['kubelet']['pause-source'] = nil

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

# Package versions
default['kubernetes_cluster']['package']['flannel']['version'] = '>= 0.2.0'
default['kubernetes_cluster']['package']['docker']['name'] = 'docker'
default['kubernetes_cluster']['package']['docker']['version'] = '= 1.8.2'
default['kubernetes_cluster']['package']['kubernetes_client']['version'] = '= 1.0.3'
default['kubernetes_cluster']['package']['kubernetes_master']['version'] = '= 1.0.3'
default['kubernetes_cluster']['package']['kubernetes_node']['version'] = '= 1.0.3'
default['kubernetes_cluster']['package']['etcd']['version'] = '>= 2.0.0'
default['kubernetes_cluster']['package']['cockpit']['enabled'] = true
default['kubernetes_cluster']['package']['cockpit']['version'] = '>= 0.71'
default['kubernetes_cluster']['package']['docker_registry']['version'] = '>= 0.9.1'
default['kubernetes_cluster']['package']['bridge_utils']['version'] = '>= 1.5'
default['kubernetes_cluster']['package']['haproxy']['version'] = '>= 1.5.4'
