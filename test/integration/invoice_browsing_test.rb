require "#{File.dirname(__FILE__)}/../test_helper"

class InvoiceBrowsingTest < ActionController::IntegrationTest
  fixtures :customers, :contacts, :invoices

  def setup
    @c = customers(:somebox)
  end

  # Replace this with your real tests.
  def test_customer_filter
    @i = @c.invoices.first
    get '/invoices'
    assert_select 'table.list', /#{@i.number}/
    get '/invoices', :customer_id => @c.id
    assert_select 'table.list', /#{@i.number}/
    get '/invoices', :customer_id => customers(:acme).id
    assert_select 'table.list', {:text => /#{@i.number}/, :count => 0}
  end
  
  def test_remembers_customer_filter
    # filter by customer
    get '/invoices', :customer_id => @c.id
    assert_select '#customer_id option[selected=selected]', /#{@c.name}/
    # try again, without customer id - should still be selected...
    get '/invoices'
    assert_select '#customer_id option[selected=selected]', /#{@c.name}/
  end
  
  def test_status_filter
    @paid_invoice = invoices(:adjustment)
    @open_invoice = invoices(:simple)
    # filter by status
    get '/invoices'
    assert_select 'table.list', /#{@paid_invoice.number}/
    assert_select 'table.list', /#{@open_invoice.number}/    
    get '/invoices', :status => 'open'
    assert_select 'table.list', /#{@open_invoice.number}/
    assert_select 'table.list', {:text => /#{@paid_invoice.number}/, :count => 0}
    get '/invoices', :status => 'paid'
    assert_select 'table.list', /#{@paid_invoice.number}/
    assert_select 'table.list', {:text => /#{@open_invoice.number}/, :count => 0}    
  end
  
  
end
