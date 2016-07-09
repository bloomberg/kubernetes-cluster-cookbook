#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

node.tag('kubernetes.master')

include_recipe 'kubernetes-cluster::default'

case node['platform']
  when 'redhat', 'centos', 'fedora'
    yum_package "cockpit #{node['kubernetes']['package']['cockpit']['version']}" do
      only_if { node['kubernetes']['package']['cockpit']['enabled'] }
    end
    yum_package "etcd #{node['kubernetes']['package']['etcd']['version']}"
    yum_package "kubernetes-master #{node['kubernetes']['package']['kubernetes_master']['version']}"
end

group 'kube-services' do
  members %w(etcd kube)
  action :modify
end

directory '/etc/kubernetes/inactive-manifests' do
  owner 'root'
  group 'kube-services'
  mode '0770'
end

directory '/etc/kubernetes/manifests' do
  owner 'root'
  group 'kube-services'
  mode '0770'
end

if node['kubernetes']['secure']['enabled']
  data_bag = Chef::EncryptedDataBagItem.load(node['kubernetes']['secure']['data_bag_name'], node['kubernetes']['secure']['data_bag_item'])
  client_certs = data_bag[node['kubernetes']['secure']['client']['item_name']]
  client_ca = client_certs[node['kubernetes']['secure']['client']['ca']]
  client_cert = client_certs[node['kubernetes']['secure']['client']['cert']]
  client_key = client_certs[node['kubernetes']['secure']['client']['key']]

  peer_certs = data_bag[node['kubernetes']['secure']['peer']['item_name']]
  peer_ca = peer_certs[node['kubernetes']['secure']['peer']['ca']]
  peer_cert = peer_certs[node['kubernetes']['secure']['peer']['cert']]
  peer_key = peer_certs[node['kubernetes']['secure']['peer']['key']]

  file 'kubernetes::master[client.ca.crt]' do
    path "#{node['kubernetes']['secure']['directory']}/client.ca.crt"
    content client_ca
    owner 'root'
    group 'kube-services'
    mode '0770'
    sensitive true
  end
  file "#{node['kubernetes']['secure']['directory']}/client.srv.crt" do
    content client_cert
    owner 'root'
    group 'kube-services'
    mode '0770'
    sensitive true
  end
  file "#{node['kubernetes']['secure']['directory']}/client.srv.key" do
    content client_key
    owner 'root'
    group 'kube-services'
    mode '0770'
    sensitive true
  end

  file "#{node['kubernetes']['secure']['directory']}/client.srv.bundle.crt" do
    content "#{client_cert}\n#{client_ca}"
    owner 'root'
    group 'kube-services'
    mode '0770'
    sensitive true
  end

  file "#{node['kubernetes']['secure']['directory']}/peer.ca.crt" do
    content peer_ca
    owner 'root'
    group 'kube-services'
    mode '0770'
    sensitive true
  end
  file "#{node['kubernetes']['secure']['directory']}/peer.srv.crt" do
    content peer_cert
    owner 'root'
    group 'kube-services'
    mode '0770'
    sensitive true
  end
  file "#{node['kubernetes']['secure']['directory']}/peer.srv.key" do
    content peer_key
    owner 'root'
    group 'kube-services'
    mode '0770'
    sensitive true
  end
end

node['kubernetes']['master']['enabled_recipes'].each do |recipe|
  include_recipe "kubernetes-cluster::#{recipe}"
end
