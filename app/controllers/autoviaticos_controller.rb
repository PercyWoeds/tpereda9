class AutoviaticosController < ApplicationController
  before_action :set_autoviatico, only: [:show, :edit, :update, :destroy]

  # GET /autoviaticos
  # GET /autoviaticos.json
  def index
    @autoviaticos = Autoviatico.all
  end

  # GET /autoviaticos/1
  # GET /autoviaticos/1.json
  def show
  end

  # GET /autoviaticos/new
  def new

    

    @autoviatico = Autoviatico.new
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @suppliers = @company.get_suppliers()
  end

  # GET /autoviaticos/1/edit
  def edit
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @suppliers = @company.get_suppliers()
  end

  # POST /autoviaticos
  # POST /autoviaticos.json
  def create
    @autoviatico = Autoviatico.new(autoviatico_params)
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @suppliers = @company.get_suppliers()
    respond_to do |format|
      if @autoviatico.save
        format.html { redirect_to @autoviatico, notice: 'Autoviatico was successfully created.' }
        format.json { render :show, status: :created, location: @autoviatico }
      else
        format.html { render :new }
        format.json { render json: @autoviatico.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /autoviaticos/1
  # PATCH/PUT /autoviaticos/1.json
  def update
    respond_to do |format|
      if @autoviatico.update(autoviatico_params)
        format.html { redirect_to @autoviatico, notice: 'Autoviatico was successfully updated.' }
        format.json { render :show, status: :ok, location: @autoviatico }
      else
        format.html { render :edit }
        format.json { render json: @autoviatico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /autoviaticos/1
  # DELETE /autoviaticos/1.json
  def destroy
    @autoviatico.destroy
    respond_to do |format|
      format.html { redirect_to autoviaticos_url, notice: 'Autoviatico was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_autoviatico
      @autoviatico = Autoviatico.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def autoviatico_params
      params.require(:autoviatico).permit(:code, :employee_id, :fecha, :tema, :supplier_id, :asunto, :movilidad, :almuerzo, :otros, :observa, :hora_ingreso, :hora_salida, :employee_id2, :lugar_salida, :lugar_destino, :hora1, :hora2, :observa2)
    end
end
