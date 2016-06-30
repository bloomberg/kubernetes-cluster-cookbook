require 'spec_helper'

describe_recipe 'kubernetes-cluster::master' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run.node.tags).to eq(['kubernetes.master']) }
    it { expect(chef_run).to install_yum_package('cockpit >= 0.71') }
    it { expect(chef_run).to install_yum_package('etcd >= 2.0.0') }
    it { expect(chef_run).to install_yum_package('kubernetes-master = 1.0.3') }

    it 'should include recipe kubernetes-cluster::default' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::default')
      chef_run
    end

    it 'should create group "kube-services"' do
      expect(chef_run).to modify_group('kube-services').with(
        members: %w(etcd kube)
      )
    end

    it 'should create directory "/etc/kubernetes/inactive-manifests"' do
      expect(chef_run).to create_directory('/etc/kubernetes/inactive-manifests').with(
        owner: 'root',
        group: 'kube-services',
        mode: '0770'
      )
    end

    it 'should create directory "/etc/kubernetes/manifests"' do
      expect(chef_run).to create_directory('/etc/kubernetes/manifests').with(
        owner: 'root',
        group: 'kube-services',
        mode: '0770'
      )
    end

    it { expect(chef_run).to_not create_file('/etc/kubernetes/secrets/client.ca.crt') }
    it { expect(chef_run).to_not create_file('/etc/kubernetes/secrets/client.srv.crt') }
    it { expect(chef_run).to_not create_file('/etc/kubernetes/secrets/client.srv.key') }
    it { expect(chef_run).to_not create_file('/etc/kubernetes/secrets/peer.ca.crt') }
    it { expect(chef_run).to_not create_file('/etc/kubernetes/secrets/peer.srv.crt') }
    it { expect(chef_run).to_not create_file('/etc/kubernetes/secrets/peer.srv.key') }

    it 'should include recipe kubernetes-cluster::etcd' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::etcd')
      chef_run
    end

    it 'should include recipe kubernetes-cluster::kubernetes' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::kubernetes')
      chef_run
    end

    it 'should include recipe kubernetes-cluster::kube-apiserver' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::kube-apiserver')
      chef_run
    end

    it 'should include recipe kubernetes-cluster::network' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::network')
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

    it 'should include recipe kubernetes-cluster::kube-controller' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::kube-controller')
      chef_run
    end

    it 'should include recipe kubernetes-cluster::kube-scheduler' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::kube-scheduler')
      chef_run
    end

    it 'should include recipe kubernetes-cluster::podmaster' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('kubernetes-cluster::podmaster')
      chef_run
    end
  end

  context 'with node[\'kubernetes\'][\'secure\'][\'enabled\'] = true' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['kubernetes']['secure']['enabled'] = 'true'
      end.converge(described_recipe)
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
      expect(chef_run).to create_file('/etc/kubernetes/secrets/client.srv.key').with(
        contents: nil,
        owner: 'root',
        group: 'kube-services',
        mode: '0770',
        sensitive: true
      )
    end

    it 'should create file "/etc/kubernetes/secrets/peer.ca.crt"' do
      expect(chef_run).to create_file('/etc/kubernetes/secrets/peer.ca.crt').with(
        contents: nil,
        owner: 'root',
        group: 'kube-services',
        mode: '0770',
        sensitive: true
      )
    end

    it 'should create file "/etc/kubernetes/secrets/peer.srv.crt"' do
      expect(chef_run).to create_file('/etc/kubernetes/secrets/peer.srv.crt').with(
        contents: nil,
        owner: 'root',
        group: 'kube-services',
        mode: '0770',
        sensitive: true
      )
    end

    it 'should create file "/etc/kubernetes/secrets/peer.srv.key"' do
      expect(chef_run).to create_file('/etc/kubernetes/secrets/peer.srv.key').with(
        contents: nil,
        owner: 'root',
        group: 'kube-services',
        mode: '0770',
        sensitive: true
      )
    end
  end
end
