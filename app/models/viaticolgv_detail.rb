class ViaticolgvDetail < ActiveRecord::Base
  belongs_to :viaticolgv


    validates_presence_of :viaticolgv_id,  :importe , :gasto_id,:employee_id,:document_id,:egreso_id ,:supplier_id
  
    belongs_to :supplier 
    belongs_to :gasto 
    belongs_to :employee
    belongs_to :document 

    belongs_to :egreso

 
    belongs_to :cout 


    def get_detalle
        ret =""
        if self.tranportorder.code !="9999" 
            ret = self.tranportorder.code << " - " << self.tranportorder.truck.placa<<" - " << self.tranportorder.get_placa(self.tranportorder.truck2_id)
        end 
        return ret 
    end 
    

end
