class LineItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :service
  belongs_to :contact

  validates_numericality_of :rate, :quantity
  validates_presence_of :service_id, :description
  
  BATCH_COMMANDS = [['set service','service_id'],	['set rate','rate'], ['set quantity', 'quantity'], ['set sub-contractor','contact_id'], ['copy to invoice','copy_to']]

  def self.valid_batch_command?(command) 
    BATCH_COMMANDS.map{|a|a[1]}.include?(command)
  end

  def after_initialize
    self.service ||= Service.default
    self.date_performed ||= (invoice ? invoice.last_work_date : DateTime.yesterday)
    self.rate ||= service.default_rate
  end
  
  def self.batch_process(params)
#    puts params.inspect
    command = params[:command]
    line_items = []
    if params[:line_item_ids].present? and LineItem.valid_batch_command?(command)
      line_items = LineItem.find(params[:line_item_ids])
      line_items.each do |line_item|
        case command
        when 'copy_to'
          target = Invoice.find_by_number!(params[:copy_to])
#          puts 'copying'          
          target.line_items << LineItem.new(line_item.attributes)
        else
#          puts "updating #{command} with #{params[command].inspect} for line item #{line_item.id}"
          line_item.update_attribute(command.to_s, params[command].to_s)
        end
      end
    end
    line_items
  end

  def total
    quantity.to_f * rate.to_f
  end
  
  def self.find_recent_new
    line_items = Invoice.find_recent_new.collect {|invoice| invoice.line_items}
    line_items.flatten.sort {|a,b| b.date_performed <=> a.date_performed }[0..6]
  end
  
  def subcontracted?
    self.contact and self.contact.subcontractor?
  end
  
  def profit
    self.contact ? (total * self.contact.commission.to_f) : total
  end
end
