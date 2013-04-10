# -*- encoding : utf-8 -*-
class RenameColumn < MongoidMigrations::Migration
  def self.migration_tasks
    [:rename_name_to_full_name]
  end

  def self.rename_name_to_full_name 
    session_for :batman do |collections|
      test_model_collection = collections[:test_models]
      3.times { |i| test_model_collection.insert({name: "test-#{i}"}) }
      test_model_collection.find("name" => {'$exists' => true}).update_all({"$rename" => {"name" => "full_name"}})
    end

    session_for :superman do |collections|
      hulk_collection = collections[:hulks]

      3.times { |i| hulk_collection.insert({state: "enlarged-#{i}"}) }

      hulk_collection.find({'state' => /enlarged.*/i}).select({_id: 1, state: 1}).each do |doc|
        doc["state"] = doc["state"].sub("enlarged", "expanded")
        hulk_collection.find({"_id" => doc["_id"]}).update(doc)
      end
    end
  end

  def self.rollback_rename_name_to_full_name
    session_for :batman do |collections|
      test_model_collection = collections[:test_models]
      test_model_collection.find("full_name" => {'$exists' => true}).update_all({"$rename" => {"full_name" => "name"}})
    end

    session_for :superman do |collections|
      hulk_collection = collections[:hulks]
       hulk_collection.find({'state' => /expanded.*/i}).each do |doc| 
        doc["state"] = doc["state"].sub("expanded", "enlarged")
        hulk_collection.find({"_id" => doc["_id"]}).update(doc)
       end
    end
  end
end
