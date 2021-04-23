



 			@proyecto_exam   = ProyectoExam.order(:id).all 


			 for detalle0 in @proyecto_exam 


			 	#proyecto minero y empleados 

			       	@proyecto_exam_empleado = ProyectoexamDetail.select("employee_id,proyecto_exam_id")
			       	.where(proyecto_exam_id: @proyecto_exam.id,active: "1")
			       	.group(:employee_id,:proyecto_exam_id)
  

					 for detalle in @proyecto_exam_empleado


						@examenes = ProyectoMineroExam.where(detalle0.proyecto_minero_id )


					 	for exam in @examenes


					 	 if !ProyectoexamDetail.where(proyecto_exam_id: @proyecto_exam.id , 
					 	 	employee_id: detalle.employee_id,
					 	 	proyecto_minero_id: @proyecto_exam.proyecto_minero_id,
					 	 	proyecto_minero_exam_id: exam.id ).exists 

					          proyectoexam_details =  ProyectoexamDetail.new(
					                  proyecto_minero_exam_id: exam.id ,
					                  fecha: nil, 
					                  observacion: "",  
					                  employee_id: detalle.employee_id  , 
					                  proyecto_exam_id: @proyecto_exam.id,
					                  proyecto_minero_id: @proyecto_exam.proyecto_minero_id,
					                  active: "1" )

					 	    proyectoexam_details.save


					 	  end 

					 	 end 

					 end 

			end 
