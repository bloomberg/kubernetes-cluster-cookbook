require 'spec_helper'

describe_recipe 'kubernetes-cluster::docker' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run).to enable_service('docker') }
    it { expect(chef_run).to_not run_execute('docker-reload') }
    it { expect(chef_run).to create_directory('/etc/systemd/system/docker.service.d') }

    it 'should create template "/etc/systemd/system/docker.service.d/http-proxy.conf"' do
      expect(chef_run).to create_template('/etc/systemd/system/docker.service.d/http-proxy.conf').with(
        source: 'docker-env.erb',
        variables: {
          docker_proxy: nil,
          docker_noproxy: nil
        }
      )
      resource = chef_run.template('/etc/systemd/system/docker.service.d/http-proxy.conf')
      expect(resource).to notify('execute[docker-reload]').to(:run).immediately
    end

    it 'should create template "/etc/sysconfig/docker"' do
      expect(chef_run).to create_template('/etc/sysconfig/docker').with(
        mode: '0640',
        source: 'docker.erb',
        variables: {
          docker_basedir: nil,
          docker_registry: nil,
          docker_insecureregistry: nil
        }
      )
      resource = chef_run.template('/etc/sysconfig/docker')
      expect(resource).to notify('service[docker]').to(:restart).delayed
    end
  end

  context 'with node[\'docker\'][\'secure\'][\'registry\'] = true' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['docker']['secure']['email'] = 'email@example.com'
        node.normal['docker']['secure']['registry'] = 'registry.example.com:5000'
        node.normal['docker']['secure']['secret'] = 'changeme'
      end.converge(described_recipe)
    end

    it { expect(chef_run).to create_directory('/root/.docker') }

    it 'should create template "/root/.docker/config.json"' do
      expect(chef_run).to create_template('/root/.docker/config.json').with(
        source: 'dockerconfig.erb',
        variables: {
          docker_registry: 'registry.example.com:5000',
          docker_secret: 'changeme',
          docker_email: 'email@example.com'
        },
        sensitive: true
      )
      resource = chef_run.template('/root/.docker/config.json')
      expect(resource).to notify('service[docker]').to(:restart).delayed
    end
  end
end
