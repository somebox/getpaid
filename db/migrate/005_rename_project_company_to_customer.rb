class RenameProjectCompanyToCustomer < ActiveRecord::Migration
  def self.up
    rename_column :projects, :company_id, :customer_id
  end

  def self.down
    rename_column :projects, :customer_id, :company_id
  end
end
