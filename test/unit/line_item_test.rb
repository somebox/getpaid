require File.dirname(__FILE__) + '/../test_helper'

class LineItemTest < Test::Unit::TestCase
  def test_total
    l = LineItem.new(:quantity => 10, :rate => 3.33)
    assert_equal 33.30, l.total
  end
  
  def test_total_with_half_hour_quan
    l = LineItem.new(:quantity => 0.5, :rate => 150)
    assert_equal 75, l.total
  end
  
  def test_total_with_bad_quan
    l = LineItem.new(:quantity => 'dsafdsa', :rate => 150)
    assert_equal 0, l.total
  end
  
  def test_total_with_partial_hours
    l = LineItem.new(:quantity => 0.5, :rate => 100)
    assert_equal 50, l.total
  end
  
  def test_sets_defaults
    l = LineItem.new
    assert_equal Service.default, l.service
    assert l.date_performed
  end
  
  def test_sets_default_date_from_invoice
    l = LineItem.new(:invoice_id => invoices(:one))
    assert_equal invoices(:one).last_work_date, l.date_performed
  end

  def test_sets_default_rate_from_service
    l = LineItem.new(:service_id => services(:code))
    assert_equal services(:code).default_rate, l.rate
  end
  
  def test_subcontracted?
    assert line_items(:sub1).subcontracted?
    assert !line_items(:one).subcontracted?    
  end
  
  def test_profit
    assert_equal 50, line_items(:sub2).profit
  end
  
  def test_batch_process
    line_items = LineItem.batch_process(
      :command => 'quantity',
      :line_item_ids => [1],
      'quantity' => 2
    )
    assert_equal 2, LineItem.find(1).quantity
  end
end