# Change Log
All notable changes to this project will be documented in this file.
This project will adhere to strict
[Semantic Versioning](http://semver.org/) starting at v1.0.0.

## 1.0.0
- Optional deployment of podmaster for master election of master services
- Deployment of scheduler and controller-manager as pods to take advantage of podmaster election
- Selection of podmaster, scheduler, and controller-manager container image source
- Most likely not backwards compatible
- Made library use TLS certificates for etcdctl if applicable

## 0.7.1
- Bugfixes related to kube client config
- Elimination of race condition caused by docker0 interface slow startup

## 0.7
- Initial public release of the cookbook.
