class AutoviaticsController < ApplicationController
  before_action :set_autoviatic, only: [:show, :edit, :update, :destroy]

  # GET /autoviatics
  # GET /autoviatics.json
  def index
    @autoviatics = Autoviatic.all
  end

  # GET /autoviatics/1
  # GET /autoviatics/1.json
  def show

     @company = Company.find(1)
    @locations = @company.get_locations 
    @employees = @company.get_employees 
    @tramits = @company.get_tramits
    @tipo_tramits = @company.get_tipo_tramits
    @antecedents = @company.get_antecedents
    @proyecto_mineros = @company.get_proyecto_minero 
    @suppliers_clinica = @company.get_supplier_clinica 
    @tecnic_revisions = @company.get_revision_tecnica
    @trucks = @company.get_trucks 
    @antecedents = @company.get_antecedents
  end

  # GET /autoviatics/new
  def new
    @autoviatic = Autoviatic.new
    @company = Company.find(1)
    @locations = @company.get_locations 
    @employees = @company.get_employees 
    @tramits = @company.get_tramits
    @tipo_tramits = @company.get_tipo_tramits
    @antecedents = @company.get_antecedents
    @proyecto_mineros = @company.get_proyecto_minero 
    @suppliers_clinica = @company.get_supplier_clinica 
    @tecnic_revisions = @company.get_revision_tecnica
    @trucks = @company.get_trucks 
    @antecedents = @company.get_antecedents
    
    @autoviatic[:movilidad] = 0
    @autoviatic[:almuerzo] = 0
    @autoviatic[:otros] = 0
    


  end

  # GET /autoviatics/1/edit
  def edit

    @company = Company.find(1)
    @locations = @company.get_locations 
    @employees = @company.get_employees 
    @tramits = @company.get_tramits
    @tipo_tramits = @company.get_tipo_tramits
    @antecedents = @company.get_antecedents
    @proyecto_mineros = @company.get_proyecto_minero 
    @suppliers_clinica = @company.get_supplier_clinica 
    @tecnic_revisions = @company.get_revision_tecnica
    @trucks = @company.get_trucks 
    @antecedents = @company.get_antecedents
    
  end

  # POST /autoviatics
  # POST /autoviatics.json
  def create
    @autoviatic = Autoviatic.new(autoviatic_params)

    respond_to do |format|
      if @autoviatic.save
        format.html { redirect_to @autoviatic, notice: 'Autoviatic was successfully created.' }
        format.json { render :show, status: :created, location: @autoviatic }
      else
        format.html { render :new }
        format.json { render json: @autoviatic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /autoviatics/1
  # PATCH/PUT /autoviatics/1.json
  def update
    @company = Company.find(1)
    @locations = @company.get_locations 
    @employees = @company.get_employees 
    @tramits = @company.get_tramits
    @tipo_tramits = @company.get_tipo_tramits
    @antecedents = @company.get_antecedents
    @proyecto_mineros = @company.get_proyecto_minero 
    @suppliers_clinica = @company.get_supplier_clinica 
    @tecnic_revisions = @company.get_revision_tecnica
    @trucks = @company.get_trucks 
    @antecedents = @company.get_antecedents
    

    respond_to do |format|
      if @autoviatic.update(autoviatic_params)
        format.html { redirect_to @autoviatic, notice: 'Autoviatic was successfully updated.' }
        format.json { render :show, status: :ok, location: @autoviatic }
      else
        format.html { render :edit }
        format.json { render json: @autoviatic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /autoviatics/1
  # DELETE /autoviatics/1.json
  def destroy
    @autoviatic.destroy
    respond_to do |format|
      format.html { redirect_to autoviatics_url, notice: 'Autoviatic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_autoviatic
      @autoviatic = Autoviatic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def autoviatic_params
      params.require(:autoviatic).permit(:location_id, :proyecto_minerdo_id, :employee_id, :fecha, :tema, :supplier_id, :asunto, :tramit_id, :movilidad, :almuerzo, :otros, :lugar1, :lugar2, :lugar3, :obser, :lugar_salida, :lugar_salida2, :hora_ingreso, :hora_salida, :obser2, :processed, :date_processed)
    end
end
