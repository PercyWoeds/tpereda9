class Cout < ActiveRecord::Base


validates_presence_of :tranportorder_id,:employee_id,:truck_id,:importe  



belongs_to :employee
belongs_to :truck 
belongs_to :tranportorder



  
   TABLE_HEADERS = [ "FECHA ",
                     "CONCEPTO",
                     "CANT",
                     "  ",
                     "COMPROBANTE",
                     "IMPORTE S/.",
                     "DETALLE"
                     ]




 def generate_cout_number
    if Cout.where("fecha  >?","2020-08-01 00:00:00")
    	.maximum("cast(substring(code,1,6)  as int)") == nil 
      	 self.code = "000001"
    else
   		 self.code = Cout.where("fecha  >?","2020-08-01 00:00:00").maximum("cast(substring(code,1,6)  as int)").next.to_s.rjust(6, '0') 
          
    end 
    
  end

  def textify

    

      number = self.monto_recibido.round(2)
      parts = number.to_s.split(".")
      cents = parts.count > 1 ? parts[1].to_s : 0
      importe = self.monto_recibido.round(2).to_i

     

      if cents.size  ==  1  
      cents = cents.to_s.rjust(1,'00') +"0"
      else
        cents = cents.to_s.rjust(2,'0')
      
      end

      text = I18n.with_locale("es") {importe.to_words}
        
      return "#{text} y #{cents}/100 "

    end




 def get_egresos_grupo
   
   @dato = Gasto.select("grupo ").where("grupo <> ?","").group(:grupo)

      return @dato 
 end 



private





end
