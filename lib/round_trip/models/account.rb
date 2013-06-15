require 'active_record'

module RoundTrip
  class Account < ActiveRecord::Base
    include ActiveRecord::Validations

    validates_presence_of :name
    validates_inclusion_of :type, in: ['RoundTrip::RedmineAccount', 'RoundTrip::TrelloAccount']

    serialize :config

    after_initialize :set_defaults
    before_create :set_defaults

    def to_s
      name
    end

    private

    def set_defaults
      self.config ||= {}
    end
  end
end

