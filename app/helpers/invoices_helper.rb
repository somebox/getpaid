module InvoicesHelper
  def customer_select_tag
    customers = [['All','']] + @customers.map{|c| [c.name, c.id.to_s]}
    select_tag :customer_id, options_for_select(customers, @current_customer), {:onchange => 'submit();'}
  end

  def status_select_tag
    statuses = [['All','']] + Invoice::STATUS_TYPES
    select_tag :status, options_for_select(statuses, @current_status), {:onchange => 'submit();'}
  end
  
  def customer_subhead
    return '' if @current_customer.blank?
    customer = Customer.find(@current_customer)
  	content_tag :span, '(' + customer.name + ')', {:class=>"subhead"}
  end
  
  def display_hours(invoice)
    invoice.total_hours > 0 ?  invoice.total_hours : '-' 
  end
end
