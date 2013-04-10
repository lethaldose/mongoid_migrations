# -*- encoding : utf-8 -*-
class RenameColumn < MongoidMigrations::Migration

  #0. Do you really need a migration?
  #1. select only columns you need
  #2. no_timeout so long running queries dont timeout
  #3. dont replace old value with new value unless you can recreate old values.
  #4. better to rename old column (_old) and add a new column with new value. 
  #5. mongo update queries are faster.
  #6. http://docs.mongodb.org/manual/tutorial/optimize-query-performance-with-indexes-and-projections/

  def self.migration_tasks
    [:rename_name_to_full_name, :modify_column_value]
  end

  def self.rename_name_to_full_name 
    session_for :batman do |collections|
      test_model_collection = collections[:test_models]
      3.times { |i| test_model_collection.insert({name: "test-#{i}"}) }
      test_model_collection.find("name" => {'$exists' => true}).update_all({"$rename" => {"name" => "full_name"}})
    end
  end

  def self.modify_column_value
    session_for :superman do |collections|
      hulk_collection = collections[:hulks]

      3.times { |i| hulk_collection.insert({state: "enlarged-#{i}"}) }

      hulk_collection.find({'state' => /enlarged.*/i}).no_timeout.select({_id: 1, state: 1}).each do |doc|
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
  end

  def self.rollback_modify_column_value
    session_for :superman do |collections|
      hulk_collection = collections[:hulks]
      hulk_collection.find({'state' => /expanded.*/i}).each do |doc| 
        doc["state"] = doc["state"].sub("expanded", "enlarged")
        hulk_collection.find({"_id" => doc["_id"]}).update(doc)
      end
    end
  end

end
