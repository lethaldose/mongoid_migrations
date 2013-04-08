# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MongoidMigrations::Migrator do
  context "migrate" do
    it "should migrate versions not already migrated" do
        migrations = [ stub(:name => "Test1", :process => true, :skip? => false, :version => 100),
                       stub(:name => "Test2", :process => true, :skip? => false, :version => 101),
                       stub(:name => "Test3", :process => true, :skip? => false, :version => 102),
                       stub(:name => "Test3", :process => true, :skip? => false, :version => 103)]
        existing_migrations = [ 100 ]
        DataMigration.stub!(:all_versions).and_return(existing_migrations)
        MongoidMigrations::MigrationFiles.any_instance.stub(:list).and_return(migrations)

        DataMigration.should_receive(:create).with(:version => "101");
        DataMigration.should_receive(:create).with(:version => "102");
        DataMigration.should_receive(:create).with(:version => "103");
        MongoidMigrations::Migrator.migrate("test/path")
    end

    context "skip" do
      it "should skip migration when migration is marked to be skipped" do
        migrations = [ stub(:name => "Test1", :process => true, :skip? => false, :version => 100),
                       stub(:name => "Test2", :process => true, :skip? => false, :version => 101),
                       stub(:name => "Test3", :process => true, :skip? => true, :version => 102),
                       stub(:name => "Test3", :process => true, :skip? => false, :version => 103)]
        existing_migrations = [ 100, 101 ]
        DataMigration.stub!(:all_versions).and_return(existing_migrations)
        MongoidMigrations::MigrationFiles.any_instance.stub(:list).and_return(migrations)

        DataMigration.should_receive(:create).with(:version => "103");

        MongoidMigrations::Migrator.migrate("test/path")
      end
    end
  end
end
