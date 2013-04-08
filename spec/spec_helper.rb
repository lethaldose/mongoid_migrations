# -*- encoding : utf-8 -*-
require 'bundler/setup'

Bundler.require :default, :test
spec_root = File.expand_path(File.dirname(__FILE__))

$: << spec_root

require 'mongoid'
require 'pry'
require 'fakefs/spec_helpers'

require File.join(File.dirname(__FILE__), '..', 'lib', 'mongoid_migrations')

Dir[File.join(spec_root, "support/*.rb")].each {|f| require f}
