class ContratosController < ApplicationController
  before_action :set_contrato, only: [:show, :edit, :update, :destroy]

  # GET /contratos
  # GET /contratos.json
  def index
    @contratos = Contrato.all
  end

  # GET /contratos/1
  # GET /contratos/1.json
  def show
  end

  # GET /contratos/new
  def new
    company = Company.find(1)
    @contrato = Contrato.new
    @employees = company.get_employees()
    @locations = company.get_locations()
    @divisions = company.get_divisions()
    @monedas = company.get_monedas() 
    @contrato[:fecha_inicio] = Date.today
    @contrato[:fecha_fin] = Date.today
    
    @contrato[:fecha_suscripcion] = Date.today
    
  end

  # GET /contratos/1/edit
  def edit
     company = Company.find(1)
     @employees = company.get_employees()
    @locations = company.get_locations()
    @divisions = company.get_divisions()
    @monedas = company.get_monedas() 
  end

  # POST /contratos
  # POST /contratos.json
  def create
     company = Company.find(1)
    @contrato = Contrato.new(contrato_params)
    @employees = company.get_employees()
    @locations = company.get_locations()
    @divisions = company.get_divisions()
    @monedas = company.get_monedas() 

    @contrato[:reingreso] =1
    @contrato[:modalidad_id] =1
    @contrato[:tipocontrato_id] =1
    @contrato[:tiporemuneracion_id] =1


    respond_to do |format|
      if @contrato.save
        format.html { redirect_to @contrato, notice: 'Contrato was successfully created.' }
        format.json { render :show, status: :created, location: @contrato }
      else
        format.html { render :new }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratos/1
  # PATCH/PUT /contratos/1.json
  def update
     company = Company.find(1)
     @employees = company.get_employees()
    @locations = company.get_locations()
    @divisions = company.get_divisions()
    @monedas = company.get_monedas() 

    respond_to do |format|
      if @contrato.update(contrato_params)
        format.html { redirect_to @contrato, notice: 'Contrato was successfully updated.' }
        format.json { render :show, status: :ok, location: @contrato }
      else
        format.html { render :edit }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratos/1
  # DELETE /contratos/1.json
  def destroy
    @contrato.destroy
    respond_to do |format|
      format.html { redirect_to contratos_url, notice: 'Contrato was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contrato
      @contrato = Contrato.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contrato_params
      params.require(:contrato).permit(:employee_id, :fecha_inicio, :fecha_fin, :fecha_suscripcion, :location_id, :division_id, :sueldo, :reingreso, :comments, :modalidad_id, :tipocontrato_id, :submodalidad_id, :moneda_id, :tiporemuneracion_id)
    end
end
