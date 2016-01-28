guard 'foodcritic', cookbook_paths: '.', cli: '-t ~FC023 -t ~FC005', all_on_start: false do
  watch(%r{^(?:recipes|libraries|providers|resources)/.+\.rb$})
  watch('metadata.rb')
end

# More info at https://github.com/guard/guard#readme
guard 'rubocop' do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^providers/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch(%r{^resources/.+\.rb$})
  watch(%r{^libraries/.+\.rb$})
  watch('metadata.rb')
end

guard :rspec, cmd: 'bundle exec rspec', spec_paths: %w(test/spec) do
  watch(%r{^(recipes|libraries|providers|resources)/(.+)\.rb$}) do |m|
    "test/spec/#{m[1]}/#{m[2]}_spec.rb"
  end
  watch(%r{test/spec/.+\.rb$})
  watch('test/spec/spec_helper.rb')      { 'spec/unit' }
end
