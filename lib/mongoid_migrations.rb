# -*- encoding : utf-8 -*-
require 'mongoid'
require 'active_support'
require 'rake'
require "mongoid_migrations/version"
require "mongoid_migrations/data_migration"
require "mongoid_migrations/exceptions"
require "mongoid_migrations/migration_proxy"
require "mongoid_migrations/migration_files"
require "mongoid_migrations/migration"
require "mongoid_migrations/migrator"

load 'mongoid_migrations/tasks/migrate.rake'
