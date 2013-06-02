require 'active_record'

class RoundTrip::Ticket < ActiveRecord::Base
  self.table_name = 'round_trip_tickets'

=begin
      t.integer   :redmine_id
      t.integer   :redmine_project_id
      t.string    :redmine_subject
      t.text      :redmine_description
      t.datetime  :redmine_updated_on
      t.string    :trello_id
      t.string    :trello_board_id
      t.string    :trello_list_id
      t.string    :trello_name
      t.text      :trello_desc
      t.datetime  :trello_last_activity_date
      t.string    :trello_url
      t.boolean   :trello_closed
=end

  def self.at
    arel_table
  end

  scope :trello_only, where(:redmine_id => nil)
  scope :redmine_only, where(:trello_id => nil)
  scope :not_united, where(at[:redmine_id].eq(nil).or(at[:trello_id].eq(nil)))
  scope :trello_has_redmine_id, where(at[:trello_redmine_id].not_eq(nil))
  scope :redmine_has_trello_id, where(at[:redmine_trello_id].not_eq(nil))

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
end

