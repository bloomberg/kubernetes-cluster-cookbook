require 'spec_helper'

describe_recipe 'kubernetes-cluster::default' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it { expect(chef_run).to disable_service('firewalld') }
    it { expect(chef_run).to stop_service('firewalld') }
    it { expect(chef_run).to install_yum_package('flannel >= 0.2.0') }
  end
end
