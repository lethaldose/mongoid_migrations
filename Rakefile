require 'bundler'
Bundler.setup

require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'
require 'ci/reporter/rake/rspec'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Dir[File.join(File.dirname(__FILE__), 'lib/tasks/magic_encoding.rake')].each { |rake| load rake }
Dir[File.join(File.dirname(__FILE__), 'lib/tasks/console.rake')].each { |rake| load rake }
Dir[File.join(File.dirname(__FILE__), 'lib/tasks/git_hook.rake')].each { |rake| load rake }

require "bundler/gem_tasks"
