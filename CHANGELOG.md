# Change Log
All notable changes to this project will be documented in this file.
This project will adhere to strict
[Semantic Versioning](http://semver.org/) starting at v1.0.0.

## 1.1.0
- Able to configure multiple registries in docker config

## 1.0.7
- Fix bug with insecure podmaster connecting to wrong port

## 1.0.6
- Make docker secrets and ssl certificate writeout as sensitive to prevent stdout scraping of credentials

## 1.0.5
- Add ability to set docker registry credentials for pullling from secured registry

## 1.0.4
- Bugfix with proxy in insecure mode
- Always create kube-services group
- Added default attribute for kubelet log lefel

## 1.0.3
- Bugfix with kube-proxy deployment
- Fully tested in both secure and insecure mode for HA setup using Kubernetes 1.0.3 and Docker 1.8.2
- Fixed pathing in mount points and templates for podmaster/controller/scheduler

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
