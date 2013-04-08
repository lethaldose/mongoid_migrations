# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MongoidMigrations::Migration do
  context "skip" do
    it "should not skip migration when migration doesnt define toggled? value" do
      class TestMigration < MongoidMigrations::Migration
      end
      TestMigration.should_not be_skip
    end

    it "should skip migration when migration define toggled? value as false" do
      class AnotherTestMigration < MongoidMigrations::Migration
        def self.toggled?
          false
        end
      end
      AnotherTestMigration.should be_skip
    end

    it "should skip migration when migration define toggled? value as false" do
      class AnotherTestMigration < MongoidMigrations::Migration
        def self.toggled?
          true
        end
      end
      AnotherTestMigration.should_not be_skip
    end
  end
end
