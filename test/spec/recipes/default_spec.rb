require 'spec_helper'

describe_recipe 'blp-containers::default' do
  context 'default' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |_node|
        Chef::Config[:client_key] = '/etc/chef/client.pem'
      end.converge(described_recipe)
    end
  end
end
