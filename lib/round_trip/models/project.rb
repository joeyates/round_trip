require 'active_record'

module RoundTrip
  class Project < ActiveRecord::Base
    CONFIGURATION = [
      :redmine_url, :redmine_key, :redmine_project_id,
      :trello_key, :trello_secret, :trello_token, :trello_board_id,
    ]
    include ActiveRecord::Validations

    validates_presence_of :name

    serialize :config

    after_initialize :set_defaults
    before_create :set_defaults

    private

    def set_defaults
      self.config ||= {}
    end
  end
end

