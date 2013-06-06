class AddProjectIdToTicket < ActiveRecord::Migration
  def self.up
    change_table :round_trip_tickets do |t|
      t.references :project
    end
  end

  def self.down
    change_table :round_trip_tickets do |t|
      t.remove :project_id
    end
  end
end

