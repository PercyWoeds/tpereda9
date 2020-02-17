class Deliveryship < ActiveRecord::Base
	belongs_to :factura
	belongs_to :delivery 


 def get_guias_remision(id)    
        
    guias = []
    invoice_guias = Deliverymine.where(:mine_id => id)
    return invoice_guias
        
  end
  



end
