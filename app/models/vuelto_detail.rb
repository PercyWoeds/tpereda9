class VueltoDetail < ActiveRecord::Base
 
 
  
    belongs_to :cout 
    belongs_to :vuelto

    belongs_to :truck
    belongs_to :employee
    belongs_to :punto



    validates_presence_of :vuelto_id,  :fecha , :importe,:flete,:egreso ,:total,:observa ,:code ,
    :employee_id, :ubication_id, :ubication2_id, :truck_id , :truck2_id , :truck3_id
  
    
    def get_detalle
        ret =""
        if self.tranportorder.code !="9999" 
            ret = self.tranportorder.code << " - " << self.tranportorder.truck.placa<<" - " << self.tranportorder.get_placa(self.tranportorder.truck2_id)
        end 
        return ret 
    end



  def generate_vuelto_number(serie)
    if VueltoDetail.maximum("cast(code  as int)") == nil 
      self.code = "000001"
    else
      self.code = VueltoDetail.maximum("cast(code  as int)").next.to_s.rjust(6, '0')  
    end 
    return self.code 
  end

def get_empleado(id)


      if id != nil || id !="" || id.blank? ==false || id.empty? == false 
        empleado = Employee.find_by(id: id)
        begin 
        return empleado.full_name
          rescue
            return ""
        end 
    else
      return ""   
      end 
    end   

    def get_placa(id)
      placa = Truck.find(id)
      return placa.placa

    end   

    def get_punto(id)
      punto = Punto.find(id)
      return punto.name 

    end    


end
