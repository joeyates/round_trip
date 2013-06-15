require 'active_record'

module RoundTrip
  class Account < ActiveRecord::Base
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

