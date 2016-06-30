require 'spec_helper'

describe_recipe 'kubernetes-cluster::default' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run).to install_yum_package('flannel >= 0.2.0') }
    it { expect(chef_run).to install_yum_package('docker = 1.8.2') }
    it { expect(chef_run).to install_yum_package('kubernetes-node = 1.0.3') }
    it { expect(chef_run).to install_yum_package('bridge-utils >= 1.5') }
    it { expect(chef_run).to disable_service('firewalld') }
    it { expect(chef_run).to stop_service('firewalld') }
    it { expect(chef_run).to create_group('kube-services') }
    it { expect(chef_run).to_not create_directory('/etc/kubernetes/secrets') }
  end

  context 'with node[\'kubernetes\'][\'secure\'][\'enabled\'] = true' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['kubernetes']['secure']['enabled'] = 'true'
      end.converge(described_recipe)
    end

    it 'should create directory "/etc/kubernetes/secrets"' do
      expect(chef_run).to create_directory('/etc/kubernetes/secrets').with(
        owner: 'root',
        group: 'kube-services',
        mode: '0770',
        recursive: true
      )
    end
  end
end
