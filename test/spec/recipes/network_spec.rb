require 'spec_helper'
require_relative '../../../libraries/helpers'

describe_recipe 'kubernetes-cluster::network' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run).to_not run_execute('getnetwork') }
    it { expect(chef_run).to_not run_execute('setnetwork') }

    it 'should create template "/etc/sysconfig/flannel-network"' do
      expect(chef_run).to create_template('/etc/sysconfig/flannel-network').with(
        mode: '0640',
        source: 'flannel-network.erb',
        variables: {
          flannel_netlength:'24',
          flannel_network: '1.80.0.0/16'
        }
      )
      resource = chef_run.template('/etc/sysconfig/flannel-network')
      expect(resource).to notify('execute[setnetwork]').to(:run).immediately
    end
  end
end
