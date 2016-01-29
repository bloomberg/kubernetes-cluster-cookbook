#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

default['proxy'].tap do |proxy|
  # Set api servers for HA
  proxy['api']['servers'] = nil
end
