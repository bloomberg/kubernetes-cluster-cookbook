require 'ci/reporter/rake/rspec'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'foodcritic'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'test/spec/**/*_spec.rb'
end
FoodCritic::Rake::LintTask.new do |t|
  t.options = { fail_tags: ['any'] }
end

task(:default).clear
desc 'Run linter and tests'
task default: %w(rubocop foodcritic ci:setup:rspec spec)
