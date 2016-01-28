require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'
require 'chef/sugar'
require 'chef-vault'

RSpec.configure do |config|
  # Set default platform family and version for ChefSpec.
  config.platform = 'redhat'
  config.version = '7.1'

  config.color = true
  config.alias_example_group_to :describe_recipe, type: :recipe

  Kernel.srand config.seed
  config.order = :random

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end

def chef_vault_mock(bag, item, value)
  allow(ChefVault::Item).to receive(:load).with(bag, item).and_return(value)
end

def chef_vault_mock_for_environment(bag, item, environment, value)
  chef_vault_mock(bag, item, environment, environment => value)
end

RSpec.shared_context 'recipe tests', type: :recipe do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
end
