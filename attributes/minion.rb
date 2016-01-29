#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

default['kubernetes']['minion'].tap do |minion|

  #Set hostname for kubelet
  minion['kubelet-hostname'] = node['fqdn']

  #Set pause container source in case of network connectivity issues
  minion['pause-source'] = nil

  #Add custom docker registry- optionally insecure
  minion['docker-registry'] = nil
  minion['registry-insecure'] = nil

  #Set docker base directory for local storage- make sure this has plenty of space, optimally its own volume
  #This directory will be created if it does not exist
  minion['docker-basedir'] = nil

end

#Your kubernetes master fqdn OR cluster proxy
#This defaults to chef server search capabilities in kubelet.rb unless run in chef solo mode
#If you override this, set this to your master fqdn or cluster proxy fqdn:
#default['kubernetes']['master']['fqdn'] = "myclusterproxy.example.com"
#or default['kubernetes']['master']['fqdn'] = "myclustermaster.example.com"
#ONLY statically set the master fqdn as actual master fqdn if you are not doing an HA setup"
default['kubernetes']['master']['fqdn'] = nil

#Set the ssl cert/key for ETCD client (minion to master) communication when ['kubernetes']['secure']['enabled'] = 'true'
default['kubernetes']['etcd']['client']['ca'] = nil
default['kubernetes']['etcd']['client']['cert'] = nil
default['kubernetes']['etcd']['client']['key'] = nil
