class ProyectoExam < ActiveRecord::Base

	belongs_to :proyecto_minero 
	
   

      has_many   :proyectoexam_details , :dependent => :destroy
      
      has_many   :proyecto_minero_exam 


	def self.import(file)

		@company = Company.find(1)
  
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
        

         pumps = ProyectoMineroExam.last 

          a = row['proyecto_minero_exam_id']

       @blanco  = " "

       proyecto_minero_exam_detail_id =  a

        b = ProyectoMineroExam.find(row['proyecto_minero_exam_id'])

        puts "proyecto_minero_exam_id"
        puts row['proyecto_minero_exam_id']


        if ProyectoMineroExam.where(id: row['proyecto_minero_exam_id']).exists?



        if pumps.get_formato_fecha(a) 

            puts "fecha-..."

        	puts @fecha_valor 
        	puts pumps.get_formato_fecha(a) 

        	 if @company.col_is_date?(row['valores']) 

        	 	@fecha_valor = row['valores'].to_date 

        	 end     

	          proyectoexam_details =  ProyectoexamDetail.new(
	                  proyecto_minero_exam_id:row['proyecto_minero_exam_id'] ,
	                  fecha:  @fecha_valor , 
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
