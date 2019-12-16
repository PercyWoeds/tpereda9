class AssistancesController < ApplicationController
  before_action :set_assistance, only: [:show, :edit, :update, :destroy]

  # GET /assistances
  # GET /assistances.json
  def index
    @assistances = Assistance.find_by_sql(['Select assistances.id,departamento,nro,nombre,fecha,employees.full_name,hora1,hora2 from assistances  INNER JOIN employees ON assistances.nro = employees.idnumber order by fecha,employees.full_name']).paginate(:page => params[:page])
  end

  # GET /join
  # GET /assistances/1.json
  def show
  end

  # GET /assistances/new
  def new
    @assistance = Assistance.new

    @company = Company.find(1)
    @employees = @company.get_employees

    @assistance['fecha'] = Date.today
   


  end

  # GET /assistances/1/edit
  def edit
  end

  # POST /assistances
  # POST /assistances.json
  def create

    

    @assistance = Assistance.new(assistance_params)

    @assistance[:equipo] ="1"
    @assistance[:cod_verificacion] ="FP"
    @assistance[:num_tarjeta] =""

    respond_to do |format|
      if @assistance.save
        format.html { redirect_to @assistance, notice: 'Registro creado con exito.' }
        format.json { render :show, status: :created, location: @assistance }
      else
        format.html { render :new }
        format.json { render json: @assistance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assistances/1
  # PATCH/PUT /assistances/1.json
  def update

    respond_to do |format|
      if @assistance.update(assistance_params)
        format.html { redirect_to @assistance, notice: 'Registro actualizado con exito ' }
        format.json { render :show, status: :ok, location: @assistance }
      else
        format.html { render :edit }
        format.json { render json: @assistance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assistances/1
  # DELETE /assistances/1.json
  def destroy

    @assistance.destroy

    respond_to do |format|
      format.html { redirect_to assistances_url, notice: 'Assistance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
      Time.zone = "America/Lima"
      Assistance.import(params[:file])
      Time.zone = "Lima"
      
       redirect_to root_url, notice: "Informacio  de asistencia  importadas."
  end 


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assistance
      @assistance = Assistance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assistance_params
      params.require(:assistance).permit(:departamento, :nombre, :nro, :fecha, :equipo, :cod_verificacion, :num_tarjeta,:hora1,:hora2)
    end
end
