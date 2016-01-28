# kubernetes-cluster cookbook
[![Build Status](https://img.shields.io/travis/bloomberg/kubernetes-cluster-cookbook.svg)](https://travis-ci.org/bloomberg/kubernetes-cluster-cookbook)
[![Code Quality](https://img.shields.io/codeclimate/github/bloomberg/kubernetes-cluster-cookbook.svg)](https://codeclimate.com/github/bloomberg/kubernetes-cluster-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/kubernetes-cluster.svg)](https://supermarket.chef.io/cookbooks/confd)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

Application cookbook which installs and configures a Kubernetes
cluster.

## Supported Platforms
- RHEL 7.1+ (CentOS 7.1+)

## Basic Usage

The purpose of this cookbook is to install and configure the proper sevices to create application container clusters. This includes etcd, Kubernetes, Flannel, and Docker- specifically aimed at operating on Enterprise Linux platforms. The best method to using this cookbook is to create a wrapper with specific configurations for your project, adding this cookbook as a dependency.

## How to use

This cookbook assumes you have access to a chef server- however, the cookbook will work fine without it if you override node['kubernetes']['master']['fqdn'] in attributes/minion.rb and node['kubernetes']['etcd']['members'] in attributes/master.rb in insecure mode. Secure mode requires more configuration.

## Insecure mode

- First, configure your masters, The first master converge may fail due to ETCD oddities, I am working for a resolution for this. Just re-converge the masters that fail.
- Third, configure your minions, making sure they use the proxy server as the master, not the actual masters.
- Fourth, enjoy!

## Secure mode

Secure mode will configure SSL and TLS connections for all endpoints for etcd and Kubernetes. This is HIGHLY recommended for production-like purposes. This will require large amounts of prep work.
First, set node['kubernetes']['secure']['enabled'] = 'true' and read below:

### SSL/TLS certs

I highly recommend you use a tool like CFSSL (CloudFlare SSL) to create your certificates, check out https://www.digitalocean.com/community/tutorials/how-to-secure-your-coreos-cluster-with-tls-ssl-and-firewall-rules and start at "Use CFSSL to Generate Self-Signed Certificates"

Masters:
- node['kubernetes']['etcd']['peer']['ca'] - Certificate authority for managing authentication for master to master connections (etcd sync)
- node['kubernetes']['etcd']['peer']['cert'] - Certificate the master identifies as for peer connections
- node['kubernetes']['etcd']['peer']['key'] - Key matching peer certificate
- node['kubernetes']['etcd']['client']['ca'] - Certificate authority for managing authentication for client to master connections (etcdctl/kubectl/kubelet)
- node['kubernetes']['etcd']['client']['cert'] - Certificate the client identifies as for connections
- node['kubernetes']['etcd']['client']['key'] - Key matching client certificate

Minions:
- node['kubernetes']['etcd']['client']['ca'] - Certificate authority for managing authentication for client to master
- node['kubernetes']['etcd']['client']['cert'] - Certificate the client identifies as for connections
- node['kubernetes']['etcd']['client']['key'] - Key matching client certificate

NOTE: Peer and Client CA can be the same. This will allow for far simpler setup. However, you may use a different CA to more closely manage security if desired.

## Additional considerations

- Minions get a local HAPROXY setup that does HA type functions between multiple masters if needed
- Local storage is only supported right now, this is to add speed to containers and to cluster setup
- ALL attributes used are found with a description in an appropriate attributes file. review and make changes as appropriate.

## Testing
This project will use [Test Kitchen][1] to execute the [ChefSpec][2] tests
on a clean virtual machine. By default Test Kitchen will use [Vagrant][3]
and attempt to start a new virtual machine up from a [default Opscode box][4].
```shell
bin/kitchen test default-centos-7.1
```
However, no meaningful tests are currently written. This will be fixed.

[1]: https://kitchen.ci
[2]: https://github.com/sethvargo/chefspec
[3]: http://vagrantup.com
[4]: https://github.com/opscode/bento
