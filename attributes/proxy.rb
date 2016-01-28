#
# Cookbook Name:: kubernetes-cluster
# Attributes:: proxy
#
# Author: Drew Rapenchuk <drapenchuk@bloomberg.net>
#
# Copyright 2015, Bloomberg, L.P.
#
# All rights reserved - Do Not Redistribute
#

default['proxy'].tap do |proxy|

  #Set api servers for HA
  proxy['api']['servers'] = nil

end
