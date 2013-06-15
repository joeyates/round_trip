require 'active_record'

module RoundTrip
  class ProjectValidator < ActiveModel::Validator
    def validate(record)
      if record.redmine_account
        if record.redmine_account.type != 'RoundTrip::RedmineAccount'
          record.errors.add(:redmine_account, 'must be a RoundTrip::RedmineAccount')
        end
      end
      if record.trello_account
        if record.trello_account.type != 'RoundTrip::TrelloAccount'
          record.errors.add(:trello_account, 'must be a RoundTrip::TrelloAccount')
        end
      end
    end
  end

  class Project < ActiveRecord::Base
    include ActiveRecord::Validations

    validates_presence_of :name
    validates_uniqueness_of :name
    validates_with ProjectValidator

    belongs_to :redmine_account, class_name: 'Account', foreign_key: 'redmine_account_id'
    belongs_to :trello_account, class_name: 'Account', foreign_key: 'trello_account_id'
  end
end

