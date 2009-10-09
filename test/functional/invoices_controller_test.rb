require File.dirname(__FILE__) + '/../test_helper'
require 'invoices_controller'

# Re-raise errors caught by the controller.
class InvoicesController; def rescue_action(e) raise e end; end

class InvoicesControllerTest < Test::Unit::TestCase
  fixtures :invoices

  def setup
    @controller = InvoicesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:invoices)
  end

  def test_should_get_new
    get :new
    assert_response :success
    assert assigns(:invoice).number > 0
  end

  def test_should_get_new_with_customer_id
    get :new, :invoice => {:customer_id => 1}
    assert_response :success
    assert_equal 1, assigns(:invoice).customer_id
  end
  
  def test_should_create_invoice
    old_count = Invoice.count
    post :create, :invoice => { :status => 'open', :number=>1002 }
    assert_equal old_count+1, Invoice.count
    
    assert_redirected_to invoices_path
  end

  def test_should_show_invoice
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_invoice
    put :update, :id => 1, :invoice => { :status => 'cancelled' }
    assert_redirected_to invoices_path
    assert_equal 'cancelled', assigns(:invoice).status
  end
  
  def test_should_destroy_invoice
    old_count = Invoice.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Invoice.count
    
    assert_redirected_to invoices_path
  end

  def test_batch_edit_with_nothing_selected
    xhr :post, :batch_edit, :id => invoices(:one).id, :line_item_ids => []
    assert_response 304
  end
  
  def test_batch_edit_change_services
    xhr :post, :batch_edit, :id => invoices(:one).id, 
                            :line_item_ids => [1,2,3], 
                            :command => 'service_id', 
                            :service_id => 3
    assert_equal [3,3,3], LineItem.find(1,2,3).map(&:service_id)
  end

  def test_batch_edit_change_rates
    xhr :post, :batch_edit, :id => invoices(:one).id, 
                            :line_item_ids => [1], 
                            :command => 'rate',
                            :rate => '110'
    assert_equal 110, LineItem.find(1).rate
  end
  
  def test_batch_edit_copy_line_items
    # copy line item from invoice #1 to invoice #2
    source = invoices(:one)
    target = invoices(:two)
    xhr :post, :batch_edit, :id => source.id, 
                            :line_item_ids => [line_items(:one).id], 
                            :command => 'copy_to',
                            :copy_to => target.number                            
    assert source.reload.line_items.include?(line_items(:one)), "Original line item disappeared"
    assert copied_line_item = target.reload.line_items.first, "Line item was not copied"
    %w(description date_performed quantity rate service_id).each do |attr|
      assert_equal line_items(:one).send(attr.to_sym), copied_line_item.send(attr.to_sym), "#{attr} did not copy between line items"
    end
  end
  
  def test_batch_copy_with_bad_target_invoice
    # copy line item from invoice #1 to invoice #30000 (Does Not Exist)
    xhr :post, :batch_edit, :id => invoices(:one).id,
                            :line_item_ids => [line_items(:one).id], 
                            :command => 'copy_to',
                            :copy_to => 30000
    assert_response :success
    assert_match /not found/i, flash[:error]
  end
  
  def test_batch_status_changes_status
    xhr :post, :batch_status, :invoice_ids => [1,2,3], :status => 'paid'
    assert_response :success
    assert_equal ['paid','paid','paid'], assigns(:invoices).collect(&:status)
  end
  
  def test_quick_find
    get :search, :query => 1000
    assert_response :success
    #assert_select 'search_results', /1000/
  end
end
