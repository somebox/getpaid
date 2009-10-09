namespace :total do
  desc "Calculate what we're expecting to get paid right now, from open invoices"
  task :profit => :environment do
    invoices = Invoice.find_by_status('open')
    client_totals = Hash.new(0)
    invoices.each do |invoice|
      client_totals[invoice.customer.name] += invoice.total_profit
    end
    client_totals.each do |k,v|
      puts "%20s : $ %10.2f" % [k,v]
    end
  end

  desc "Calulate expected total for all open invoices"
  task :open => :environment do
    invoices = Invoice.find_by_status('open')
    client_totals = Hash.new(0)
    invoices.each do |invoice|
      client_totals[invoice.customer.name] += invoice.total
    end
    client_totals.each do |k,v|
      puts "%20s : $ %10.2f" % [k,v]
    end    
  end
end