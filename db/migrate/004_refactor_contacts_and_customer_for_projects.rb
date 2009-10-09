class RefactorContactsAndCustomerForProjects < ActiveRecord::Migration
  def self.up
    # rename_column "invoices", "customer_id", "project_id"
  end

  def self.down
    # rename_column "invoices", "project_id", "customer_id"
  end
end
