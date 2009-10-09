class Service < ActiveRecord::Base
  has_many :line_items
  
  validates_numericality_of :default_rate
  validates_presence_of :name, :default_rate, :unit, :description
  
  def self.default
    self.most_frequent
  end
  
  def self.most_frequent
    self.find_by_sql(%Q[
      select s.*, count('li.*') as cnt 
      from line_items li, services s 
      where li.service_id = s.id 
      group by li.service_id 
      order by cnt desc 
      limit 10  
    ]).first    
  end
end
