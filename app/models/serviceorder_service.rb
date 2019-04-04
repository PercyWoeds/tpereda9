class ServiceorderService < ActiveRecord::Base

validates_presence_of :serviceorder_id, :servicebuy_id, :price, :quantity, :total
  
  belongs_to :serviceorder	
  belongs_to :servicebuy
  
  
   def get_name_ext(id)
     if id != nil 
    invoice_services = ServiceExtension.find(id)    
    if invoice_services 
      return invoice_services.name 
    else
      return "... "
    end 
  else
      return "..."
  end 
  end 

end
