class Assistance < ActiveRecord::Base

    belongs_to :inasist
    belongs_to :employee
    belongs_to :company

  
    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          	
          	str = row['fecha']

        
          	 if str.include?"a. m."		
          		row['fecha'] = Time.zone.parse(str.sub('a. m.','a.m.'))
          	else
				row['fecha'] = Time.zone.parse(str.sub('p. m.','p.m.'))
          	end
          	
          	puts "fecha **"
          	puts str	
          	puts row['fecha'] 

            Assistance.create! row.to_hash 

        end
    end     

 # Process the invoice
  def process(fecha)

   


      planilla  =Employee.where(planilla: "1")
      
      fecha_asistencia = fecha 
        Assistance.where("fecha >= ? and fecha <= ?", "#{fecha_asistencia}  00:00:00","#{fecha_asistencia} 23:59:59 ").delete_all 
        

      for ip in planilla
 
         hora10 = fecha_asistencia.in_time_zone.change( hour: 8) 
         hora20 = fecha_asistencia.in_time_zone.change( hour: 17 , min: 45 )
         hora30 = fecha_asistencia.in_time_zone.change( hour: 18 ,  min: 30 )


         
        a=  Assistance.new(departamento: "", nombre:"", employee_id: ip.id  , fecha:  fecha_asistencia, equipo:"", cod_verificacion: "",
          num_tarjeta:"",hora1: hora10 ,hora2: hora20, hora_efectivo: hora10 ,  hora_efectivo2: hora30 ,  inasist_id: "1" )
        
        a.save

        self.save
    

      end 
  end 

end
