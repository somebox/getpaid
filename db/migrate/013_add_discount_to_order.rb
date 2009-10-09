class AddDiscountToOrder < ActiveRecord::Migration
  def self.up
    add_column :invoices, :discount, :float
    add_column :invoices, :adjustment, :float
  end

  def self.down
    remove_column :invoices, :discount
    remove_column :invoices, :adjustment
  end
end
