# -*- encoding : utf-8 -*-
class RenameColumn < MongoidMigrations::Migration
  def self.migrate(collections)

    # Data Setup
    3.times { |i| ::TestModel.create({name: "test-#{i}"}) }
    @collections = collections
    @migrations = [{task: :rename_name_to_full_name, executed: false}]

    begin

      #Migration
      @migrations.each do |migration|
        migration[:executed] = true
        self.send(migration[:task])
      end
    rescue Exception => e
      require 'pry'; binding.pry
      #Rollback
      @migrations.each do |migration|
        if (migration[:executed])
          migration[:executed] = false
          self.send("rollback_#{migration[:task]}".to_sym)
        end
      end
    end
  end

  private

  def self.rename_name_to_full_name
    test_model_collection = @collections[:test_models]
    test_model_collection.find("name" => {'$exists' => true}).update_all({"$rename" => {"name" => "full_name"}})
  end

  def self.rollback_rename_name_to_full_name
    test_model_collection = @collections[:test_models]
    test_model_collection.find("full_name" => {'$exists' => true}).update_all({"$rename" => {"full_name" => "name"}})
  end
end
