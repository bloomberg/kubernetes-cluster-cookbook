source 'http://artifactory.dev.bloomberg.com:8080/artifactory/api/gems/ruby-repos/'

gem 'berkshelf'
gem 'chef-sugar'
gem 'chef-vault'
gem 'rake'

group :development do
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'guard-foodcritic'
end

group :test, :integration do
  gem 'chefspec'
  gem 'ci_reporter_rspec'
  gem 'foodcritic'
  gem 'kitchen-openstack'
  gem 'rspec', '~> 3.1'
  gem 'rubocop'
  gem 'serverspec'
  gem 'test-kitchen'
end
