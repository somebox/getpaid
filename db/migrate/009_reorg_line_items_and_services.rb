class ReorgLineItemsAndServices < ActiveRecord::Migration
  def self.up
    remove_column :line_items, :unit
    add_column :line_items, :description, :string
    add_column :services, :unit, :string
  end

  def self.down
    add_column :line_items, :unit, :string
    remove_column :line_items, :description
    remove_column :services, :unit
  end
end
