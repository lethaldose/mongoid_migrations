# -*- encoding : utf-8 -*-
class TestModel
  include Mongoid::Document
  include Mongoid::Validations
  include Mongoid::Timestamps

  field :full_name, type: String
end
