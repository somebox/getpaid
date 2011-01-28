module LineItemsHelper
  def line_item_parts2
  "'line_item[service_id]='+encodeURIComponent($F('line_item_service_id'))+'&edit=1'"  
  end
  
  def line_item_parts
    fields = %w(date_performed description service_id quantity)
    parts = []
    join = ''
    fields.each do |field|
      join = '&' unless parts.empty? 
      parts << "'#{join}line_item[#{field}]='+encodeURIComponent($F('line_item_#{field}'))"
    end
    return parts.join('+') + "+'&edit=1'"
  end
  
  def rate_and_units(line_item)
    if line_item.rate == 1.0
      "fixed"
    else
      "#{line_item.rate.to_i}/#{line_item.service.unit}"
    end
  end
  
  def show_quantity(line_item)
    if line_item.rate > 1.00
      line_item.quantity
    else
      '-'
    end
  end
  
  def show_service(line_item)
    if line_item.contact
      content_tag(:strong, line_item.contact.initials) + ': ' + line_item.service.name
    else
      line_item.service.name
    end    
  end
  
  def contact_select_tag
    contacts = Contact.find(:all,:order=>'last_name,first_name')
    options = [["All",""]] + contacts.map{|c| ["#{c.last_name}, #{c.first_name}", c.id]}
    select_tag :contact_id, options_for_select(options, @current_contact), :id => 'contact_id'    
  end

  def subcontractor_select_tag
    contacts = Contact.find(:all, :conditions => 'subcontractor = 1', :order=>'last_name,first_name')
    options = [["-",""]] + contacts.map{|c| ["#{c.last_name}, #{c.first_name}", c.id]}
    select :line_item, :contact_id, options, :id => 'contact_id'
  end

end
