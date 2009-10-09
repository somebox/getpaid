class RenameCustomerCol < ActiveRecord::Migration
  def self.up
    rename_column(:customers, :tag, :short_name)
  end
  def self.down
    rename_column(:customers, :short_name, :tag)
  end
end
