class CreateTimeslips < ActiveRecord::Migration
  def self.up
    create_table :timeslips do |t|
      t.date :date_performed
      t.float :time
      t.string :description
      t.integer :contact_id
      t.integer :customer_id
      t.timestamps
    end
  end

  def self.down
    drop_table :timeslips
  end
end
