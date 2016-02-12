# kubernetes-cluster cookbook
[![Build Status](https://img.shields.io/travis/bloomberg/kubernetes-cluster-cookbook.svg)](https://travis-ci.org/bloomberg/kubernetes-cluster-cookbook)
[![Code Quality](https://img.shields.io/codeclimate/github/bloomberg/kubernetes-cluster-cookbook.svg)](https://codeclimate.com/github/bloomberg/kubernetes-cluster-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/kubernetes-cluster.svg)](https://supermarket.chef.io/cookbooks/kubernetes-cluster)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

Application cookbook which installs and configures a Kubernetes cluster.

## Supported Platforms
- RHEL 7.1+ (CentOS 7.1+)

## Basic Usage

Configure masters using kubernetes-cluster::master
Configure minions using kubernetes-cluster::minion
Configure Docker registry using kubernetes-cluster::registry

The purpose of this cookbook is to install and configure the proper sevices to create application container clusters. This includes etcd, Kubernetes, Flannel, and Docker- specifically aimed at operating on Enterprise Linux platforms. The best method to using this cookbook is to create a wrapper with specific configurations for your project, adding this cookbook as a dependency. This cookbook assumes you have access to a chef server- however, the cookbook will work fine without it if you override node['kubernetes']['etcd']['members'] in attributes/master.rb node['kubernetes']['master']['fqdn'] in attributes/minion.rb in insecure mode. Secure mode requires more configuration.

- First, converge your masters, The first master converge may fail due to ETCD cluster sync oddities, I am working for a resolution for this. Just re-converge the masters that fail.
- Second, converge your minions.

Example solo.json for master
```json
{
  "kubernetes": {
    "etcd": {
      "members": ["master1.example.com", "master2.example.com", "master3.example.com"]
    }
  },
  "run_list": ["recipe[kubernetes-cluster::master]"]
}
```

Example solo.json for minion
```json
{
  "kubernetes": {
    "master": {
      "fqdn": ["master1.example.com", "master2.example.com", "master3.example.com"]
    }
  },
  "run_list": ["recipe[kubernetes-cluster::minion]"]
}
```

## Advanced Usage

As well as configuring a simple Kubernetes cluster, this cookbook also allows for far more advanced configurations. These configurations range from changing flannel network layout, to enabling secure communications, and adding additional Docker regestries. Secure mode will configure SSL and TLS connections for all endpoints for etcd and Kubernetes. This is HIGHLY recommended for production-like purposes. This will require large amounts of prep work. You can also set URLs for additional Docker registries for the minions to get container images from- as well as configuring said registry.

First, set node['kubernetes']['secure']['enabled'] = 'true' and read below:

I highly recommend you use a tool like CFSSL (CloudFlare SSL) to create your certificates, check out https://www.digitalocean.com/community/tutorials/how-to-secure-your-coreos-cluster-with-tls-ssl-and-firewall-rules and start at "Use CFSSL to Generate Self-Signed Certificates"

Masters:
- node['kubernetes']['etcd']['peer']['ca'] - Certificate authority for managing authentication for master to master connections (etcd sync)
- node['kubernetes']['etcd']['peer']['cert'] - Certificate the master identifies as for peer connections (Signed by peer CA)
- node['kubernetes']['etcd']['peer']['key'] - Key matching peer certificate
- node['kubernetes']['etcd']['client']['ca'] - Certificate authority for managing authentication for client to master connections (etcdctl/kubectl/kubelet)
- node['kubernetes']['etcd']['client']['cert'] - Certificate the client identifies as for connections (Signed by client CA)
- node['kubernetes']['etcd']['client']['key'] - Key matching client certificate

Minions:
- node['kubernetes']['etcd']['client']['ca'] - Certificate authority for verifying cert validity for client to master connections
- node['kubernetes']['etcd']['client']['cert'] - Certificate the client identifies as for connections (Signed by client CA)
- node['kubernetes']['etcd']['client']['key'] - Key matching client certificate

NOTE: Peer and Client CA can be the same. This will allow for far simpler setup. However, you may use a different CA to more closely manage security if desired.
NOTE: Additional exposed attributes contain notes for usage in the appropriate attributes file.

Example solo.json for master
```json
{
  "kubernetes": {
    "etcd": {
      "members": ["master1.example.com", "master2.example.com", "master3.example.com"],
      "basedir": "/kube/etcd",
      "peer": {
        "ca": "-----BEGIN CERTIFICATE-----\ndatadata\n-----END CERTIFICATE-----",
        "cert": "-----BEGIN CERTIFICATE-----\ndatadata\n-----END CERTIFICATE-----",
        "key": "-----BEGIN KEY-----\ndatadata\n-----END KEY-----"
      },
      "client": {
        "ca": "-----BEGIN CERTIFICATE-----\ndatadata\n-----END CERTIFICATE-----",
        "cert": "-----BEGIN CERTIFICATE-----\ndatadata\n-----END CERTIFICATE-----",
        "key": "-----BEGIN KEY-----\ndatadata\n-----END KEY-----"
      }
    },
    "secure": {
      "enabled": "true"
    },
    "master": {
      "podmaster-source": "registry.example.com:5000/podmaster:1.1",
      "scheduler-source": "registry.example.com:5000/scheduler:1.0.3",
      "controller-manager-source": "registry.example.com:5000/controller-manager:1.0.3"
    }
  },
  "docker": {
    "environment": {
      "docker-registry": "registry.example.com:5000",
      "registry-insecure": "registry.example.com:5000",
      "docker-basedir": "/kube/docker"
    }
  },
  "run_list": ["recipe[kubernetes-cluster::master]"]
}
```

Example solo.json for minion
```json
{
  "kubernetes": {
    "etcd": {
      "client": {
        "ca": "-----BEGIN CERTIFICATE-----\ndatadata\n-----END CERTIFICATE-----",
        "cert": "-----BEGIN CERTIFICATE-----\ndatadata\n-----END CERTIFICATE-----",
        "key": "-----BEGIN KEY-----\ndatadata\n-----END KEY-----"
      }
    },
    "master": {
      "fqdn": ["master1.example.com", "master2.example.com", "master3.example.com"]
    },
    "secure": {
      "enabled": "true"
    }
  },
  "docker": {
    "environment": {
      "docker-registry": "registry.example.com:5000",
      "registry-insecure": "registry.example.com:5000",
      "docker-basedir": "/kube/docker"
    }
  },
  "kubelet": {
    "pause-source": "registry.example.com:5000/pause:base",
    "register": "true"
  },
  "run_list": ["recipe[kubernetes-cluster::minion]"]
}
```

Example solo.json for registry
```json
{
  "kubernetes": {
    "registry": {
      "port": "5000",
      "workers": "8",
      "storage": "/kube/docker-storage/"
    }
  },
  "run_list": ["recipe[kubernetes-cluster::registry]"]
}
```

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
