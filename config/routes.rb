ActionController::Routing::Routes.draw do |map|

  # Rest routes
  map.resources :timeslips
  map.resources :contacts
  map.resources :companies
  map.resources :customers
  map.resources :invoices
  map.resources :line_items
  map.resources :projects
  map.resources :services  
    
  # named routes
  map.invoices_by_customer 'invoices/:customer',  
                        :controller => 'invoices',
                        :action => 'index'
  map.invoice_batch_edit 'invoices/:id/batch_edit', :controller => 'invoices', :action => 'batch_edit'
  map.invoice_batch_status 'invoices/list/batch_status', :controller => 'invoices', :action => 'batch_status'
  map.invoice_search 'invoices/search', :controller => 'invoices', :action => 'search'

  map.home '', :controller => "home"
                        
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
