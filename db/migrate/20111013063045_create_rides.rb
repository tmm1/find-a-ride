class CreateRides < ActiveRecord::Migration
  def self.up
    create_table :rides do |t|
      t.integer :offerer_id
      t.integer :sharer_id
      t.string :user_info, :limit => 1000
      t.timestamp :contact_date
      t.timestamps
    end
  end

  def self.down
    drop_table :rides
  end
end
