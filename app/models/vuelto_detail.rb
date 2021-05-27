class VueltoDetail < ActiveRecord::Base
 

 
  
  
    belongs_to :cout 
    belongs_to :vuelto

    validates_presence_of :vuelto_id,  :fecha , :cout_id,:importe,:flete,:egreso ,:total,:observa 
  
    
    def get_detalle
        ret =""
        if self.tranportorder.code !="9999" 
            ret = self.tranportorder.code << " - " << self.tranportorder.truck.placa<<" - " << self.tranportorder.get_placa(self.tranportorder.truck2_id)
        end 
        return ret 
    end 


end
