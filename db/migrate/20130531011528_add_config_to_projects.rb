class AddConfigToProjects < ActiveRecord::Migration
  def self.up
    change_table :round_trip_projects do |t|
      t.text :config
    end
  end

  def self.down
    change_table :round_trip_projects do |t|
      t.remove :config
    end
  end
end

