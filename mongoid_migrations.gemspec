# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_migrations/version'

Gem::Specification.new do |gem|
  gem.name          = "mongoid_migrations"
  gem.version       = MongoidMigrations::VERSION
  gem.authors       = ["Varun Nidhi"]
  gem.description   = %q{migrations for mongo}
  gem.summary       = %q{migrations for mongo}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'mongoid', '> 3.0'
  gem.add_runtime_dependency 'rake'

  gem.add_development_dependency 'fakefs'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'magic_encoding'
  gem.add_development_dependency 'ci_reporter'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'fuubar'
end
