class Invoice < ActiveRecord::Base
  has_many :line_items, :order => 'date_performed asc', :dependent=>:destroy
  belongs_to :customer
  cattr_accessor :per_page
  @@per_page = 30 

  validates_presence_of :number, :status
  validates_uniqueness_of :number
  validates_numericality_of :number
  validates_numericality_of :discount, :adjustment, :allow_nil => true
  
  STATUS_TYPES = %w(new open paid cancelled)
  DISCOUNTS = [0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.40, 0.50, 0.75]

  # class methods

  def self.quick_find(query, page=1)
    self.paginate( :all, 
               :page => page,
               :conditions =>[ %Q(
                  customers.name like '%%%s%%' OR 
                  customers.short_name like '%%%s%%' OR 
                  invoices.number like '%%%s%%'
                  ), query, query, query ], 
                :joins => "join customers on invoices.customer_id = customers.id"
              )
  end
  
  def self.generate_num
    Invoice.maximum(:number).to_i + 1
  end
              
  def self.find_recent_new
    self.find(:all, :conditions => {:status => 'new'})
  end
  
  def self.find_by_status(status)
    self.find(:all, :conditions => {:status => status})
  end
  
  def self.total_for_year(year=nil)
    year ||= Date.today.year # default to this year
    self.find(:all, :conditions => ["date > ? and (status='open' or status='paid')", Date.civil(year)]).collect(&:total).sum
  end
  
  def self.total_by_status(status)
    self.find_by_status(status).inject(0) do |total,invoice|
      total += invoice.total; total
    end
  end

  def self.total
    self.find(:all).inject(0) do |total,invoice|
      total += invoice.total; total
    end
  end
  
  # instance methods

  def recent_line_items
    self.line_items.find( :all, 
                          :conditions => ['date_performed > ?', 1.month.ago], 
                          :order => 'date_performed desc', 
                          :limit => 3
                        )
  end
  
  # This method is for splitting an invoice, using breakdowns in the line items.
  # It is currently not tied to the UI, intended for use at the console for now.
  # If line item descriptions contain an hours breakdown tag, it will be split to a new invoice:
  #
  #   @i.line_item.description => "worked on code [H:3]"
  #   @i.line_item.hours => 5.5
  #   @h = @i.split('H', "Hot Customer")
  #   @h.line_items.first.description => "worked on code [Hot Customer] "
  #   @h.line_items.first.hours => 3
  #   line_item.hours
  #
  # The matching tag is not case-sensitive, so [h:3] would work too. 
  # 
  def split(client_tag, client_name='')
    to_copy = self.attributes.slice('status','date','customer_id','note')
    split_invoice = Invoice.new(to_copy)
    split_invoice.number = Invoice.generate_num
    tag_regex = /\[#{client_tag}\:(\d+\.?\d*)\]/i
    self.line_items.each do |line_item|
      if m = line_item.description.match(tag_regex)
        new_quantity = m.captures.first.to_f
        # TODO: deal with edge cases, tag but no hours, bad tags, etc
        # next unless new_quantity > 0 

        split_line_item = LineItem.new(line_item.attributes.merge({'id'=>nil, 'invoice_id'=>nil}))
        unless client_name.blank?
          split_line_item.description = line_item.description.gsub(tag_regex, "[#{client_name}]")
        end
        split_line_item.quantity = new_quantity
        
        line_item.description = line_item.description.gsub(tag_regex,'').strip!
        line_item.quantity = line_item.quantity - new_quantity
        if (line_item.quantity <= 0)
          line_item.delete
        else
          line_item.save
        end

        split_invoice.line_items << split_line_item
      end
    end
    split_invoice.save
    split_invoice
  end
  
  def subcontractors?
    line_items.each do |line_item|
      return true if line_item.subcontracted?
    end
    false
  end
  
  def subtotal
    line_items.inject(0) { |total,line_item| 
      total += line_item.rate * line_item.quantity.to_f; total 
    }    
  end

  def apply_adjustments(sub)
    sub = sub * (1.0-discount) if discount.to_f > 0
    sub = sub - adjustment if adjustment.to_f > 0
    sub
  end
    
  def total
    sub = subtotal
    apply_adjustments(sub)
  end

  def total_profit
    total = 0
    self.line_items.each do |line_item|
      total += line_item.profit
    end
    total
  end
  
  def total_hours
    total = 0
    line_items.each do |line_item|
      total += line_item.quantity.to_f if line_item.service.unit == 'hour'
    end
    total
  end
  
  def title
    "#{customer.short_name}-#{number}-invoice-#{date.strftime("%m-%d-%Y")}"
  end
  
  def last_work_date
    last = self.line_items.find(:first, :order => 'date_performed desc')
    last ? last.date_performed + 1 : self.date
  end
  
  def adjusted?
    adjustment.to_f > 0
  end
  
  def discounted?
    discount.to_f > 0
  end
  
  def show_subtotal?
    adjusted? or discounted?
  end
end
