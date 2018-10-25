class Quotation < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :company_id, :customer_id, :punto_id,:fecha1,:division_id 
  validates_uniqueness_of :code
  
  belongs_to :customer 
  belongs_to :company 
  belongs_to :location
  belongs_to :division 
  belongs_to :moneda 
  belongs_to :user  
  belongs_to :punto 
  TABLE_HEADERS = ["Tipo de Unidad e Importe del Servicio",
                      "Costo Total "]

  
  
 def correlativo
        
        numero = Voided.find(9).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'9').update_all(:numero =>lcnumero)        
  end
 # Color for processed or not
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
    else
      return "No"
    end
  end
def get_processed
    if(self.processed == "1")
      return "Procesado"
    else
      return "No Procesado"
    end
  end
  
  
    def get_products()   
          @itemservices = Quotation.where(id: self.id) 
        return @itemservices
    end
    
   # Process the invoice
  def process
    if(self.processed == "1" or self.processed == true)          
      self.processed="1"
      self.date_processed = Time.now
      self.save
    end
  end
  
  def anular
    if(self.processed == "2" )          
      self.processed="2"
     
      self.importe = 0
      
      self.date_processed = Time.now
      self.save
    end
  end
  
end
