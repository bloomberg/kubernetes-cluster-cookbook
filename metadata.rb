name 'kubernetes-cluster'
maintainer 'Drew Rapenchuk'
maintainer_email 'drapenchuk@bloomberg.net'
license 'Apache 2.0'
description 'Application cookbook for installing and configuring a Kubernetes cluster.'
long_description 'Application cookbook for installing and configuring a Kubernetes cluster.'
version '1.0.1'

%w(centos redhat).each do |name|
  supports name, '~> 7.1'
end
