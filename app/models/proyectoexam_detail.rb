class ProyectoexamDetail < ActiveRecord::Base

   
    
   self.per_page = 20

   belongs_to :proyecto_exam

end
