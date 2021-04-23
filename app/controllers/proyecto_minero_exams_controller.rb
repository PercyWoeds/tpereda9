class ProyectoMineroExamsController < ApplicationController
  before_action :set_proyecto_minero_exam, only: [:show, :edit, :update, :destroy]

  # GET /proyecto_minero_exams
  # GET /proyecto_minero_exams.json
  def index
    @proyecto_minero_exams = ProyectoMineroExam.order(:proyecto_minero_id,:orden)
  end

  # GET /proyecto_minero_exams/1
  # GET /proyecto_minero_exams/1.json
  def show
 @company = Company.find(1)

    
     @pm  = @company.get_pm()
    @pm1 = @company.get_pm1()
    @pm2 = @company.get_pm2()
  end

  # GET /proyecto_minero_exams/new
  def new

    @company = Company.find(1)

    @proyecto_minero_exam = ProyectoMineroExam.new

    @pm  = @company.get_pm()
    @pm1 = @company.get_pm1()
    @pm2 = @company.get_pm2()
    puts "pm1 pm2 "
    
    puts @pm1.first.name
    puts @pm2.first.name 


  end

  # GET /proyecto_minero_exams/1/edit
  def edit
      @company = Company.find(1)
     @pm  = @company.get_pm()
    @pm1 = @company.get_pm1()
    @pm2 = @company.get_pm2()
    
  end

  # POST /proyecto_minero_exams
  # POST /proyecto_minero_exams.json
  def create
     @company = Company.find(1)

     @pm  = @company.get_pm()
    @pm1 = @company.get_pm1()
    @pm2 = @company.get_pm2()
    @proyecto_minero_exam = ProyectoMineroExam.new(proyecto_minero_exam_params)

    respond_to do |format|
      if @proyecto_minero_exam.save
        format.html { redirect_to @proyecto_minero_exam, notice: 'Proyecto minero exam was successfully created.' }
        format.json { render :show, status: :created, location: @proyecto_minero_exam }
      else
        format.html { render :new }
        format.json { render json: @proyecto_minero_exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proyecto_minero_exams/1
  # PATCH/PUT /proyecto_minero_exams/1.json
  def update
    respond_to do |format|
      if @proyecto_minero_exam.update(proyecto_minero_exam_params)
        format.html { redirect_to @proyecto_minero_exam, notice: 'Proyecto minero exam was successfully updated.' }
        format.json { render :show, status: :ok, location: @proyecto_minero_exam }
      else
        format.html { render :edit }
        format.json { render json: @proyecto_minero_exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proyecto_minero_exams/1
  # DELETE /proyecto_minero_exams/1.json
  def destroy
    @proyecto_minero_exam.destroy
    respond_to do |format|
      format.html { redirect_to proyecto_minero_exams_url, notice: 'Proyecto minero exam was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proyecto_minero_exam
      @proyecto_minero_exam = ProyectoMineroExam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proyecto_minero_exam_params
      params.require(:proyecto_minero_exam).permit(:fecha, :observacion, :proyecto_minero_id, :proyectominero2_id,:proyectominero3_id)
    end
end
