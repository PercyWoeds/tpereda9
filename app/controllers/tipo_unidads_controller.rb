class TipoUnidadsController < ApplicationController
  before_action :set_tipo_unidad, only: [:show, :edit, :update, :destroy]

  # GET /tipo_unidads
  # GET /tipo_unidads.json
  def index
    @tipo_unidads = TipoUnidad.all
  end

  # GET /tipo_unidads/1
  # GET /tipo_unidads/1.json
  def show
  end

  # GET /tipo_unidads/new
  def new
    @tipo_unidad = TipoUnidad.new
  end

  # GET /tipo_unidads/1/edit
  def edit
  end

  # POST /tipo_unidads
  # POST /tipo_unidads.json
  def create
    @tipo_unidad = TipoUnidad.new(tipo_unidad_params)

    respond_to do |format|
      if @tipo_unidad.save
        format.html { redirect_to @tipo_unidad, notice: 'Tipo unidad was successfully created.' }
        format.json { render :show, status: :created, location: @tipo_unidad }
      else
        format.html { render :new }
        format.json { render json: @tipo_unidad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_unidads/1
  # PATCH/PUT /tipo_unidads/1.json
  def update
    respond_to do |format|
      if @tipo_unidad.update(tipo_unidad_params)
        format.html { redirect_to @tipo_unidad, notice: 'Tipo unidad was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipo_unidad }
      else
        format.html { render :edit }
        format.json { render json: @tipo_unidad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_unidads/1
  # DELETE /tipo_unidads/1.json
  def destroy
    @tipo_unidad.destroy
    respond_to do |format|
      format.html { redirect_to tipo_unidads_url, notice: 'Tipo unidad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_unidad
      @tipo_unidad = TipoUnidad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_unidad_params
      params.require(:tipo_unidad).permit(:code, :name, :user_id, :company_id)
    end
end
