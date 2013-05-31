require 'active_record'

class RoundTrip::Project < ActiveRecord::Base
  CONFIGURATION = [
    [:redmine, [:url, :key, :project_id]],
    [:trello,  [:key, :token, :board_id]],
  ]
  include ActiveRecord::Validations

  self.table_name = 'round_trip_projects'

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

