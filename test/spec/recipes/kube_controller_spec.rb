require 'spec_helper'

describe_recipe 'kubernetes-cluster::kube-controller' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run).to touch_file('/var/log/kube-controller-manager.log') }

    it 'should create template "/etc/kubernetes/inactive-manifests/controller-manager.yaml"' do
      expect(chef_run).to create_template('/etc/kubernetes/inactive-manifests/controller-manager.yaml').with(
        mode: '0640',
        source: 'kube-controller-manager.erb',
        variables: {
          controller_manager_image: 'gcr.io/google_containers/kube-controller-manager:fda24638d51a48baa13c35337fcd4793',
          etcd_cert_dir: '/etc/kubernetes/secrets',
          kubernetes_api_port: '8080'
        }
      )
    end
  end
end
