class InvoicesController < ApplicationController
  before_filter :get_customers, :get_services
  include ActionView::Helpers::TextHelper

  # GET /invoices
  # GET /invoices.xml
  def index
    @current_customer = sticky_param(:customer_id)
    @current_status = sticky_param(:status)
    if params[:search].present?
      @invoices = Invoice.quick_find(params[:search])
    else
      @invoices = Invoice.paginate_with_filters({
                  :customer_id => @current_customer,
                  :status => @current_status
                }, {:page => params[:page], :order=>'date desc,number'})
    end
    respond_to do |format|
      format.html {
        @customers = Customer.find_invoiced
      }
      format.xml  { render :xml => @invoices.to_xml }
    end
  end

  def search
    @invoices = Invoice.quick_find(params[:query])
  end
  
  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    @invoice = Invoice.find(params[:id])
    render :layout => false
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new(params[:invoice])
    @invoice.number = Invoice.generate_num
  end

  # GET /invoices/1;edit
  def edit
    @invoice = Invoice.find(params[:id])
    @services = Service.find(:all, :order=>'name')
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        flash[:notice] = 'Invoice was successfully created.'
        format.html { redirect_to invoices_url }
        format.xml  { head :created, :location => invoice_url(@invoice) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors.to_xml }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        flash[:notice] = 'Invoice was successfully updated.'
        format.html { redirect_to invoices_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors.to_xml }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.xml  { head :ok }
    end
  end

  def batch_edit
    @invoice = Invoice.find(params[:id])
    begin
      @line_items = LineItem.batch_process(params)
      flash[:notice] = pluralize(@line_items.size, 'item') + " updated."
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Invoice #{params[:id]} was not found"
    else
      head :not_modified if @line_items.blank?
    ensure
      @line_items ||= []
    end
  end
  
  def batch_status
    if !params[:invoice_ids].blank? and !params[:status].blank?
      @invoices = Invoice.find(params[:invoice_ids])
      @invoices.each do |line_item|
        line_item.update_attribute(:status, params[:status]) 
      end      
    else
      render :text => 'nothing to do', :status => :not_modified
    end      
  end
end
