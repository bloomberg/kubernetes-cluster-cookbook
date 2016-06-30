require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

at_exit { ChefSpec::Coverage.report! }

module KubernetesCookbook
  module SpecHelper
    # Allows testing recipes in isolation
    def global_stubs_include_recipe
      # Don't worry about external cookbook dependencies
      allow_any_instance_of(Chef::Cookbook::Metadata).to receive(:depends)

      # Test each recipe in isolation, regardless of includes
      @included_recipes = []

      allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe?).and_return(false)
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe) do |i|
        allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe?).and_return(true)
        @included_recipes << i
      end
      allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe).and_return(@included_recipes)
    end
  end
end

RSpec.configure do |config|
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

  config.include KubernetesCookbook::SpecHelper
end
