class ProyectoMineroExam < ActiveRecord::Base

	validates_presence_of :proyecto_minero_id,:proyectominero2_id,:proyectominero3_id

    belongs_to :proyecto_minero
	belongs_to :proyectominero2
	belongs_to :proyectominero3

	belongs_to :proyecto_exam 
	



	 def get_formato_fecha(id)

	 	a =  Proyectominero3.find_by(id: id)

	 	if a.formatofecha == "1"

	 		return true 

	 	end 

	 	
	 end



end
