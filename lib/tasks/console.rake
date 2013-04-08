desc 'opens up a irb console'
task :console do
  Bundler.require
  require 'pry'

  $: << File.join(File.dirname(__FILE__), '..')

  require 'mongoid_migrations'

  Pry.start
end
