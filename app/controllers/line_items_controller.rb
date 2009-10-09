class LineItemsController < ApplicationController
  before_filter :get_services, :get_customers

  # GET /line_items
  # GET /line_items.xml  
  def index
    @line_items = LineItem.paginate_with_filters({
                   :invoice_id => nil
                }, {:page => params[:page], :order=>'date_performed desc'})
                        
    respond_to do |format|
      format.html { 
        
      }
      format.xml  { render :xml => @line_items.to_xml }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.xml
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @line_item.to_xml }
    end
  end

  def new
    @line_item = LineItem.new(:invoice_id => params[:invoice_id])
    render :update do |page|
      page.replace_html 'popup-container', :partial => 'form'
      page.call 'showPopup', 400
    end
  end

  def create
    @line_item = LineItem.create(params[:line_item])
    @invoice = @line_item.invoice
    render :update do |page|
      if @line_item.valid?
        page.call 'hidePopup'          
        page.replace_html 'line_items', :partial =>  'invoices/table'
        page.visual_effect :highlight, "line_item_#{@line_item.id}"
        page.visual_effect :highlight, "total"      
      else
        page.replace_html 'popup-container', :partial => 'form'
        page.call 'doResize'
      end
    end
  end

  def edit
    @line_item = LineItem.find(params[:id])
    render :update do |page|
      page.replace_html 'popup-container', :partial => 'form'
      page.call 'showPopup', 400
    end
  end

  def update    
    @line_item = LineItem.update(params[:id], params[:line_item])
    @invoice = @line_item.invoice          

    render :update do |page|
      if @line_item.valid?
        page.call 'hidePopup'          
        page.replace_html 'line_items', :partial =>  'invoices/table'
        page.visual_effect :highlight, "line_item_#{@line_item.id}"
        page.visual_effect :highlight, "total"
        page.call 'initInvoiceEditUI'
      else
        page.replace_html 'popup-container', :partial => 'form'
        page.call 'doResize'
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.xml
  def destroy
    @line_item = LineItem.find(params[:id])
    @invoice = @line_item.invoice
    @line_item.destroy
    render :update do |page|
      page.visual_effect :fade, "line_item_#{@line_item.id}", :duraton => 0.1
      page.remove 'total'
      page.remove 'discount' if @invoice.discounted?
      page.remove 'subtotal' if @invoice.show_subtotal?
      page.insert_html :after, 'bottom', :partial => 'row_total'          
    end
  end
end
