class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :round_trip_projects do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :round_trip_projects
  end
end

