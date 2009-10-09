# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all
  before_filter :set_page_title
  
  protected
  
  def set_page_title
    @page_title = controller_name.capitalize
  end
  
  def sticky_param(symbol)
    if params.has_key?(symbol)
      session[symbol] = params[symbol]
    end
    session[symbol]
  end
  
  def get_customers
    @customers = Customer.find(:all, :order => :name)
  end
  
  def get_services
    @services = Service.find(:all, :order=>'name')    
  end
end