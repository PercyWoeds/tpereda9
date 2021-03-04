class ProyectoExams::ProyectoexamDetailsController < ApplicationController
    
  before_action :set_proyecto_exams
  before_action :set_proyectoexam_detail, except: [:new, :create]
  
  
  # GET /proyectoexam_details
  # GET /proyectoexam_details.json
  def index
    @proyectoexam_details = ProyectoexamDetail.all
  end

  # GET /proyectoexam_details/1
  # GET /proyectoexam_details/1.json
  def show
  end

  # GET /proyectoexam_details/new
  def new
    @proyectoexam_detail = ProyectoExamDetail.new
  
    @valor = Valor.all
    @proyectoexam_detail[:le_an_gln] = 0
  
  end

  # GET /proyectoexam_details/1/edit
  def edit
    @employee = Employee.all 
    @valor = Valor.all
  end

  # POST /proyectoexam_details
  # POST /proyectoexam_details.json
  def create
    
    @proyectoexam_detail = ProyectoexamDetail.new(proyectoexam_detail_params)
    
    @proyectoexam_detail.proyectoexam_id  = @proyecto_exam.id
   
   
          
      @employee = Employee.all 
      @valor = Valor.all
    
     
    respond_to do |format|
      if @proyectoexam_detail.save
        
     
    
              format.html { redirect_to @proyectoexam, notice: 'Proyecto exam  detail was successfully created.' }
        format.json { render :show, status: :created, location: @proyectoexam }
      else
        format.html { render :new }
        format.json { render json: @proyectoexam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proyectoexam_details/1
  # PATCH/PUT /proyectoexam_details/1.json
  def update
    @employee = Employee.all 
    @valor = Valor.all
    
         $lcGalones = @proyectoexam.get_importe_1("galones")
         $lcImporte = @proyectoexam.get_importe_1("total")
         
         @proyectoexam.update_attributes(galones:  $lcGalones ,importe: $lcImporte )
         
    
    
    respond_to do |format|
      if @proyectoexam_detail.update(proyectoexam_detail_params)
        format.html { redirect_to @proyectoexam, notice: 'Proyecto Exam detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @proyectoexam }
      else
        format.html { render :edit }
        format.json { render json: @proyectoexam.errors, status: :unprocessable_entity }
      end
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
  
    def set_ventaisla 
      @proyectoexam  = ProyectoExam.find(params[:proyectoexam_id])
      
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_proyectoexam_detail
      @proyectoexam_detail = ProyectoexamDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proyectoexam_detail_params
      params.require(:proyectoexam_detail).permit(:employee_id, :proyecto_minero_id,
        :proyecto_minero_exam_id ,:observacion)
    end
end

    