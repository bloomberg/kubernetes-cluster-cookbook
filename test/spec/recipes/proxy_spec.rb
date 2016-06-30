require 'spec_helper'

describe_recipe 'kubernetes-cluster::proxy' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run.node.tags).to eq(['kubernetes.proxy']) }
    it { expect(chef_run).to install_yum_package('haproxy >= 1.5.4') }
    it { expect(chef_run).to enable_service('haproxy') }

    it 'should create template "/etc/haproxy/haproxy.cfg"' do
      expect(chef_run).to create_template('/etc/haproxy/haproxy.cfg').with(
        mode: '0644',
        source: 'proxy.erb',
        variables: {
          api_servers: nil,
          etcd_client_port: '2379',
          kubernetes_api_port: '8080',
          kubernetes_secure_api_port: '8443'
        }
      )
      resource = chef_run.template('/etc/haproxy/haproxy.cfg')
      expect(resource).to notify('service[haproxy]').to(:restart).immediately
    end
  end
end
