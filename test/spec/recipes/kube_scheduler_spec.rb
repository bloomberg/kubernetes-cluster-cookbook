require 'spec_helper'

describe_recipe 'kubernetes-cluster::kube-scheduler' do
  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it { expect(chef_run).to touch_file('/var/log/kube-scheduler.log') }

    it 'should create template "/etc/kubernetes/inactive-manifests/scheduler.yaml"' do
      expect(chef_run).to create_template('/etc/kubernetes/inactive-manifests/scheduler.yaml').with(
        mode: '0640',
        source: 'kube-scheduler.erb',
        variables: {
          etcd_cert_dir: '/etc/kubernetes/secrets',
          kube_scheduler_image: 'gcr.io/google_containers/kube-scheduler:34d0b8f8b31e27937327961528739bc9',
          kubernetes_api_port: '8080'
        }
      )
    end
  end
end
