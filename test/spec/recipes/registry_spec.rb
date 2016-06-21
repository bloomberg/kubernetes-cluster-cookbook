require 'spec_helper'

describe_recipe 'kubernetes-cluster::registry' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run.node.tags).to eq(['docker.registry']) }
    it { expect(chef_run).to install_yum_package('docker-registry >= 0.9.1') }
    it { expect(chef_run).to install_yum_package('cockpit >= 0.71') }
    it { expect(chef_run).to enable_service('docker-registry') }

    it 'should create template "/etc/sysconfig/docker-registry"' do
      expect(chef_run).to create_template('/etc/sysconfig/docker-registry').with(
        mode: '0640',
        source: 'docker-registry.erb',
        variables: {
          registry_port: '5000',
          registry_storage: '/var/docker-registry/',
          registry_workers: '8'
        }
      )
      resource = chef_run.template('/etc/sysconfig/docker-registry')
      expect(resource).to notify('service[docker-registry]').to(:restart).immediately
    end
  end
end
