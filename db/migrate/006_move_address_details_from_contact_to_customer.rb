class MoveAddressDetailsFromContactToCustomer < ActiveRecord::Migration
  def self.up
    [:address, :address_2, :city, :state, :postal].each do |c|
      remove_column :contacts, c
      add_column :customers, c, :string
    end
    remove_column :contacts, :alt_phone
  end

  def self.down
    [:address, :address_2, :city, :state, :postal].each do |c|
      remove_column :customers, c      
      add_column :contacts, c, :string
    end
    add_column :contacts, :alt_phone, :string    
  end
end
