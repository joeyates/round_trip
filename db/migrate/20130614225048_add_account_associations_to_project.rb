class AddAccountAssociationsToProject  < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.integer :redmine_account_id
      t.integer :trello_account_id
    end
  end

  def self.down
    change_table :projects do |t|
      t.remove :redmine_account_id
      t.remove :trello_account_id
    end
  end
end

