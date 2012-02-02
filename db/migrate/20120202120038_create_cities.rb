class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name
      t.timestamps
    end
    
    add_index(:cities, :name)
  end

  def self.down
    drop_table :cities
    remove_index :cities, :name
  end
end
