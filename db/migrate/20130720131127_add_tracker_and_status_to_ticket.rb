class AddTrackerAndStatusToTicket  < ActiveRecord::Migration
  def self.up
    change_table :tickets do |t|
      t.integer :redmine_tracker_id
      t.integer :redmine_status_id
    end
  end

  def self.down
    change_table :tickets do |t|
      t.remove :redmine_tracker_id
      t.remove :redmine_status_id
    end
  end
end

