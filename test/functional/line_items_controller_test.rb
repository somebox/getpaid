require File.dirname(__FILE__) + '/../test_helper'
require 'line_items_controller'

# Re-raise errors caught by the controller.
class LineItemsController; def rescue_action(e) raise e end; end

class LineItemsControllerTest < Test::Unit::TestCase
  fixtures :line_items

  def setup
    @controller = LineItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @invoice = Invoice.find(1)
    @valid_line_item = {
      :service_id => services(:code).id, 
      :invoice_id => invoices(:one).id, 
      :quantity   => 1, 
      :rate       => 10, 
      :description => 'newly created line item', 
      :date_performed => Time.now
    }
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:line_items)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_new_line_item_with_invoice_id
    xhr :get, :new, :invoice_id => @invoice.id
    assert_response :success    
    assert_equal 1, assigns(:line_item).invoice.id
  end

  def test_new_line_item_uses_defaults
    xhr :get, :new
    assert_response :success
    assert assigns(:line_item).rate > 0    
  end
  
  def test_create_valid_line_item
    xhr :post, :create, :line_item => @valid_line_item
    assert LineItem.find_by_description(@valid_line_item[:description])
  end
  
  def test_should_show_line_item
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_line_item
    put :update, :id => 1, :line_item => { :quantity => 10}
    assert_equal 10, assigns(:line_item).quantity
  end
  
  def test_should_destroy_line_item
    old_count = LineItem.count
    xhr :post, :destroy, :id => 1
    assert_equal old_count-1, LineItem.count
  end
  
  def test_should_handle_invalid_line_item
    xhr :post, :update, :id => 1, :line_item => {:description => ''}
    assert_response :success
    assert assigns(:line_item).errors["description"]
  end
end
