class TimeslipsController < ApplicationController
  before_filter :get_customers
  
  def index
    @current_customer = sticky_param(:customer_id)
    @timeslips = Timeslip.paginate_with_filters({
                  :customer_id => @current_customer
                  }, {:page => params[:page], :order=>'date_performed desc'})
  end
  
  def new
    @timeslip = Timeslip.new
  end
  
  def create
    @timestamp = Timeslip.create(params[:timeslip])      
  end
  
  def edit
    @timestamp = Timeslip.find(params[:id])
  end
  
  def update
    @timestamp = Timeslip.update_attributes(params[:timeslip])
  end
  
  def delete
    @timestamp = Timeslip.find(params[:id])
    @timestamp.destroy
  end
  
  protected
  
  def get_timestamp

  end
    
end
