require 'active_record'

class RoundTrip::Project < ActiveRecord::Base
  include ActiveRecord::Validations

  validates_presence_of :name

  serialize :redmine
  serialize :trello

  after_initialize :set_defaults
  before_create :set_defaults

  private

  def set_defaults
    self.redmine ||= {}
    self.trello ||= {}
  end
end

