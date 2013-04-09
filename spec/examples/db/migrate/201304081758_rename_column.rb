# -*- encoding : utf-8 -*-
class RenameColumn < MongoidMigrations::Migration
  def self.migration_tasks
    [:rename_name_to_full_name]
  end

  def self.rename_name_to_full_name collections
    3.times { |i| ::TestModel.create({name: "test-#{i}"}) }
    test_model_collection = collections[:test_models]
    test_model_collection.find("name" => {'$exists' => true}).update_all({"$rename" => {"name" => "full_name"}})
  end

  def self.rollback_rename_name_to_full_name collections
    test_model_collection = collections[:test_models]
    test_model_collection.find("full_name" => {'$exists' => true}).update_all({"$rename" => {"full_name" => "name"}})
  end
end
