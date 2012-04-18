class CreateAlerts < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :state
      t.string :message, :limit => 5000
      t.timestamps
    end
  end

  def self.down
    drop_table :alerts
  end
end
