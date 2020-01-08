class Assistance < ActiveRecord::Base

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

      for ip in planilla
 
         hora10 = fecha_asistencia.in_time_zone.change( hour: 8) 
         hora20 = fecha_asistencia.in_time_zone.change( hour: 17)
        
        a=  Assistance.new(departamento: "", nombre:"", nro:ip.idnumber , fecha:  fecha_asistencia, equipo:"", cod_verificacion: "",
          num_tarjeta:"",hora1: hora10 ,hora2: hora20, hora_efectivo: hora10 )
        
        a.save

        self.save
    

      end 
  end 

end
