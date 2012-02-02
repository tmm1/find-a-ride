class CreateRides < ActiveRecord::Migration
  def self.up
    create_table :rides do |t|
      t.integer :origin
      t.integer :destination
      t.datetime :ride_time
      t.boolean :fulfilled
      t.string :vehicle
      t.references :user
      t.string :type
      t.timestamps
    end
    
    add_index(:rides, :origin)
    add_index(:rides, :destination)
    add_index(:rides, :fulfilled)
    add_index(:rides, :vehicle)
  end

  def self.down
    drop_table :rides
    remove_index :rides, :origin
    remove_index :rides, :destination
    remove_index :rides, :fulfilled
    remove_index :rides, :vehicle
  end
end
