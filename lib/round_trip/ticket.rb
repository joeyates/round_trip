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
      t.string    :trello_name
      t.text      :trello_desc
      t.datetime  :trello_last_activity_date
      t.string    :trello_list_id
      t.string    :trello_url
      t.boolean   :trello_closed
=end

  def self.create_from_redmine_resource(resource)
    create!(
      :redmine_id          => resource.id,
      :redmine_project_id  => resource.project.id,
      :redmine_updated_on  => resource.updated_on,
      :redmine_subject     => resource.subject,
      :redmine_description => resource.description,
    )
  end
end

