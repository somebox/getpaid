class ChangeLineItemQuantityToFloat < ActiveRecord::Migration
  def self.up
    change_column :line_items, :quantity, :float
  end

  def self.down
    change_column :line_items, :quantity, :integer    
  end
end
