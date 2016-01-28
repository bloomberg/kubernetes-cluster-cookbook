# Change Log All notable changes to this project will be documented in
this file.  This project will adhere to strict
[Semantic Versioning](http://semver.org/) starting at v1.0.0.

## [0.6.0] - 2015-12-02
### Changed
- Can provision a proxy inside the cluster for HA purposes
- Can provision multiple masters for API HA
- Clustered etcd for masters possible at cluster creation
- Minions can use cluster proxy for API and etcd
- Can configure where docker stores data
- Can configure etcd data storage location on masters
- Can specify a pause container for Kubelet

## [0.3.0] - 2015-11-16
### Changed
- First workable release
- Provisioning of single master
- Supports creation of docker registry
- Configures flannel networking
- Configures docker bridge
- Configures Kubelets
