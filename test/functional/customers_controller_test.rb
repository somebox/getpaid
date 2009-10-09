require File.dirname(__FILE__) + '/../test_helper'
require 'customers_controller'

# Re-raise errors caught by the controller.
class CustomersController; def rescue_action(e) raise e end; end

class CustomersControllerTest < Test::Unit::TestCase
  fixtures :customers

  def setup
    @controller = CustomersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:customers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_customer
    old_count = Customer.count
    post :create, :customer => { :name => "new customer", :short_name=>'new', :address=>'123', :city=>'new york', :state=>'ny', :postal=>"10002"}, :contact_id => Contact.find(:first)
    assert_redirected_to customers_path
    assert_equal old_count+1, Customer.count
  end

  def test_should_show_customer
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_customer
    put :update, :id => 1, :customer => { }, :contact_id => Customer.find(:first).contact.id
    assert_redirected_to customers_path
  end
  
  def test_should_destroy_customer
    old_count = Customer.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Customer.count
    assert true
    assert_redirected_to customers_path
  end
end
