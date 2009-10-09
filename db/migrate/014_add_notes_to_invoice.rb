class AddNotesToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :note, :string
    add_column :invoices, :adjustment_reason, :string
    add_column :invoices, :discount_reason, :string
  end

  def self.down
    remove_column :invoices, :note
    remove_column :invoices, :adjustment_reason
    remove_column :invoices, :discount_reason
  end
end
