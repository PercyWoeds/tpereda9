class Cout < ActiveRecord::Base

self.primary_key = 'id'
validates_presence_of  :employee_id,:truck_id,:importe,:tbk,:tbk_documento,:truck2_id,:truck3_id   



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

       monto_recibido_last = self.importe + self.tbk 

      number = monto_recibido_last.round(2)
      parts = number.to_s.split(".")
      cents = parts.count > 1 ? parts[1].to_s : 0
      importe = monto_recibido_last.round(2).to_i

     

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



  def get_employee(codigo)

      if   Employee.exists?(:id=> codigo)
           empleados = Employee.find(codigo)
           return empleados.full_name
      else
           return ""
      end 
    end



    def get_punto(id)
      punto = Punto.find(id)
      return punto.name 

    end   


    
    def get_placa(id)
      placa = Truck.find(id)
      return placa.placa

    end   

private





end
