class ProyectoExam < ActiveRecord::Base

	belongs_to :proyecto_minero 
	
   

      has_many   :proyectoexam_details , :dependent => :destroy
      
      has_many   :proyecto_minero_exam 

end
