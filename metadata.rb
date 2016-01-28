name 'kubernetes-cluster'
maintainer 'Drew Rapenchuk'
maintainer_email 'drapenchuk@bloomberg.net'
license 'All rights reserved'
description 'Cookbook for creating highly available, secure kubernetes clusters.'
long_description 'Cookbook for creating highly available, secure kubernetes clusters.'
version '1.0.0'

%w(centos redhat).each do |name|
  supports name, '~> 7.1'
end

