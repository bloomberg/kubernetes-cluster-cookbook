#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

default['kubernetes']['registry'].tap do |registry|
  # Set port for registry
  registry['port'] = '5000'

  # Set number of workers for Gunicorn
  registry['workers'] = '8'

  # Set storage location base for images and registry metadata
  # Only supports local storage on registry server right now
  # Full path where 'images' and 'registry' directories will be created
  registry['storage'] = '/var/docker-registry/'
end
