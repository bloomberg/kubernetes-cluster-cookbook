#!/usr/bin/env rake

require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'

namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef)
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = 'test/spec/**{,/*/**}/*_spec.rb'
end

desc 'Run style & unit tests on Travis'
task travis: %w(style unit)

# Default
desc 'Run style, unit, and Vagrant-based integration tests'
task default: %w(style unit vagrant)
