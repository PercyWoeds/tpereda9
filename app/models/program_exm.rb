class ProgramExm < ActiveRecord::Base



     attr_accessible :codigo, :qty, :unidad_id, :descrip, :placa_destino, :rqdetails_attributes
	 belongs_to :requerimiento 
	 belongs_to :unidad 


	def get_atendido
		if(self.atento == "1")
		  return "Aprobado "
	
		elsif (self.atento == "2")
		  
		  return "**Anulado * "
		else   
		  return "Pendiente "
			
		end
	end

	
end
