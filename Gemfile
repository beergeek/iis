source "https://rubygems.org"

group :unit_tests do
  gem "rake"
  gem "rspec"
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "puppetlabs_spec_helper"
  gem "metadata-json-lint"
end

group :system_tests do
  gem 'beaker-rspec'
  gem 'beaker'
  gem 'vagrant-wrapper'
end

gem "puppet", ENV['PUPPET_VERSION'] || '~> 4.4.0'
