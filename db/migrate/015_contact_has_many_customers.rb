class Contact < ActiveRecord::Base; end
class Customer < ActiveRecord::Base; end    

class ContactHasManyCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :contact_id, :integer
    Contact.find(:all).each do |contact|
      if contact.customer_id and customer = Customer.find(contact.customer_id)         
        customer.contact_id = contact.id
        customer.save
      end
    end
    remove_column :contacts, :customer_id
  end

  def self.down
    add_column :contacts, :customer_id, :integer
    Customer.find(:all).each do |customer|
      if customer.contact_id and contact = Contact.find(customer.contact_id)
        contact.customer_id = customer.id
        contact.save
      end
    end
    remove_column :customers, :contact_id    
  end
end
