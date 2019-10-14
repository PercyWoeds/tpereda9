class Manifest < ActiveRecord::Base

belongs_to :customer 

belongs_to :company

belongs_to :location 
belongs_to :user 
belongs_to :punto 

belongs_to :tipocargue 

belongs_to :manifestship  


validates_presence_of :location_id, :code,:customer_id,:fecha1,:tipocargue_id,:especificacion,:fecha2,:direccion1,:direccion2,:contacto1,:telefono1,:contacto2,:telefono2
validates_uniqueness_of :code


  def get_customers()
    customers = Customer.order(:name)
    return customers
  end
 def get_puntos()
    puntos = Punto.all 
    return puntos
  end

 def get_cargas()
    puntos = Tipocargue.all 
    return puntos
  end

def get_locations()

    locations = Location.where(company_id: 1).order("name ASC")
    
    return locations
  end


def get_processed
    if(self.processed == "1")
      return "Aprobado "

    elsif (self.processed == "2")
      
      return "**Anulado **"

    elsif (self.processed == "3")

      return "-Cerrado --"  
    else   
      return "Not yet processed"
        
    end
  end
  
  def get_punto(id)
        a = Punto.find(id)
        
        if a != nil 
           return a.name
        else
           return "No existe "
        end 
   end 
   def correlativo      
        numero = Voided.find(16).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'16').update_all(:numero =>lcnumero)        
  end

  def process
    if(self.processed == "1" or self.processed == true)          
      self.processed="1"
      self.date_processed = Time.now
      self.save
    end
  end

  def generate_manifest_number(serie)
    if Manifest.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+Manifest.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0') 
          
    end 
    
  end


   def get_osts
    @itemguias = Manifestship.find_by_sql(['Select tranportorders.id,tranportorders.code ,tranportorders.fecha1
     from manifestships INNER JOIN tranportorders ON manifestships.tranportorder_id =  tranportorders.id where  manifestships.manifest_id = ?', self.id ])
    return @itemguias
  end

  
end
