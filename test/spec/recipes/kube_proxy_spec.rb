require 'spec_helper'

describe_recipe 'kubernetes-cluster::kube-proxy' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run).to enable_service('kube-proxy') }

    it 'should create template "/etc/kubernetes/proxy"' do
      expect(chef_run).to create_template('/etc/kubernetes/proxy').with(
        mode: '0640',
        source: 'kube-proxy.erb',
        variables: {
          etcd_cert_dir: '/etc/kubernetes/secrets'
        }
      )
      resource = chef_run.template('/etc/kubernetes/proxy')
      expect(resource).to notify('service[kube-proxy]').to(:restart).immediately
    end
  end
end
