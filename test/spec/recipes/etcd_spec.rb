require 'spec_helper'

describe_recipe 'kubernetes-cluster::etcd' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run).to enable_service('etcd') }

    it 'should create directory "/var/lib/etcd"' do
      expect(chef_run).to create_directory('/var/lib/etcd').with(
        owner: 'etcd',
        group: 'etcd',
        recursive: true
      )
    end

    it 'should create template "/etc/etcd/etcd.conf"' do
      expect(chef_run).to create_template('/etc/etcd/etcd.conf').with(
        mode: '0640',
        source: 'etcd-etcd.erb',
        variables: {
          etcd_client_name: 'fauxhai.local',
          etcd_base_dir: '/var/lib/etcd',
          etcd_client_token: 'newtoken',
          etcd_client_port: '2379',
          etcd_peer_port: '2380',
          etcd_members: nil,
          etcd_cert_dir: '/etc/kubernetes/secrets'
        }
      )
      resource = chef_run.template('/etc/etcd/etcd.conf')
      expect(resource).to notify('service[etcd]').to(:restart).immediately
    end
  end
end
