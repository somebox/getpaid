class ServicesController < ApplicationController
  # GET /services
  # GET /services.xml
  def index
    @services = Service.find(:all, :order=>:name)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @services.to_xml }
    end
  end

  # GET /services/1
  # GET /services/1.xml
  def show
    @service = Service.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @service.to_xml }
    end
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1;edit
  def edit
    @service = Service.find(params[:id])
  end

  # POST /services
  # POST /services.xml
  def create
    @service = Service.new(params[:service])

    respond_to do |format|
      if @service.save
        flash[:notice] = 'Service was successfully created.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :created, :location => service_url(@service) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service.errors.to_xml }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.xml
  def update
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        flash[:notice] = 'Service was successfully updated.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors.to_xml }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_url }
      format.xml  { head :ok }
    end
  end
end
