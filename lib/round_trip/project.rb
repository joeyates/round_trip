require 'active_record'

class RoundTrip::Project < ActiveRecord::Base
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

