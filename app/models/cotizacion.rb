class Cotizacion < ActiveRecord::Base

 belongs_to :customer
 belongs_to :punto
 belongs_to :tipocargue 
 

 def get_punto(punto)

 	a = Punto.find(punto)
 	return a.name 
 	
 end
  


  def generate_number(serie)
    if Cotizacion.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+ Cotizacion.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0')          
    end 
    
  end


def get_processed
    if(self.processed == "1")
      return "Aprobado "

    elsif (self.processed == "2")
      
      return "**Anulado **"

    elsif (self.processed == "3")

      return "-Cancelado --"  
    else   
      return "Not yet processed"
        
    end
  end


 def anular
    if(self.processed == "2" )          
      self.processed="2"
      self.tarifa =0
      
      self.date_processed = Time.now
      self.save
    end
  end
 def cancelar 
    if(self.processed == "2" )          
      self.processed="2"
      self.tarifa =0
      
      self.date_processed = Time.now
      self.save
    end
  end



end
