require 'spec_helper'

describe_recipe 'kubernetes-cluster::minion' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run.node.tags).to eq(['kubernetes.minion']) }
    it { expect(chef_run.node['kubelet']['register']).to eq('true') }

    it 'should include recipe kubernetes-cluster::default' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::default')
      chef_run
    end

    it 'should include recipe kubernetes-cluster::proxy' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::proxy')
      chef_run
    end

    it { expect(chef_run).to_not modify_group('kube-services') }
    it { expect(chef_run).to_not create_file('/etc/kubernetes/secrets/client.ca.crt') }
    it { expect(chef_run).to_not create_file('/etc/kubernetes/secrets/client.srv.crt') }
    it { expect(chef_run).to_not create_file('/etc/kubernetes/secrets/client.srv.bundle.crt') }
    it { expect(chef_run).to_not create_file('/etc/kubernetes/secrets/client.srv.key') }

    it 'should include recipe kubernetes-cluster::kubernetes' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::kubernetes')
      chef_run
    end

    it 'should include recipe kubernetes-cluster::kube-proxy' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::kube-proxy')
      chef_run
    end

    it 'should include recipe kubernetes-cluster::docker' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::docker')
      chef_run
    end

    it 'should include recipe kubernetes-cluster::flanneld' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::flanneld')
      chef_run
    end

    it 'should include recipe kubernetes-cluster::kubelet' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::kubelet')
      chef_run
    end
  end

  context 'with node[\'kubernetes\'][\'secure\'][\'enabled\'] = true' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['kubernetes']['secure']['enabled'] = 'true'
      end.converge(described_recipe)
    end

    it 'should create group "kube-services"' do
      expect(chef_run).to modify_group('kube-services').with(
        members: %w(kube)
      )
    end

    it 'should create file "/etc/kubernetes/secrets/client.ca.crt"' do
      expect(chef_run).to create_file('/etc/kubernetes/secrets/client.ca.crt').with(
        contents: nil,
        owner: 'root',
        group: 'kube-services',
        mode: '0770',
        sensitive: true
      )
    end

    it 'should create file "/etc/kubernetes/secrets/client.srv.crt"' do
      expect(chef_run).to create_file('/etc/kubernetes/secrets/client.srv.crt').with(
        contents: nil,
        owner: 'root',
        group: 'kube-services',
        mode: '0770',
        sensitive: true
      )
    end

    it 'should create file "/etc/kubernetes/secrets/client.srv.key"' do
      expect(chef_run).to create_file('/etc/kubernetes/secrets/client.srv.bundle.crt').with(
        contents: nil,
        owner: 'root',
        group: 'kube-services',
        mode: '0770',
        sensitive: true
      )
    end

    it 'should create file "/etc/kubernetes/secrets/client.srv.key"' do
      expect(chef_run).to create_file('/etc/kubernetes/secrets/client.srv.key').with(
        contents: nil,
        owner: 'root',
        group: 'kube-services',
        mode: '0770',
        sensitive: true
      )
    end
  end
end
