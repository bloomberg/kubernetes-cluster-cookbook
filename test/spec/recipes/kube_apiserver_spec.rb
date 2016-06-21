require 'spec_helper'

describe_recipe 'kubernetes-cluster::kube-apiserver' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run).to enable_service('kube-apiserver') }
    it { expect(chef_run.node['kubernetes']['master']['fqdn']).to eq('fauxhai.local') }
    it { expect(chef_run).to_not create_template('/etc/kubernetes/etcd.client.conf') }

    it 'should create template "/etc/kubernetes/apiserver"' do
      expect(chef_run).to create_template('/etc/kubernetes/apiserver').with(
        mode: '0640',
        source: 'kube-apiserver.erb',
        variables: {
          etcd_client_port: '2379',
          etcd_cert_dir: '/etc/kubernetes/secrets',
          kubelet_port: '10250',
          kubernetes_api_port: '8080',
          kubernetes_master: 'fauxhai.local',
          kubernetes_network: '1.90.0.0/16',
          kubernetes_secure_api_port: '8443'
        }
      )
      resource = chef_run.template('/etc/kubernetes/apiserver')
      expect(resource).to notify('service[kube-apiserver]').to(:restart).immediately
    end
  end

  context 'with node[\'kubernetes\'][\'secure\'][\'enabled\'] = true' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['kubernetes']['secure']['enabled'] = 'true'
      end.converge(described_recipe)
    end

    it 'should create template "/etc/kubernetes/etcd.client.conf"' do
      expect(chef_run).to create_template('/etc/kubernetes/etcd.client.conf').with(
        mode: '0644',
        source: 'kube-apiserver-etcd.erb',
        variables: {
          etcd_client_port: '2379',
          etcd_cert_dir: '/etc/kubernetes/secrets',
          kubernetes_master: 'fauxhai.local'
        }
      )
    end
  end
end
