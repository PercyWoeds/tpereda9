class PaymentNotice < ActiveRecord::Base
    belongs_to :supplier 
    belongs_to :employee

	 has_many :paymentnotice_details, :dependent => :destroy 

   validates_uniqueness_of :code 



	
 TABLE_HEADERS = [ "Nro.",
                   "PROYECTO MINERO ",
                   "CONTACTO",
                   "CORREO ELECTRONICO",
                   "TELEFONO"
                   ]


 TABLE_HEADERS2 = [ "ITEM",
                   "Fec.Inicio",
                   "Fec.Culmina ",
                   "Cant.",
                   "DESCRIPCIÓN",
                   "LUGAR",
                   "PRECIO UNITARIO",
                   "SUB TOTAL"   ,
                   "IGV" ,
                   "TOTAL",
                   "N° DE COMPROBANTE",
                   "N°DE DOCUMENTO",
                   "OBSERVACIÓN"    ]

 
	def generate_rq_number(serie)

    if PaymentNotice.where("cast(substring(code,5,4)  as int) = ?",serie).maximum("cast(substring(code,1,3)  as int)") == nil 
      self.code ="001"+"-"+serie.to_s.rjust(4, '0') +"-AP-TP"
    else
      self.code = PaymentNotice.where("cast(substring(code,5,4) as int) = ?",serie).maximum("cast(substring(code,1,3)  as int)").next.to_s.rjust(3,'0') + "-" + serie.to_s + "-AP-TP"
	  end 
  end 

   def process
    if(self.processed == "1" or self.processed == true)          
      self.processed="1"
      self.date_processed = Time.now
      self.save
    end
  end
   def add_products(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        

        fecha_inicio = parts[0]
        fecha_culmina = parts[1]
        qty  = parts[2]
        descrip  = parts[3]
        lugar = parts[4]
        price_unit = parts[5]
        pm = parts[6]
        nro_compro  = parts[7]
        nro_documento   = parts[8]
        observa  = parts[9]

        total = price_unit.to_f * qty.to_f


       
        begin
          
         
          product = PaymentnoticeDetail.new 
          product[:fecha_inicio] = fecha_inicio
          product[:fecha_culmina] = fecha_culmina
          product[:qty] = qty.to_f
          product[:descrip] = descrip
          product[:lugar] = lugar
          product[:price_unit] = price_unit.to_f
          product[:total] = total.to_f
          product[:igv] = total.to_f / 1.18
          product[:sub_total] = product[:total] - product[:igv]
          product[:nro_compro] = nro_compro
          product[:nro_documento] = nro_documento
          product[:observa] = observa 
          product[:proyecto_minero_id] = pm 
          product[:payment_notice_id] = self.id 
  
          product.save

      

          
        end



      end
    end
  end

 def get_products    
    @itemproducts = PaymentNotice.select("paymentnotice_details.*").joins(:paymentnotice_details).where("payment_notice_id = ?",self.id )
    return @itemproducts
  end
  



  def get_total(items)
  
    
   
    ret = 0
    
   for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        

        fecha_inicio = parts[0]
        fecha_culmina = parts[1]
        qty  = parts[2]
        descrip  = parts[3]
        lugar = parts[4]
        price_unit = parts[5]
        pm = parts[6]
        nro_compro  = parts[7]
        nro_documento   = parts[8]
        observa  = parts[9]

        total = price_unit.to_f * qty.to_f


        return total.round(2)

      end
    end
  end
  


  def get_processed
    if(self.processed == "1")
      return "Aprobado "

    elsif (self.processed == "2")
      
      return "**Anulado **"

    elsif (self.processed == "3")

      return "-Cerrado --"  

    elsif (self.processed == "4")

      return "-Facturado --"  

    else   
      return "No Aprobado"
        
    end
  end


  def process
    if(self.processed == "1" or self.processed == true)          
      self.processed="1"
      self.date_processed = Time.now
      self.save
    end
  end
  def cerrar
    if(self.processed == "3" )         
      
      self.processed="3"
      self.date_processed = Time.now
      self.save
    end
  end

  
  # Process the invoice
  def anular
    puts self.processed
    
    if(self.processed == "2" )          
      self.processed="2"
    
      self.total = 0
     
      self.date_processed = Time.now
      self.save
    end
  end

  def processed_color
    if(self.processed == "1")
      return "green"
    else
      return "red"
    end
  end

  def get_processed_short
    if(self.processed == "1")
      return "Si"
    elsif (self.processed == "3")
       return "Si"
    else
      return "No"
    end
  end
   
end
