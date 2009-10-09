class AddDateToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :date, :date
  end

  def self.down
    remove_column :invoices, :date
  end
end
