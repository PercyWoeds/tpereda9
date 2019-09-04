class LgcsController < ApplicationController
  before_action :set_lgc, only: [:show, :edit, :update, :destroy]

  # GET /lgcs
  # GET /lgcs.json
  def index
    @lgcs = Lgc.all
  end

  # GET /lgcs/1
  # GET /lgcs/1.json
  def show
  end

  # GET /lgcs/new
  def new
    @lgc = Lgc.new
    @company = Company.find(1)

    @eess     = @company.get_eess
    @carros   = @company.get_placas
    @products = @company.get_products
    @employees= @company.get_employees


  end

  # GET /lgcs/1/edit
  def edit
  end

  # POST /lgcs
  # POST /lgcs.json
  def create
    @lgc = Lgc.new(lgc_params)

    respond_to do |format|
      if @lgc.save
        format.html { redirect_to @lgc, notice: 'Lgc was successfully created.' }
        format.json { render :show, status: :created, location: @lgc }
      else
        format.html { render :new }
        format.json { render json: @lgc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgcs/1
  # PATCH/PUT /lgcs/1.json
  def update
    respond_to do |format|
      if @lgc.update(lgc_params)
        format.html { redirect_to @lgc, notice: 'Lgc was successfully updated.' }
        format.json { render :show, status: :ok, location: @lgc }
      else
        format.html { render :edit }
        format.json { render json: @lgc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgcs/1
  # DELETE /lgcs/1.json
  def destroy
    @lgc.destroy
    respond_to do |format|
      format.html { redirect_to lgcs_url, notice: 'Lgc was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgc
      @lgc = Lgc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lgc_params
      params.require(:lgc).permit(:employee_id, :placa_id, :placa_id2, :peso_ida, :peso_ret, :tipo_carga_id, :ruta, :viaje_salida_fecha, :viaje_retorno_fecha, :recorrido, :float, :salida_km, :retorno_km, :km_real, :total_gal, :ratio_fisico, :ratio_teorico, :idle_fuel, :idletime, :time_1, :margen, :dscto_gln, :monto, :rpm, :km, :abas_total, :monto_total, :obser, :user_id)
    end
end
