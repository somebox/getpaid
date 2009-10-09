module ContactsHelper  
  def customer_list(contact)
    if contact.subcontractor?
      content_tag :em, 'Sub-contractor'
    else
      contact.customers.collect do |customer|
        link_to customer.name, customer_path(customer.id)
      end.join(', ')
    end
  end
end
