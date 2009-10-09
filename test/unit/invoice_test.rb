require File.dirname(__FILE__) + '/../test_helper'

class InvoiceTest < Test::Unit::TestCase
  fixtures :invoices

  # Replace this with your real tests.
  def test_simple_total
    i = invoices(:simple)
    assert_equal 1000, i.total
  end
  
  def test_total
    i = invoices(:one)
    assert_equal 1737.5, i.total
  end

  def test_subtotal
    i = invoices(:one)
    assert_equal 1737.5, i.subtotal
  end
  
  def test_with_discount
    i = invoices(:one)
    i.discount = 0.05
    assert_equal 1737.5 * 0.95, i.total
  end

  def test_with_adjustment
    i = invoices(:one)
    i.adjustment = 10
    assert_equal 1737.5 - 10, i.total
  end

  def test_adjusted?
    i = invoices(:one)
    assert !i.adjusted?
    i.adjustment = 100
    assert i.adjusted?
    assert i.show_subtotal?    
  end

  def test_discounted?
    i = invoices(:one)
    assert !i.discounted?
    i.discount = 100
    assert i.discounted?
    assert i.show_subtotal?
  end

  def test_total_profit
    i = invoices(:subcontracted)
    assert_equal 200, i.total_profit
  end

  def test_generated_invoice_number
    i = Invoice.create({:customer_id => 1, :status => 'new', :number => 1001})
    assert i
  end
  
  def test_paginate_with_filters
    c = Customer.find(2)
    assert_equal c.invoices.size, Invoice.paginate_with_filters({:customer_id=>2}, {:page=>1}).size
  end
  
  def test_discount
    i = invoices(:discount)
    assert_equal 800, i.total
  end
  
  def test_adjustment
    i = invoices(:adjustment)
    assert_equal 100, i.total
  end
  
  def test_subcontractors
    assert invoices(:subcontracted).subcontractors?
    assert !invoices(:one).subcontractors?
  end
  
  def test_quick_find_by_number
    assert_equal 2, Invoice.quick_find(1010).first.id
  end
  
  def test_quick_find_by_customer_name
    assert_equal 1, Invoice.quick_find('acme').first.id
  end
  
  def test_split_changes_description_in_new_line_items
    h = invoices(:to_split).split('h','Hilton')
    assert_equal "worked today [Hilton]", h.line_items.first.description
  end

  def test_split_changes_description_in_old_line_items
    invoices(:to_split).split('h','Hilton')
    assert_equal "worked today", line_items(:split1).description
  end

  def test_split_changes_quantity_in_new_line_items
    h = invoices(:to_split).split('h','Hilton')
    assert_equal 2.5, h.line_items.first.quantity
  end
  
  def test_split_does_not_copy_over_invoices_with_no_split_data
    h = invoices(:to_split).split('h','Hilton')
    assert_equal 3, h.line_items.size    
  end

  def test_split_gets_hour_totals_correct
    h = invoices(:to_split).split('h')
    assert_equal 9.25, h.line_items.sum(:quantity)
    assert_equal 8.5, invoices(:to_split).line_items.sum(:quantity)
  end

  def test_split_changes_quantity_in_old_line_items
    invoices(:to_split).split('h','Hilton')
    assert_equal 2, line_items(:split2).quantity
  end
  
end
