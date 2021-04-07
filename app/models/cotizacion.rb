class Cotizacion < ActiveRecord::Base

 belongs_to :customer
 belongs_to :punto
 belongs_to :tipocargue 
 belongs_to :tipo_unidad 
 belongs_to :config_vehi 
 belongs_to :tipocustomer 
 belongs_to :moneda 
 belongs_to :payment 

 validates_presence_of    :fecha, :code, :customer_id, :punto_id, :punto2_id, :moneda_id,
        :payment_id,
        :tipo_unidad,:especifica,:valorseguro,
        :tipo_unidad_id,
        :config_vehi_id,
        :descrip1,
        :fecha, :code, :customer_id, :punto_id, :punto2_id, :moneda_id,:payment_id,
        :tipo_unidad,:valorseguro,
        :tipo_unidad_id,
        :config_vehi_id,
        :descrip1,  
        :qty,
        :qty2,
        :qty3,
        :qty4,
        :qty5,
        :qty6,
        :price,
        :price2,
        :price3,
        :price4,
        :price5,
        :price6,
        :total,
        :total2,
        :total3,
        :total4,
        :total5,
        :total6
       



  validates_uniqueness_of :code
 

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

    a = TipoUnidad.find(id)
    return a.name 

 end



 def get_configvehi(id)
     
      a = ConfigVehi.find(id)
      return   a.name
 
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

  def self.search(search)
      where("code LIKE ?", "%#{search}%") 
        
  end





end
