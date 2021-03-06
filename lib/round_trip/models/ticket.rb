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
  redmine_tracker_id         integer
  redmine_status_id          integer
  redmine_updated_on         datetime  
  redmine_trello_id          integer
  trello_id                  string    
  trello_board_id            string    
  trello_list_id             string    
  trello_name                string    
  trello_description         text
  trello_last_activity_date  datetime  
  trello_url                 string    
  trello_closed              boolean   
  trello_redmine_id          integer
=end

    def self.at
      arel_table
    end

    scope :for_project,           ->(project_id) { where(project_id: project_id) }
    scope :for_redmine_project,   ->(redmine_project_id) { where(:redmine_project_id => redmine_project_id) }
    scope :for_trello_board,      ->(trello_board_id) { where(:trello_board_id => trello_board_id) }
    scope :united,                -> { where(at[:redmine_id].not_eq(nil).and(at[:trello_id].not_eq(nil))) }
    scope :not_united,            -> { where(at[:redmine_id].eq(nil).or(at[:trello_id].eq(nil))) }
    scope :without_redmine,       -> { where(at[:redmine_id].eq(nil)) }
    scope :without_trello,        -> { where(at[:trello_id].eq(nil)) }
    scope :redmine_has_trello_id, -> { where(at[:redmine_trello_id].not_eq(nil)) }
    scope :trello_has_redmine_id, -> { where(at[:trello_redmine_id].not_eq(nil)) }
    scope :redmine_newer,         -> { united.where(at[:redmine_updated_on].gt(at[:trello_last_activity_date])) }
    scope :trello_newer,          -> { united.where(at[:trello_last_activity_date].gt(at[:redmine_updated_on])) }

    def self.redmine_subject_with_matching_trello_name(project)
      query = <<-EOT
      SELECT t1.*
      FROM tickets t1
        INNER JOIN tickets t2
        ON t1.redmine_subject = t2.trello_name
      WHERE
        t1.project_id = #{project.id} and t2.project_id = #{project.id}
        AND t1.trello_name IS NULL
        AND t2.redmine_subject IS NULL
      EOT
      find_by_sql(query)
    end

    def self.create_from_redmine_resource(project, resource)
      attributes = {
        :project_id          => project.id,
        :redmine_id          => resource.id,
        :redmine_project_id  => resource.project.id,
        :redmine_updated_on  => resource.updated_on,
        :redmine_subject     => resource.subject,
        :redmine_description => resource.description,
        :redmine_tracker_id  => resource.tracker.id,
        :redmine_status_id   => resource.status.id,
      }
      m = resource.description.match(/^\#\# Trello card id: (\w+) \#\#$/)
      if m
        attributes[:redmine_trello_id] = m[1]
      end
      create!(attributes)
    end

    def self.create_from_trello_card(project, card)
      attributes = {
        :project_id                => project.id,
        :trello_id                 => card.id,
        :trello_board_id           => card.board_id,
        :trello_list_id            => card.list_id,
        :trello_name               => card.name,
        :trello_description        => card.description,
        :trello_last_activity_date => card.last_activity_date,
        :trello_url                => card.url,
        :trello_closed             => card.closed,
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

    def self.check_repeated_redmine_subjects(redmine_project_id)
      repeated_subjects = for_redmine_project(redmine_project_id).group('redmine_subject').having('count() > 1').count
      return if repeated_subjects.keys.size == 0

      errors = repeated_subjects.map do |redmine_subject, count|
        "#{count} Redmine issues found with the same subject: #{redmine_subject}"
      end.join("\n")

      raise errors
    end

    def self.check_repeated_trello_names(trello_board_id)
      repeated_subjects = for_trello_board(trello_board_id).group('trello_name').having('count() > 1').count
      return if repeated_subjects.keys.size == 0

      errors = repeated_subjects.map do |trello_name, count|
        "#{count} Trello cards found with the same name: #{trello_name}"
      end.join("\n")

      raise errors
    end

    def merge_redmine(redmine_ticket)
      raise ArgumentError.new("Projects do not match") if project_id != redmine_ticket.project_id

      copy_redmine_fields(redmine_ticket)

      self.redmine_trello_id = self.trello_id

      redmine_ticket.destroy
      save!
    end

    def merge_trello(trello_ticket)
      raise ArgumentError.new("Projects do not match") if project_id != trello_ticket.project_id

      copy_trello_fields(trello_ticket)

      self.trello_redmine_id = self.redmine_id

      trello_ticket.destroy
      save!
    end

    private

    def copy_redmine_fields(from)
      self.redmine_id          = from.redmine_id
      self.trello_redmine_id   = from.redmine_id
      self.redmine_project_id  = from.redmine_project_id
      self.redmine_subject     = from.redmine_subject
      self.redmine_description = from.redmine_description
      self.redmine_tracker_id  = from.redmine_tracker_id 
      self.redmine_status_id   = from.redmine_status_id 
      self.redmine_updated_on  = from.redmine_updated_on
    end

    def copy_trello_fields(from)
      self.trello_id                  = from.trello_id
      self.redmine_trello_id          = from.trello_id
      self.trello_board_id            = from.trello_board_id
      self.trello_list_id             = from.trello_list_id
      self.trello_name                = from.trello_name
      self.trello_description         = from.trello_description
      self.trello_last_activity_date  = from.trello_last_activity_date
      self.trello_url                 = from.trello_url
      self.trello_closed              = from.trello_closed
    end
  end
end

