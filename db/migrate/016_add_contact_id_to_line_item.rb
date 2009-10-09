class AddContactIdToLineItem < ActiveRecord::Migration
  def self.up
    add_column :line_items, :contact_id, :integer
  end

  def self.down
    remove_column :line_items, :contact_id
  end
end
