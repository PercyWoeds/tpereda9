class ProyectoMineroExam < ActiveRecord::Base

	validates_presence_of :proyecto_minero_id,:proyectominero2_id,:proyectominero3_id

    belongs_to :proyecto_minero
	belongs_to :proyectominero2
	belongs_to :proyectominero3

	belongs_to :proyecto_exam 
	



	 def get_formato_fecha(id)

	 


	 	if Proyectominero3.where(id: id).exists?


            a =  Proyectominero3.find(id)

	 		if a.formatofecha == "1"

	 			return true 

	 		else

	 			return false 

	 		end
	 	else 
	 		return false 

	 	end 

	 	
	 end



def aplica 


 @proyecto_minero = ProyectoMinero.order(:id).where("id < 9 ")


		 # for detalle in @proyecto_minero

		 #      a = ProyectoMineroExam.new(proyecto_minero_id: detalle.id , proyectominero2_id: 1, proyectominero3_id: 1)
		 #      a.save


		 #      a = ProyectoMineroExam.new(proyecto_minero_id: detalle.id , proyectominero2_id: 1, proyectominero3_id: 2)
		 
		 #      a.save 

		 #      a = ProyectoMineroExam.new(proyecto_minero_id: detalle.id , proyectominero2_id: 1, proyectominero3_id: 3)
		 # 	  a.save 


   #     a = ProyectoMineroExam.new(proyecto_minero_id: detalle.id , proyectominero2_id: 1, proyectominero3_id: 1)
		 #      a.save


		 #      a = ProyectoMineroExam.new(proyecto_minero_id: detalle.id , proyectominero2_id: 1, proyectominero3_id: 2)
		 
		 #      a.save 

		 #      a = ProyectoMineroExam.new(proyecto_minero_id: detalle.id , proyectominero2_id: 1, proyectominero3_id: 3)
		 # 	  a.save 



		 # end 



 			@proyecto_minero = ProyectoMinero.order(:id)


			 for detalle in @proyecto_minero

			        @proyecto_minero_exam =  ProyectoMineroExam.order(:id).where(proyecto_minero_id: detalle.id )
			         orden_ex = 1 

					 for detalle in @proyecto_minero_exam 

					 	   detalle.update_attributes(orden: orden_ex )

					 	   orden_ex  += 1 
					 end 

			end 





end


def actualiza 

 			@proyecto_exam   = ProyectoExam.all 


			 for det in @proyecto_exam 

			 	#proyecto minero y empleados 

			       @proyecto_exam_empleado = ProyectoexamDetail.select("employee_id,proyecto_exam_id").where(proyecto_exam_id: @proyecto_exam.id,active: "1").group(:employee_id,:proyecto_exam_id)
  

					 for detalle in @proyecto_exam_empleado


						@examenes = ProyectoMineroExam.where(det.proyecto_minero_id )


					 	for exam in @examenes


					 	 if !ProyectoexamDetail.where(proyecto_exam_id: det.id , 
					 	 	employee_id: detalle.employee_id,
					 	 	proyecto_minero_id: det.proyecto_minero_id,
					 	 	proyecto_minero_exam_id: exam.id ).exists 

					          proyectoexam_details =  ProyectoexamDetail.new(
					                  proyecto_minero_exam_id: exam.id ,
					                  fecha: nil, 
					                  observacion: "",  
					                  employee_id: detalle.employee_id  , 
					                  proyecto_exam_id: det.id,
					                  proyecto_minero_id: det.proyecto_minero_id,
					                  active: "1" )

					 	    proyectoexam_details.save


					 	  end 

					 	 end 

					 end 

			end 

end 



end
