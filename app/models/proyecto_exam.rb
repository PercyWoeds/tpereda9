class ProyectoExam < ActiveRecord::Base

	belongs_to :proyecto_minero 
	
   

      has_many   :proyectoexam_details , :dependent => :destroy
end
