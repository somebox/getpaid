namespace :invoice do
  desc "separate an invoice into hilton and non-hilton"
  task :split => :environment do
    invoice = Invoice.find_by_number(ENV['NUM'])    
    unless invoice
      puts "Error: You must specify an existing invoice number, e.g.: 'rake invoice split NUM=1234'"
      exit
    end
    puts "invoice #{invoice.to_yaml}" 
    
    @h = Invoice.split('h', 'Hilton')
    puts "Created invoice #{@h.num}"
  end
end

