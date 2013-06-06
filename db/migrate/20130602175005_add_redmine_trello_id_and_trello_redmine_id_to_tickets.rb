class AddRedmineTrelloIdAndTrelloRedmineIdToTickets < ActiveRecord::Migration
  def self.up
    change_table :tickets do |t|
      t.string :redmine_trello_id
      t.string :trello_redmine_id
    end
  end

  def self.down
    change_table :tickets do |t|
      t.remove :redmine_trello_id, :trello_redmine_id
    end
  end
end

