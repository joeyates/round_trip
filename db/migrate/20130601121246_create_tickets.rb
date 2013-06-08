class CreateTickets  < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer   :redmine_id
      t.integer   :redmine_project_id
      t.string    :redmine_subject
      t.text      :redmine_description
      t.datetime  :redmine_updated_on
      t.string    :trello_id
      t.string    :trello_board_id
      t.string    :trello_name
      t.text      :trello_description
      t.datetime  :trello_last_activity_date
      t.string    :trello_list_id
      t.string    :trello_url
      t.boolean   :trello_closed
    end
  end

  def self.down
    drop_table :tickets
  end
end

