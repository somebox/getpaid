module CustomersHelper
  def contact_select(customer)
    contacts = Contact.find(:all,:order=>'last_name,first_name').map{|c| [c.name, c.id]}
    select_tag :contact_id, options_for_select(contacts, customer.contact_id), :id => 'contact_id'
  end
  
  def format_customer_address(customer)
    str = []
    str << display_or_msg(customer.address,'(no street)')
    str << h(customer.address_2) unless customer.address_2.empty?
    locale = ''
    locale << display_or_msg(customer.city,'')
    locale << ', ' unless customer.city.empty? or customer.state.empty?
    locale << display_or_msg(customer.state, '')
    locale << ' '
    locale << display_or_msg(customer.postal, '')
    str << locale.strip
    return str.join('<br />')
  end

  def format_customer_location(customer)
    str = ''
    str << display_or_msg(customer.city, '')
    str << ', ' if customer.city.length > 0
    str << display_or_msg(customer.state, '') 
    str = '-' unless str.length > 0
    return str
  end
end
