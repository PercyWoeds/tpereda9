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
                puts total_horas

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



  def contar_dias(fecha1,fecha2,tipo)

      ret = 0


      a = fecha1.in_time_zone.change( hour: 8 ,  min: 00 )     
      b = fecha2.in_time_zone.change( hour: 18 , min: 30 )     

      @asistencia = Assistance.where("inasist_id = ? and fecha>=? and fecha<=? ", tipo,"#{fecha1} 00:00:00","#{fecha2} 23:59:59" )

        for a in @asistencia 

          hora1 =  a.hora_efectivo::time 
          hora2 =  a.hora_efectivo2::time 
puts "asssssssssssssssssssssssssssssssssss"

            puts hora1
            puts hora2

          if hora1.nil?
            hora10 = "00:00:00"
          else 
            hora10 = hora1.to_s

          end
          if hora2.nil?
              hora10 ="00:00:00"
          else 
            hora20 = hora2.to_s
          end 
          
           
            puts hora10[11..18]
            puts hora20[11..18]




            if hora10[11..18] == "08:00:00" and hora20[11..18] =="18:30:00" 

              ret +=1 
              puts "holiiii"

              puts tipo 
              puts ret 
             end 



        end

        return ret
    
  end

end
