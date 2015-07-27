source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'berkshelf', '~> 3.3'
end

group :style do
  gem 'foodcritic'
  gem 'rubocop', '0.32.1'
end

group :unit do
  gem 'chefspec', '~> 4.3.0'
  gem 'ohai', '<= 8.0.0' if RUBY_VERSION < '2'
end

group :doc do
  gem 'knife-cookbook-doc'
end

group :guard do
  gem 'guard'
  gem 'guard-rake'
  gem 'guard-kitchen'
end

group :integration do
  gem 'test-kitchen', '~> 1.4'
end

group :integration_docker do
  gem 'kitchen-docker', '~> 2.1'
end

group :integration_vagrant do
  gem 'vagrant-wrapper', '~> 2.0'
  gem 'kitchen-vagrant', '~> 0.10'
end
