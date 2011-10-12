class AddColumnInactiveToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :inactive, :boolean, :default => 0
  end

  def self.down
    remove_column :users, :inactive
  end
end
