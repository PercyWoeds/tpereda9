class ProyectoExam < ActiveRecord::Base

	belongs_to :proyecto_minero 
	
   

      has_many   :proyectoexam_details , :dependent => :destroy
      
      has_many   :proyecto_minero_exam 


	def self.import(file)
  
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
        

         pumps = ProyectoMineroExam.last 

          a = row['proyecto_minero_exam_id']

       @blanco  = " "

       proyecto_minero_exam_detail_id =  a

        b = ProyectoMineroExam.find(row['proyecto_minero_exam_id'])

        puts "proyecto_minero_exam_id"
        puts row['proyecto_minero_exam_id']


        if b 

        if pumps.get_formato_fecha(a) 
       

          proyectoexam_details =  ProyectoexamDetail.new(
                  proyecto_minero_exam_id:row['proyecto_minero_exam_id'] ,
                  fecha: row['valores'], 
                  observacion: @blanco,  
                  employee_id: row['employee_id']  , 
                  proyecto_exam_id: row['proyecto_exam_id'],
                  proyecto_minero_id: b.proyecto_minero_id)
        else 



         proyectoexam_details =  ProyectoexamDetail.new(
                       proyecto_minero_exam_id:row['proyecto_minero_exam_id'] ,
                  fecha: nil, 
                  observacion: row['valores'],  
                  employee_id: row['employee_id']  , 
                  proyecto_exam_id: row['proyecto_exam_id'],
                  proyecto_minero_id: b.proyecto_minero_id)

        end 

         proyectoexam_details.save

     else 

     	 puts "proyecto_minero_exam_id no existe "
         puts row['proyecto_minero_exam_id']



        end 
        end        
  end


end
