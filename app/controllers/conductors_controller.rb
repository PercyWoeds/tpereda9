class ConductorsController < ApplicationController
  before_action :set_conductor, only: [:show, :edit, :update, :destroy]

  # GET /conductors
  # GET /conductors.json
  def index
    @conductors = Conductor.all
  end

  # GET /conductors/1
  # GET /conductors/1.json
  def show
  end


  def import
      Conductor.import(params[:file])
       redirect_to root_url, notice: "Conductores  importadas."
  end 



  # GET /conductors/new
  def new
    @conductor = Conductor.new
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @conductor[:expedicion_licencia] = Date.today
    @conductor[:revalidacion_licencia] = Date.today


    @conductor[:expedicion_licencia_especial] = Date.today
    @conductor[:revalidacion_licencia_especial] = Date.today

  
    @conductor[:dni_emision] = Date.today
    @conductor[:dni_caducidad] = Date.today

    @conductor[:ap_emision] = Date.today
    @conductor[:ap_caducidad] = Date.today

    @conductor[:ape_emision] = Date.today
    @conductor[:ape_caducidad] = Date.today

  
    @conductor[:active] = 1

  end

  # GET /conductors/1/edit
  def edit
    @company = Company.find(1)
    @empleados = @company.get_employees()
  end

  # POST /conductors
  # POST /conductors.json
  def create
    @conductor = Conductor.new(conductor_params)
    @company = Company.find(1)
    @empleados = @company.get_employees()

    respond_to do |format|
      if @conductor.save
        format.html { redirect_to @conductor, notice: 'Conductor was successfully created.' }
        format.json { render :show, status: :created, location: @conductor }
      else
        format.html { render :new }
        format.json { render json: @conductor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conductors/1
  # PATCH/PUT /conductors/1.json
  def update
    @company = Company.find(1)
    @empleados = @company.get_employees()
    respond_to do |format|
      if @conductor.update(conductor_params)
        format.html { redirect_to @conductor, notice: 'Conductor was successfully updated.' }
        format.json { render :show, status: :ok, location: @conductor }
      else
        format.html { render :edit }
        format.json { render json: @conductor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conductors/1
  # DELETE /conductors/1.json
  def destroy
    @conductor.destroy
    
    respond_to do |format|
      format.html { redirect_to conductors_url, notice: 'Conductor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conductor
      @conductor = Conductor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conductor_params
      params.require(:conductor).permit(:lugar, :anio, :licencia, :categoria, :expedicion_licencia, 
        :revalidacion_licencia, :categoria_especial, :expedicion_licencia_especial,
        :revalidacion_licencia_especial, :iqbf, :fecha_emision, :dni_emision, :dni_caducidad, 
        :ap_emision, :ap_caducidad, :ape_emision, :ape_caducidad, :user_id, :company_id, :active, 
        :employee_id)
    end
end
