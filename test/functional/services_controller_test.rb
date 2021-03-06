require File.dirname(__FILE__) + '/../test_helper'
require 'services_controller'

# Re-raise errors caught by the controller.
class ServicesController; def rescue_action(e) raise e end; end

class ServicesControllerTest < Test::Unit::TestCase
  fixtures :services

  def setup
    @controller = ServicesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:services)
  end

  def test_should_get_new
    get :new
    assert_response :success
    assert true
  end
  
  def test_should_create_service
    old_count = Service.count
    post :create, :service => { :name => 'work', :description => 'work', :default_rate => 23.3, :unit => 'hours' }
    assert_equal old_count+1, Service.count
    
    assert_redirected_to :action => 'index'
  end

  def test_should_show_service
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_service
    put :update, :id => 1, :service => { }
    assert_redirected_to :action => 'index'
  end
  
  def test_should_destroy_service
    old_count = Service.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Service.count
    
    assert_redirected_to services_path
  end
end
