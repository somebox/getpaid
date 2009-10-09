class Customer < ActiveRecord::Base
  belongs_to :contact
  has_many :invoices, :order => :number

  validates_presence_of :name, :short_name, :address, :city, :state, :postal
  
  def self.find_invoiced
    find_by_sql('SELECT customers.id, customers.name FROM customers RIGHT OUTER JOIN invoices on invoices.customer_id=customers.id GROUP BY customers.id')
  end
  
  def total_by_status(status='open')
    self.invoices.find(:all, :conditions => {:status => status}).inject(0) do |total,invoice|
      total += invoice.total; total
    end
  end
  
end
