#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

service 'docker' do
  action :enable
end

execute 'docker-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end
directory '/etc/systemd/system/docker.service.d'

if node['docker']['secure']['registry']
  directory '/root/.docker'
  template '/root/.docker/config.json' do
    source 'dockerconfig.erb'
    variables(
      docker_registry: node['docker']['secure']['registry'],
      docker_secret: node['docker']['secure']['secret'],
      docker_email: node['docker']['secure']['email']
    )
    notifies :restart, 'service[docker]', :delayed
    sensitive true
  end
end

template '/etc/systemd/system/docker.service.d/http-proxy.conf' do
  source 'docker-env.erb'
  variables(
    docker_proxy: node['docker']['environment']['proxy'],
    docker_noproxy: node['docker']['environment']['no-proxy']
  )
  notifies :run, 'execute[docker-reload]', :immediately
end

template '/etc/sysconfig/docker' do
  mode '0640'
  source 'docker.erb'
  variables(
    docker_basedir: node['docker']['environment']['docker-basedir'],
    docker_registry: node['docker']['environment']['docker-registry'],
    docker_insecureregistry: node['docker']['environment']['registry-insecure']
  )
  notifies :restart, 'service[docker]', :delayed
end
