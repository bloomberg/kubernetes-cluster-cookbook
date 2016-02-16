#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

# Your kubernetes master fqdn OR cluster proxy
# This defaults to chef server search capabilities in kubelet.rb unless run in chef solo mode
# If you override this, set this to your master fqdn or an array containing the names of your masters:
# default['kubernetes']['master']['fqdn'] = ['myclustermaster1.example.com', 'myclustermaster2.example.com', 'myclustermaster3.example.com' ]
# or default['kubernetes']['master']['fqdn'] = "myclustermaster.example.com"
# ONLY statically set the master fqdn as a single master fqdn if you are not doing an HA setup"
default['kubernetes']['master']['fqdn'] = nil

# Set the ssl cert/key for ETCD client (minion to master) communication when ['kubernetes']['secure']['enabled'] = 'true'
default['kubernetes']['etcd']['client']['ca'] = nil
default['kubernetes']['etcd']['client']['cert'] = nil
default['kubernetes']['etcd']['client']['key'] = nil

# Tell kubelet to register on minion
default['kubelet']['register'] = 'true'
