class ProyectoexamDetail < ActiveRecord::Base

   
    
   self.per_page = 20

   belongs_to :proyecto_exam
   belongs_to :proyecto_minero_exam 
   belongs_to :employee 


   
    validates_presence_of :employee_id ,:proyecto_minero_exam_id , :proyecto_minero_id , :proyecto_exam_id
 

   def get_detalle(empleado,proyecto_minero )

   	  datos = ProyectoexamDetail.where(proyecto_minero_id: proyecto_minero, employee_id: empleado)
   	    return datos 

   	
   end
   

   def  get_empleado_active (id)
           

        a =    ProyectoexamDetail.find_by(employee_id: id )

           
      return a.active 

   end 


   def active_status


         product =    ProyectoexamDetail.find_by(employee_id: id ) 
          if product 
            if product.active == "1"
              "glyphicon glyphicon-ok text-success"
            else
              "glyphicon glyphicon-minus text-danger"
            end

          else
           "glyphicon glyphicon-minus text-danger"
          end 

   end 


end
