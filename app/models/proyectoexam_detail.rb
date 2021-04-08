class ProyectoexamDetail < ActiveRecord::Base

   
    
   self.per_page = 20

   belongs_to :proyecto_exam
   belongs_to :proyecto_minero_exam 
   belongs_to :employee 

 

   def get_detalle(empleado,proyecto_minero )

   	  datos = ProyectoexamDetail.where(proyecto_minero_id: proyecto_minero, employee_id: empleado)
   	    return datos 

   	
   end



end
