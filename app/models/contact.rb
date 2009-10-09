class Contact < ActiveRecord::Base
  validates_presence_of :first_name, :last_name
  validates_format_of :email, :with => RFC822::EmailAddress, :allow_blank => true
  validates_numericality_of :commission, :allow_nil => true, 
          :greater_than_or_equal_to => 0,
          :less_than_or_equal_to => 1

  has_many :customers
  has_many :line_items, :order => 'date_performed asc'
  
  def name
    [self.last_name, self.first_name].join(', ')
  end
  
  def initials
    [self.first_name.to_s.first, self.last_name.to_s.first].join('').upcase
  end
  
  def self.subcontractors
    self.find(:all, :conditions => 'subcontractor = 1', :order => 'last_name, first_name')
  end
end

