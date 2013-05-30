require 'active_record'

class RoundTrip::Project < ActiveRecord::Base
  include ActiveRecord::Validations

  validates_presence_of :name
end

