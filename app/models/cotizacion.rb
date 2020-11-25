class Cotizacion < ActiveRecord::Base

 belongs_to :customer
 belongs_to :punto
 belongs_to :tipocargue 
 belongs_to :tipo_unidad 
 belongs_to :config_vehi 
 

   TABLE_HEADERS = ["Nro.Item",
                    "FECHA COTIZACION",
                     "NRO.COTIZACION",
                     "CLIENTE",
                     "ORIGEN",
                     "DESTINO",
                     "TIPO DE CARGA",
                     "TIPO DE UNIDADES.",
                     "TARIFA",
                     "ESTADO DEL SERVICIO",
                     "OBSERVACIONES"]



 def get_punto(punto)

 	a = Punto.find(punto)
 	return a.name 
 	
 end



 def get_tipounidad(id)

  if !id.nil?

    a = TipoUnidad.find(id)
    return a.name 
  else
     return ""
  end 
 end



 def get_configvehi(id)

  ret = ""

  if   !id.nil? 
     
      a = ConfigVehi.find(id)
      ret = a.name
 
  end
  return ret 
end 



def get_processed
    if(self.processed == "1")
      return "Aprobado "

    elsif (self.processed == "2")
      
      return "**Rechazado **"

    elsif (self.processed == "3")

      return "**Cancelado  **"  

    elsif (self.processed == "4")

      return "**Atendido  **" 
    else   
      return "Not yet processed"
        
    end
  end
  

  def process
    if(self.processed == "1" or self.processed == true)          
      self.processed="1"
      self.date_processed = Time.now
      self.save
    end
  end


  def generate_number(serie)
    if Cotizacion.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+ Cotizacion.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0')          
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
