class CreateHookups < ActiveRecord::Migration
  def self.up
    create_table :hook_ups do |t|
      t.integer :contactee_id
      t.integer :contacter_id
      t.timestamps
    end
  end

  def self.down
    drop_table :hook_ups
  end
end
