class AddProjectIdToTicket < ActiveRecord::Migration
  def self.up
    change_table :tickets do |t|
      t.references :project
    end
  end

  def self.down
    change_table :tickets do |t|
      t.remove :project_id
    end
  end
end

