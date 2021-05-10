class ProyectoExamsController < ApplicationController
  before_action :set_proyecto_exam, only: [:show, :edit, :update, :destroy]

  # GET /proyecto_exams
  # GET /proyecto_exams.json
  def index
    @proyecto_exams = ProyectoExam.all

  end

  # GET /proyecto_exams/1
  # GET /proyecto_exams/1.json
  def show
    @company = Company.find(1)
    @employees = @company.get_employees2()
    @proyecto_examen  = @company.get_proyecto_exams

    @proyecto_examen_empleado = @company.get_proyecto_exam_empleado(@proyecto_exam.id)

    @proyectoexam_details= @proyecto_exam.proyectoexam_details


    @rows = 2

    @pumps = ProyectoMineroExam.where(proyecto_minero_id: @proyecto_exam.proyecto_minero_id).order(:orden)
    
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


    @proyecto_minero_id = @proyecto_exam.proyecto_minero_id 
    @proyecto_exam_id = @proyecto_exam.id

    puts "show"
    puts  @proyecto_minero_id
    

  end

  # GET /proyecto_exams/new
  def new

    @company = Company.find(1)
    @proyecto_exam = ProyectoExam.new
    @employees = @company.get_employees2()
    @proyecto_examen = @company.get_pm()
    

  end

  # GET /proyecto_exams/1/edit
  def edit

    @company = Company.find(1)
    @employees = @company.get_employees2()
    @proyecto_examen   = @company.get_pm()
    @employees = @company.get_employees()
    
  end

  # POST /proyecto_exams
  # POST /proyecto_exams.json
  def create
    @proyecto_exam = ProyectoExam.new(proyecto_exam_params)
     @company = Company.find(1)
    @employees = @company.get_employees()
    @proyecto_examen  = @company.get_pm()

    respond_to do |format|
      if @proyecto_exam.save
        format.html { redirect_to @proyecto_exam, notice: 'Proyecto exam was successfully created.' }
        format.json { render :show, status: :created, location: @proyecto_exam }
      else
        format.html { render :new }
        format.json { render json: @proyecto_exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proyecto_exams/1
  # PATCH/PUT /proyecto_exams/1.json
  def update

    @company = Company.find(1)
    @employees = @company.get_employees()
    @proyecto_examen   = @company.get_proyecto_exams


    respond_to do |format|
      if @proyecto_exam.update(proyecto_exam_params)
        format.html { redirect_to @proyecto_exam, notice: 'Proyecto exam was successfully updated.' }
        format.json { render :show, status: :ok, location: @proyecto_exam }
      else
        format.html { render :edit }
        format.json { render json: @proyecto_exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proyecto_exams/1
  # DELETE /proyecto_exams/1.json
  def destroy


    @proyecto_exam.destroy
    respond_to do |format|
      format.html { redirect_to proyecto_exams_url, notice: 'Proyecto exam was successfully destroyed.' }
      format.json { head :no_content }
    end
  end




  
  def do_grabar 

    proyecto_minero_id = params[:proyecto_minero_id]
    proyecto_exam_id = params[:proyecto_exam_id]
    empleado_id = params[:empleado_id]

    items = params[:items]


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

   

    #a = ProyectoexamDetail.where(employee_id: empleado_id, proyecto_exam_id: proyecto_exam_id).delete_all 
              
  

   
     i = 0
     parts = items.split("|BRK|")
    


      for pumps in @pumps do

        
       a = pumps.proyectominero3_id

       @blanco  = " "

       proyecto_minero_exam_detail_id = pumps.id 

        if pumps.get_formato_fecha(a) 

          puts "graba detalle fecha "
          puts parts[i]
          puts @blanco


          proyectoexam_details =  ProyectoexamDetail.new(
                  proyecto_minero_exam_id:proyecto_minero_exam_detail_id ,
                  fecha: parts[i], 
                  observacion: @blanco,  
                  employee_id: empleado_id  , 
                  proyecto_exam_id: proyecto_exam_id,
                  proyecto_minero_id: proyecto_minero_id )
        else 


          puts "graba detalle observacion "
          puts parts[i]
          puts @blanco 

         proyectoexam_details =  ProyectoexamDetail.new(
                    proyecto_minero_exam_id: proyecto_minero_exam_detail_id,
                    fecha: nil, 
                    observacion: parts[i] , 
                    employee_id: empleado_id  ,
                    proyecto_exam_id: proyecto_exam_id,
                    proyecto_minero_id: proyecto_minero_id )

        end 

         proyectoexam_details.save
       i += 1

       end 


    
    #   respond_to do |format|

    #     puts "rutaaaaa"
    #   format.html { redirect_to  "/proyecto_exams/#{proyecto_exam_id}", notice: 'Proyecto exam was successfully destroyed.' }
     
    # end


     

     # ventaislacab = Ventaisla.find(ventaisla_id)
     #ventaislacab.update_attributes(importe: totales_qty , galones: totales_gln )
      # render :layout => false
  end
  

 def pdf


   @proyecto_exam  = ProyectoExam.find(params[:id])
    company = Company.find(1)
    @company =Company.find(company)
    @cabecera ="Facturacion"
    @abajo    ="Examen "

    @pumps = ProyectoMineroExam.where(proyecto_minero_id: @proyecto_exam.proyecto_minero_id).order(:orden)


   @proyecto_examen_empleado = @company.get_proyecto_exam_empleado(@proyecto_exam.proyecto_minero_id) 

    @cols = @pumps.count 
     
      begin 
        

        render  pdf: "rpt_proyecto_exam_01",template: "proyecto_exams/rpt_proyecto_exam_01.pdf.erb",
        locals: {:proyecto_exam => @proyecto_exam} ,
         :orientation => 'Landscape',
           :page_size => 'A3', 
           :header => {
           :spacing => 5,
                           :html => {
                           :template => 'layouts/pdf-header10.html', 
                           right: '[page] of [topage]'
                  }
               },

               :footer => { :html => { template: 'layouts/pdf-footers.html' }       }  ,   
               :margin => {bottom: 35} 
                
       end   

    
  end


  def rpt_examen01


    

  end 




  def import
      ProyectoExam.import(params[:file])
       redirect_to root_url, notice: "Informacion importadas."
  end 
  



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proyecto_exam
      @proyecto_exam = ProyectoExam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proyecto_exam_params
      params.require(:proyecto_exam).permit(:employee_id, :proyecto_minero_id,:proyecto_minero_exam_id ,:observacion)
    end
end
