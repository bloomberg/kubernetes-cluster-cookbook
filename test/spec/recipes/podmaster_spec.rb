require 'spec_helper'

describe_recipe 'kubernetes-cluster::podmaster' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should create template "/etc/kubernetes/manifests/podmaster.yaml"' do
      expect(chef_run).to create_template('/etc/kubernetes/manifests/podmaster.yaml').with(
        mode: '0640',
        source: 'podmaster.yaml.erb',
        variables: {
          etcd_client_port: '2379',
          etcd_cert_dir: '/etc/kubernetes/secrets',
          podmaster_image: 'gcr.io/google_containers/podmaster:1.1'
        }
      )
    end
  end
end
