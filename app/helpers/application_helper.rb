# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def main_nav
    nav = []
    nav << {:contact => 'Contacts'}
    nav << {:customer => 'Customers/Projects'}
    nav << {:line_item => 'Time Logs'}    
    nav << {:invoice => 'Invoices'}
    nav << {:service => 'Services'}
    
    active = {:class => 'active'}

    str = content_tag('li', link_to("Home", home_path),
                          controller.controller_name.eql?('home') ? active : nil)
    nav.each do |item|
        section = controller.controller_name
        key = item.keys.first.to_s
        title = item.values.first
        status = section == key.pluralize ? active : nil
        str << content_tag('li', link_to(title, "/" + key.pluralize), status)
    end
    str
  end

  def display_or_msg(str,message='(none)')
    return str.to_s.strip.empty? ? message : h(str)
  end

  def format_as_date_detail(date)
    str = ""
    if date.nil?
      str << "(unknown)"
    else
      str << date.to_s
      str << '<br />('
      str << time_ago_in_words(date) + ' ago'
      str << ')'
    end
    str
  end

  def flash_messages
    if request.format.html? == true
      render :partial => 'layouts/flash_messages'
    else
      page.replace 'flash_messages', :partial => 'layouts/flash_now_messages'
      flash_id = flash.now[:notice].blank? ? 'error' : 'notice'
      page.visual_effect :appear, flash_id
      page.delay(5) do
        page.visual_effect :fade, flash_id
      end
    end
  end

  def update_button
    content_tag("div", submit_tag('Update', :class=>"update"), :class => 'buttons')
  end
  
  def display_contact(contact)
    if contact 
      return link_to(contact.name, contact_path(contact))
    else
      return '(none)'
    end
  end
  
  def yesno(value)
    value.blank? ? 'no' : 'yes'
  end
  
  def add_onload(js)
    javascript_tag "Event.observe(window, 'load', function() { #{js}; });"
  end  

  def display_customer(customer)
    if customer
      return link_to(customer.name, customer_path(customer))
    else
      return '(none)'
    end
  end
end
