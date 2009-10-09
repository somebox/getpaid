class AddMoreToTimeslips < ActiveRecord::Migration
  def self.up
    add_column :timeslips, :service_id, :integer
  end

  def self.down
    remove_column :timeslips, :service_id
  end
end
