class AddSubcontractorFieldToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :subcontractor, :integer
  end

  def self.down
    remove_column :line_items, :subcontractor
  end
end
