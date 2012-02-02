class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :city
      t.timestamps
    end
    
    add_index(:locations, :name)
    add_index(:locations, :city)
  end

  def self.down
    drop_table :locations
    
    remove_index :locations, :name
    remove_index :locations, :city
  end
end
