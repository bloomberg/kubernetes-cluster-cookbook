#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

service 'docker' do
  action :enable
end

template '/etc/systemd/system.docker.service.d/http-proxy.conf' do
  source 'docker-env.erb'
  variables(
    docker_proxy: node['docker']['environment']['proxy'],
    docker_noproxy: node['docker']['environment']['no-proxy']
  )
  notifies :run, 'command[docker-reload]', :immediately
end

template '/etc/sysconfig/docker' do
  mode '0640'
  source 'docker.erb'
  variables(
    docker_basedir: node['kubernetes']['minion']['docker-basedir'],
    docker_registry: node['kubernetes']['minion']['docker-registry'],
    docker_insecureregistry: node['kubernetes']['minion']['registry-insecure']
  )
  notifies :restart, 'service[docker]', :delayed
end
