class AddColumnsToRides < ActiveRecord::Migration
  def self.up
    add_column :rides, :payment, :string
    add_column :rides, :notes, :string, :limit => 3000
  end

  def self.down
    remove_column :rides, :payment
    remove_column :rides, :notes
  end
end
