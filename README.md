# MongoidMigrations

Mongoid migrations for schema changes for any project (e.g. sinatra) using mongoid ORM
Adapted from https://github.com/adacosta/mongoid_rails_migrations

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid_migrations'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_migrations

## Keep in mind

0. Do you really need a migration?
1. Select only columns you need
2. set no_timeout so long running queries dont timeout
3. Dont replace old value with new value unless you can recreate old values.
4. Better to rename old column (_old) and add a new column with new value.
5. mongo update queries are faster. http://docs.mongodb.org/manual/core/update
6. http://docs.mongodb.org/manual/tutorial/optimize-query-performance-with-indexes-and-projections/


