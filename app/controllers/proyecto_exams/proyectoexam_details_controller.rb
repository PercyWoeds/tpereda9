class ProyectoExams::ProyectoexamDetailsController < ApplicationController

  
  before_action :set_proyecto_exam, :except=> [:update]
   
  before_action :set_proyectoexam_detail, :except=> [:new,:create,:update]
   
  
  # GET /proyectoexam_details
  # GET /proyectoexam_details.json
  def index
    @proyectoexam_details = ProyectoexamDetail.all
  end

  # GET /proyectoexam_details/1
  # GET /proyectoexam_details/1.json
  def show

      @company= Company.find(1)

      @employees = @company.get_employees2()

  end

  # GET /proyectoexam_details/new
  def new

 @company= Company.find(1)

    @proyectoexam_detail = ProyectoexamDetail.new

     @employees = @company.get_employees2()
    proyecto_exam = ProyectoExam.find(params[:proyecto_exam_id]) 
  
    @detalle = ProyectoMineroExam.where(proyecto_minero_id: proyecto_exam.proyecto_minero_id).order(:orden)


  end

  # GET /proyectoexam_details/1/edit
  def edit
    @company = Company.find(1)
    @employees = @company.get_employees2()



    puts "ssss"

    puts params[:proyecto_exam_id]
    puts params[:employee_id]

    proyecto_exam_id = params[:proyecto_exam_id]
    


    @detalle = ProyectoexamDetail.where(proyecto_exam_id: params[:proyecto_exam_id],
                                 employee_id: params[:employee_id])

    
    @pumps = ProyectoMineroExam.where(proyecto_minero_id: params[:proyecto_minero_id] ).order(:orden)
    
    @cols = @pumps.count 

    @valor  = Array.new(2) { Array.new(@cols) { "" } }
    
    for i in 0..0 do

       for pumps in @pumps do

        @valor[i].push(pumps.proyectominero2.name)

       end 

    end 
   
    for i in 1..1 do
      
      for pumps in @pumps do

        @valor[i].push(pumps.proyectominero3.name )

       end 

    end 

    @empleado = Employee.find(params[:employee_id])


  end

  # POST /proyectoexam_details
  # POST /proyectoexam_details.json
  def create


    @company = Company.find(1)
    @employees = @company.get_employees2()


    proyecto_minero_id = params[:proyecto_minero_id]

    proyecto_exam_id = params[:proyecto_exam_id]



    a =  ProyectoExam.find(proyecto_exam_id)

    proyecto_minero_id = a.proyecto_minero_id

    
    
    empleado_id = params[:proyectoexam_detail][:employee_id]
     

    puts "********************** create proyecto details ----"
    puts proyecto_minero_id
    puts proyecto_exam_id 
    puts empleado_id


     @pumps = ProyectoMineroExam.where(proyecto_minero_id: proyecto_minero_id).order(:orden)
    items_arr = []
    @products = []
    i = 0
    qty = 0 
    total_qty   = 0

    totales_qty = 0
    totales_gln = 0
    puts "empleado.+++++++++"
    puts empleado_id

   

    a = ProyectoexamDetail.where(employee_id: empleado_id, proyecto_exam_id: proyecto_exam_id).delete_all 
              
  

   
     i = 0
    
      for pumps in @pumps do

        
       a = pumps.proyectominero3_id

       @blanco  = " "

       proyecto_minero_exam_detail_id = pumps.id 



        if pumps.get_formato_fecha(a) 

          puts "graba detalle fecha++++++++++++++++++++++ "

          method_body = "field_" << a.to_s 

          puts  method_body
          puts params[method_body]
          puts @blanco

          parts = ""
          parts_value =  ""

          params.each do |key,value|
               Rails.logger.warn "Param #{key}: #{value}"

                 campo = "#{key}"

               if campo[0..5]  == "field_" and campo[6..7].to_i == proyecto_minero_exam_detail_id

                 parts_id = campo[6..7].to_i 
                 parts_value = "#{value}".to_date

                  puts "field obs++++++++++++++++++"
                puts campo[0..5] 
                puts campo[6..7]
                puts parts_value

               end 




          end



          proyectoexam_details =  ProyectoexamDetail.new(
                  proyecto_minero_exam_id:proyecto_minero_exam_detail_id ,
                  fecha: parts_value, 
                  observacion: "",  
                  employee_id: empleado_id  , 
                  proyecto_exam_id: proyecto_exam_id,
                  proyecto_minero_id: proyecto_minero_id,
                  active: "1" )
        else 


          puts "graba detalle observacion "
          puts parts[i]
          puts @blanco 


          parts = ""
          parts_value =  ""
          
          params.each do |key,value|
               Rails.logger.warn "Param #{key}: #{value}"

                 campo = "#{key}"

               if campo[0..5]  == "field_" and campo[6..7].to_i == proyecto_minero_exam_detail_id

                puts "field obs++++++++++++++++++"
                puts campo[0..5] 
                puts campo[6..7]

                 parts_id = campo[6..7].to_i 
                 parts_value = "#{value}"

               end 


          end


         proyectoexam_details =  ProyectoexamDetail.new(
                    proyecto_minero_exam_id: proyecto_minero_exam_detail_id,
                    fecha: nil, 
                    observacion: parts_value, 
                    employee_id: empleado_id  ,
                    proyecto_exam_id: proyecto_exam_id,
                    proyecto_minero_id: proyecto_minero_id,
                    active:  "1" )

        end 

         proyectoexam_details.save
       i += 1

       end 



    
    respond_to do |format|
       format.html { redirect_to "/proyecto_exams/#{proyecto_exam_id}", notice: 'Proyecto Exam detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @proyect_exam }
     
    end


  end

  # PATCH/PUT /proyectoexam_details/1
  # PATCH/PUT /proyectoexam_details/1.json
  def update


    @company = Company.find(1)
    @employees = @company.get_employees2()




    proyecto_exam_id = params[:proyecto_exam_id]

    a = ProyectoexamDetail.find(params[:id])

    empleado_id = a.employee_id
   
    a =  ProyectoExam.find(proyecto_exam_id)

    proyecto_minero_id = a.proyecto_minero_id


     @pumps = ProyectoMineroExam.where(proyecto_minero_id: proyecto_minero_id)
    items_arr = []
    @products = []
    i = 0
    qty = 0 
    total_qty   = 0

    totales_qty = 0
    totales_gln = 0
    puts "empleado.+++++++++"
    puts empleado_id


    active = params[:proyectoexam_detail][:active]

    puts "valor activo ??? "

    puts active 
   

    a = ProyectoexamDetail.where(employee_id: empleado_id, proyecto_exam_id: proyecto_exam_id).delete_all 
              
  

   
     i = 0
    
      for pumps in @pumps do

        
       a = pumps.proyectominero3_id

       @blanco  = " "

       proyecto_minero_exam_detail_id = pumps.id 



        if pumps.get_formato_fecha(a) 

          puts "graba detalle fecha++++++++++++++++++++++ "

          method_body = "field_" << a.to_s 

          puts  method_body
          puts params[method_body]
          puts @blanco

          parts = ""
          parts_value =  ""

          params.each do |key,value|
               Rails.logger.warn "Param #{key}: #{value}"

                 campo = "#{key}"

               if campo[0..5]  == "field_" and campo[6..7].to_i == proyecto_minero_exam_detail_id

                 parts_id = campo[6..7].to_i 
                 parts_value = "#{value}".to_date

                  puts "field obs++++++++++++++++++"
                puts campo[0..5] 
                puts campo[6..7]
                puts parts_value

               end 




          end



          proyectoexam_details =  ProyectoexamDetail.new(
                  proyecto_minero_exam_id:proyecto_minero_exam_detail_id ,
                  fecha: parts_value, 
                  observacion: "",  
                  employee_id: empleado_id  , 
                  proyecto_exam_id: proyecto_exam_id,
                  proyecto_minero_id: proyecto_minero_id,
                  active: active  )


        else 


          puts "graba detalle observacion "
          puts parts[i]
          puts @blanco 


          parts = ""
          parts_value =  ""
          
          params.each do |key,value|
               Rails.logger.warn "Param #{key}: #{value}"

                 campo = "#{key}"

               if campo[0..5]  == "field_" and campo[6..7].to_i == proyecto_minero_exam_detail_id

                puts "field obs++++++++++++++++++"
                puts campo[0..5] 
                puts campo[6..7]

                 parts_id = campo[6..7].to_i 
                 parts_value = "#{value}"

               end 


          end


         proyectoexam_details =  ProyectoexamDetail.new(
                    proyecto_minero_exam_id: proyecto_minero_exam_detail_id,
                    fecha: nil, 
                    observacion: parts_value, 
                    employee_id: empleado_id  ,
                    proyecto_exam_id: proyecto_exam_id,
                    proyecto_minero_id: proyecto_minero_id,
                    active: active  )

        end 

         

         proyectoexam_details.save
         ProyectoexamDetail.where( employee_id: empleado_id ).update_all(active: active )

       i += 1

       end 



     

        
    
    respond_to do |format|
     
        format.html { redirect_to "/proyecto_exams/#{proyecto_exam_id}", notice: 'Proyecto Exam detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @proyect_exam }
     
    end
  end

  # DELETE /proyectoexam_details/1
  # DELETE /proyectoexam_details/1.json
  def destroy
     @proyectoexam_detail.destroy
    
     $lcGalones = @Proyectoexam.get_importe_1("galones")
     $lcImporte = @Proyectoexam.get_importe_1("total")
     
     @proyectoexam.update_attributes(galones:  $lcGalones ,importe: $lcImporte )
            
    respond_to do |format|
      format.html { redirect_to proyectoexams_url, notice: 'Proyecto Exam detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    
    # Use callbacks to share common setup or constraints between actions.
   
    # Never trust parameters from the scary internet, only allow the white list through.



    def set_proyecto_exam
      @proyecto_exam  = ProyectoExam.find(params[:proyecto_exam_id])
      
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_proyectoexam_detail
      @proyectoexam_detail = ProyectoexamDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proyectoexam_detail_params
      params.require(:proyectoexam_detail).permit(:proyecto_minero_exam_id, :fecha, :employee_id ,
      :proyecto_exam_id , :proyecto_minero_id , :observacion,:active )
    end
end

    