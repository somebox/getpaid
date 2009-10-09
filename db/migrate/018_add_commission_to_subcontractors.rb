class AddCommissionToSubcontractors < ActiveRecord::Migration
  def self.up
    add_column :contacts, :commission, :float
  end

  def self.down
    remove_column :contacts, :commission
  end
end
