#!/usr/bin/env rake
require 'rake'
require 'rspec/core/rake_task'

cfg_dir = File.expand_path File.dirname(__FILE__)
ENV['BERKSHELF_PATH'] = cfg_dir + '/.berkshelf'
cook_dir = cfg_dir + '/.cooks'

# Checks if we are inside Travis CI.
#
# @return [Boolean] whether we are inside Travis CI.
# @example
#   travis? #=> false
def travis?
  ENV['TRAVIS'] == 'true'
end

task default: 'test:quick'
namespace :test do
  desc 'Run all of the quick tests.'
  task :quick do
    Rake::Task['style'].invoke
    Rake::Task['unit'].invoke
  end

  desc 'Run _all_ the tests. Go get a coffee.'
  task :complete do
    Rake::Task['test:quick'].invoke
    Rake::Task['integration'].invoke
  end

  desc 'Run CI tests'
  task :ci do
    Rake::Task['test:complete'].invoke
  end
end

namespace :style do
  begin
    require 'foodcritic/rake_task'
    require 'foodcritic'
    task default: [:foodcritic]
    FoodCritic::Rake::LintTask.new do |t|
      t.options = { tags: ['~FC003'], fail_tags: ['any'] }
    end
  rescue LoadError
    warn 'Foodcritic Is missing ZOMG'
  end

  begin
    require 'rubocop/rake_task'
    RuboCop::RakeTask.new do |task|
      task.fail_on_error = true
      task.options = %w(-D -a)
    end
  rescue LoadError
    warn 'Rubocop gem not installed, now the code will look like crap!'
  end
end

desc 'Run styling tests'
task style: ['style:foodcritic', 'style:rubocop']

namespace :unit do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = Dir.glob('test/spec/**/*_spec.rb')
    t.rspec_opts = '--color -f d --fail-fast'
    system "rm -rf  #{cook_dir}"
    system "berks vendor #{cook_dir}"
  end
end

desc 'Run unit tests'
task unit: ['unit:spec']

namespace :integration do
  def run_kitchen
    sh "kitchen test #{ENV['KITCHEN_ARGS']} #{ENV['KITCHEN_REGEXP']}"
  end

  desc 'Run Test Kitchen integration tests using vagrant'
  task :vagrant do
    ENV.delete('KITCHEN_LOCAL_YAML')
    run_kitchen
  end

  desc 'Run Test Kitchen integration tests using docker'
  task :docker do
    ENV['KITCHEN_LOCAL_YAML'] = '.kitchen.docker.yml'
    run_kitchen
  end
end

desc 'Run Test Kitchen integration tests'
task integration: travis? ? %w(integration:docker) : %w(integration:vagrant)

namespace :release do
  task :update_metadata do
  end

  task :tag_release do
  end
end
