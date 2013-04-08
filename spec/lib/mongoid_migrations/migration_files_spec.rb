# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MongoidMigrations::MigrationFiles do
  include FakeFS::SpecHelpers
  context "list" do
    it "should raise an error if multiple files exist with same version" do
      FileUtils.mkdir_p("/path/to/migrations")
      FileUtils.touch("/path/to/migrations/1_test_1.rb")
      FileUtils.touch("/path/to/migrations/1_test_2.rb")

      expect { MongoidMigrations::MigrationFiles.new("/path/to/migrations").list }.to raise_error(MongoidMigrations::DuplicateMigrationVersionError)
   end

    it "should raise an error if multiple files exist with same name" do
      FileUtils.mkdir_p("/path/to/migrations")
      FileUtils.touch("/path/to/migrations/1_test.rb")
      FileUtils.touch("/path/to/migrations/2_test.rb")

      expect { MongoidMigrations::MigrationFiles.new("/path/to/migrations").list }.to raise_error(MongoidMigrations::DuplicateMigrationNameError)
    end

    it "should return a list of Migration Proxy's" do
      FileUtils.mkdir_p("/path/to/migrations")
      FileUtils.touch("/path/to/migrations/1_test_foo.rb")
      FileUtils.touch("/path/to/migrations/2_test_bar.rb")

      migrations = MongoidMigrations::MigrationFiles.new("/path/to/migrations").list
      migrations.should have(2).things
      migrations.map(&:class).uniq.should == [MongoidMigrations::MigrationProxy]

      migration_1, migration_2 = migrations

      migration_1.name.should == "TestFoo"
      migration_1.version.should == 1
      migration_2.name.should == "TestBar"
      migration_2.version.should == 2
    end

    it "should return a list of migrations sorted by version" do
      FileUtils.mkdir_p("/path/to/migrations")
      FileUtils.touch("/path/to/migrations/331_test_foo.rb")
      FileUtils.touch("/path/to/migrations/201_test_bar.rb")
      FileUtils.touch("/path/to/migrations/101_test_baz.rb")
      FileUtils.touch("/path/to/migrations/213_test_qux.rb")

      migrations = MongoidMigrations::MigrationFiles.new("/path/to/migrations").list
      migrations.map(&:version).should == [101, 201, 213, 331]
    end
  end
end
