require 'active_record'

module RoundTrip
  class Ticket < ActiveRecord::Base
    belongs_to :project

    validates :project, presence: true

=begin
  project_id                 integer
  redmine_id                 integer   
  redmine_project_id         integer   
  redmine_subject            string    
  redmine_description        text      
  redmine_updated_on         datetime  
  redmine_trello_id          integer
  trello_id                  string    
  trello_board_id            string    
  trello_list_id             string    
  trello_name                string    
  trello_desc                text      
  trello_last_activity_date  datetime  
  trello_url                 string    
  trello_closed              boolean   
  trello_redmine_id          integer
=end

    def self.at
      arel_table
    end

    scope :trello_only, where(:redmine_id => nil)
    scope :redmine_only, where(:trello_id => nil)
    scope :united, where(at[:redmine_id].not_eq(nil).and(at[:trello_id].not_eq(nil)))
    scope :not_united, where(at[:redmine_id].eq(nil).or(at[:trello_id].eq(nil)))
    scope :trello_has_redmine_id, where(at[:trello_redmine_id].not_eq(nil))
    scope :redmine_has_trello_id, where(at[:redmine_trello_id].not_eq(nil))
    scope :for_project, ->(project_id) { where(project_id: project_id) }
    scope :for_redmine_project, ->(redmine_project_id) { where(:redmine_project_id => redmine_project_id) }
    scope :for_trello_board, ->(trello_board_id) { where(:trello_board_id => trello_board_id) }
    scope :trello_newer, ->(project_id) { united.for_project(project_id).where(at[:trello_last_activity_date].gt(at[:redmine_updated_on])) }

    def self.create_from_redmine_resource(resource)
      attributes = {
        :redmine_id          => resource.id,
        :redmine_project_id  => resource.project.id,
        :redmine_updated_on  => resource.updated_on,
        :redmine_subject     => resource.subject,
        :redmine_description => resource.description,
      }
      m = resource.description.match(/^\#\# Trello card id: (\w+) \#\#$/)
      if m
        attributes[:redmine_trello_id] = m[1]
      end
      create!(attributes)
    end

    def self.create_from_trello_card(card)
      attributes = {
        :trello_id => card.id,
        :trello_board_id => card.board_id,
        :trello_list_id => card.list_id,
        :trello_name => card.name,
        :trello_desc => card.description,
        :trello_last_activity_date => card.last_activity_date,
        :trello_url => card.url,
        :trello_closed => card.closed,
      }
      m = card.description.match(/^\#\# Redmine issue id: (\d+) \#\#$/)
      if m
        attributes[:trello_redmine_id] = m[1].to_i
      end
      create!(attributes)
    end

    def self.check_repeated_redmine_ids(redmine_project_id)
      too_many_redmine = trello_has_redmine_id.for_redmine_project(redmine_project_id).group('trello_redmine_id').having('count() > 1').count
      return if too_many_redmine.keys.size == 0

      errors = too_many_redmine.map do |redmine_id, count|
        "#{count} Trello cards found with the same Redmine issue id: #{redmine_id}"
      end.join("\n")

      raise errors
    end

    def self.check_repeated_trello_ids(trello_board_id)
      too_many_trello = redmine_has_trello_id.for_trello_board(trello_board_id).group('redmine_trello_id').having('count() > 1').count
      return if too_many_trello.keys.size == 0

      errors = too_many_trello.map do |trello_id, count|
        "#{count} Redmine issues found with the same Trello card id: #{trello_id}"
      end.join("\n")

      raise errors
    end

    def self.copy_redmine_fields(from, to)
      to.redmine_id          = from.redmine_id
      to.redmine_project_id  = from.redmine_project_id
      to.redmine_subject     = from.redmine_subject
      to.redmine_description = from.redmine_description
      to.redmine_updated_on  = from.redmine_updated_on
    end

    def merge_redmine(redmine_ticket)
      self.class.copy_redmine_fields(redmine_ticket, self)

      self.redmine_trello_id = self.trello_id

      redmine_ticket.destroy
      save!
    end
  end
end

