class AddColumnSourceDestinationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :origin, :string
    add_column :users, :destination, :string
  end

  def self.down
    remove_column :users, :origin
    remove_column :users, :destination
  end
end
