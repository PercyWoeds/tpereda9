class Inasist < ActiveRecord::Base

	belongs_to :assistance 

	validates_uniqueness_of :code
    validates_presence_of :code, :name 
   

    
 def get_horas_minutos(concepto,fecha1,fecha2)


        @detalle = Assistance.where("inasist_id=? and fecha>=? and fecha<=?", concepto ,"#{fecha1} 00:00:00","#{fecha2} 23:59:59")
        total_horas = 0
        total_minutos = 0 

        for detalle in @detalle


          if detalle.inasist_id == 4  
 
                   fecha_hora = fecha1
                  fechas = fecha_hora.to_time

                  a=fechas.in_time_zone.change( hour: 8 )  

                  b = detalle.hora_efectivo.in_time_zone.change( day: fechas.day,month:fechas.month )
               

              


                  horas =  detalle.time_diff( a , b )

                  parts = horas.split(":")  
                  hora_1   =  parts[0].to_f
                  minuto_1 =  parts[1].to_f
                 
                  

                  total_horas +=  hora_1 
                  total_minutos += minuto_1

          elsif(detalle.inasist_id == 2 || detalle.inasist_id == 6  )   

            
                 fecha_hora = fecha1
                fechas = fecha_hora.to_time

                a=fechas.in_time_zone.change( hour: 18 ,  min: 30 )

                puts "horas vacaciones "
                puts a 

                b = detalle.hora_efectivo2.in_time_zone.change( day: fechas.day,month:fechas.month )
             

                puts b 


                horas =  detalle.time_diff( a , b )

                parts = horas.split(":")  
                hora_1   =  parts[0].to_f
                minuto_1 =  parts[1].to_f
               
                puts horas 
                puts hora_1
                puts minuto_1

                total_horas +=  hora_1 
                total_minutos += minuto_1

          else   

          detalle.hora2 =  detalle.hora2.in_time_zone.change( hour: 17 ,  min: 00 )   
          horas =  detalle.time_diff(detalle.hora1,detalle.hora2)
          parts = horas.split(":")  
          hora_1   =  parts[0].to_f
          minuto_1 =  parts[1].to_f
        

          total_horas +=  hora_1 
          total_minutos += minuto_1 
          end 
        end 

        return total_horas + total_minutos / 60 
   
 end
end
