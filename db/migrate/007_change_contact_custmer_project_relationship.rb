class ChangeContactCustmerProjectRelationship < ActiveRecord::Migration
  def self.up
    add_column :contacts, :customer_id, :integer
    remove_column :projects, :contact_id
    remove_column :customers, :contact_id
  end

  def self.down
    remove_column :contacts, :customer_id
    add_column :projects, :contact_id, :integer
    add_column :customers, :contact_id, :integer
  end
end
