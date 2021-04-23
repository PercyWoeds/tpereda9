 


 @proyecto_minero = ProyectoMinero.order(:id)


 for detalle in @proyecto_minero

      a = ProyectoMineroExam.new(proyecto_minero_id: detalle.id , proyectominero2_id: 1, proyectominero3_id: 1)
      a.save


      a = ProyectoMineroExam.new(proyecto_minero_id: detalle.id , proyectominero2_id: 1, proyectominero3_id: 2)
 
      a.save 

      a = ProyectoMineroExam.new(proyecto_minero_id: detalle.id , proyectominero2_id: 1, proyectominero3_id: 3)
 	  a.save 



 end 



  ProyectoMineroExam.







