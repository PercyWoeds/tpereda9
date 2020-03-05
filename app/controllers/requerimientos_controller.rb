class RequerimientosController < ApplicationController
  before_action :set_requerimiento, only: [:show, :edit, :update, :destroy]

  # GET /requerimientos
  # GET /requerimientos.json
  def index
    @requerimientos = Requerimiento.all
  end

  # GET /requerimientos/1
  # GET /requerimientos/1.json
  def show
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @divisions = @company.get_divisions()
  end

  # GET /requerimientos/new
  def new
    @requerimiento = Requerimiento.new
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @divisions = @company.get_divisions()

    @requerimiento[:fecha] = DateTime.now
    @requerimiento[:hora] = Time.zone.now.strftime("%H:%M")

  end

  # GET /requerimientos/1/edit
  def edit
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @divisions = @company.get_divisions()
  end

  # POST /requerimientos
  # POST /requerimientos.json
  def create
    @requerimiento = Requerimiento.new(requerimiento_params)
@company = Company.find(1)
    @empleados = @company.get_employees()
    @divisions = @company.get_divisions()
    respond_to do |format|

      @requerimiento[:code] = @requerimiento.generate_rq_number("001")
      if @requerimiento.save
        format.html { redirect_to @requerimiento, notice: 'Requerimiento was successfully created.' }
        format.json { render :show, status: :created, location: @requerimiento }
      else
        format.html { render :new }
        format.json { render json: @requerimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requerimientos/1
  # PATCH/PUT /requerimientos/1.json
  def update
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @divisions = @company.get_divisions()

    respond_to do |format|
      if @requerimiento.update(requerimiento_params)
        format.html { redirect_to @requerimiento, notice: 'Requerimiento was successfully updated.' }
        format.json { render :show, status: :ok, location: @requerimiento }
      else
        format.html { render :edit }
        format.json { render json: @requerimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requerimientos/1
  # DELETE /requerimientos/1.json
  def destroy
    @requerimiento.destroy
    respond_to do |format|
      format.html { redirect_to requerimientos_url, notice: 'Requerimiento was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_requerimiento
      @requerimiento = Requerimiento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def requerimiento_params
      params.require(:requerimiento).permit(:code, :employee_id, :division_id, :fecha, :hora, :item_1, :codigo_1, :cantidad_1, :unidad_1, :descrip_1, :placa_1, :descrip_1, :nota, :observa,
          :item_2,:codigo_2,:cantidad_2,:unidad_2,:descrip_2,:placa_2,:descrip_2,
          :item_3,:codigo_3,:cantidad_3,:unidad_3,:descrip_3,:placa_3,:descrip_3,
          :item_4,:codigo_4,:cantidad_4,:unidad_4,:descrip_4,:placa_4,:descrip_4,
          :item_5,:codigo_5,:cantidad_5,:unidad_5,:descrip_5,:placa_5,:descrip_5,
          :item_6,:codigo_6,:cantidad_6,:unidad_6,:descrip_6,:placa_6,:descrip_6,
          :item_7,:codigo_7,:cantidad_7,:unidad_7,:descrip_7,:placa_7,:descrip_7,
          :item_8,:codigo_8,:cantidad_8,:unidad_8,:descrip_8,:placa_8,:descrip_8,
          :item_9,:codigo_9,:cantidad_9,:unidad_9,:descrip_9,:placa_9,:descrip_9,
          :item_10,:codigo_10,:cantidad_10,:unidad_10,:descrip_10,:placa_10,:descrip_10,



        )

    end
end
