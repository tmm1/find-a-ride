class AddExpiresOnToRides < ActiveRecord::Migration
  def self.up
    add_column :rides, :expires_on, :date
  end

  def self.down
    remove_column :rides, :expires_on
  end
end
