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
    @employees = @company.get_employees()
    @proyecto_examen  = @company.get_proyecto_exams

    @proyectoexam_details= @proyecto_exam.proyectoexam_details
    
    @rows = 2
  

    @pumps = ProyectoMineroExam.where(proyecto_minero_id: @proyecto_exam.proyecto_minero_id)
    @cols = @pumps.count 

    @valor  = Array.new(2) { Array.new(@cols) { "" } }

    

    for i in 0..0 do
        puts i

      for pumps in @pumps do

        @valor[i].push(pumps.proyectominero2.name)

       end 

    end 
   
    for i in 1..1 do
        puts i

      for pumps in @pumps do

        @valor[i].push(pumps.proyectominero3.name )

       end 

    end 
   

      


  end

  # GET /proyecto_exams/new
  def new

    @company = Company.find(1)
    @proyecto_exam = ProyectoExam.new
    @employees = @company.get_employees()
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proyecto_exam
      @proyecto_exam = ProyectoExam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proyecto_exam_params
      params.require(:proyecto_exam).permit(:employee_id, :proyecto_minero_id)
    end
end
