# -*- encoding : utf-8 -*-

class DataMigration
  include Mongoid::Document
  field :version

  def self.all_versions
    self.all.map(&:version).map(&:to_i).sort
  end
end
