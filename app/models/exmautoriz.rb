class Exmautoriz < ActiveRecord::Base


 belongs_to   :tramit
 belongs_to   :tipo_tramit
 belongs_to   :employee
 belongs_to   :proyecto_minero

 belongs_to :supplier

 belongs_to :truck
 belongs_to :tecnic_revision

  validates_uniqueness_of :code
  validates_presence_of :tramit_id, :tipo_tramit_id,:fecha 




   def generate_number(serie)
    if Exmautoriz.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+Exmautoriz.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0') 
          
    end 
    
  end

  def get_empleado(id )
  

      if   a= Employee.where(id: id ).exists? and id != nil 

           category = Employee.find(id)

           return category.full_name
      else

           return "Empleado.."
      end 


  end 


def process
    if(self.processed == "1" or self.processed == true)          
      self.processed="1"
      self.date_processed = Time.now
      self.save
    end
  end
  



def get_processed
    if(self.processed == "1")
      return "Aprobado "

    elsif (self.processed == "2")
      
      return "**Anulado **"

    elsif (self.processed == "3")

      return "**Cancelado  **"  

    elsif (self.processed == "4")

      return "**Atendido  **" 
    else   
      return "Not yet processed"
        
    end
  end



  def get_proyecto_minero(id )
  

      if   a= ProyectoMinero.where(id: id ).exists? and id != nil 

           category = ProyectoMinero.find(id)

           return category.descrip
      else

           return "."
      end 


  end 

end
