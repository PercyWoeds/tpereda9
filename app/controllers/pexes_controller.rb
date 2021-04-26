class PexesController < ApplicationController
  before_action :set_pex, only: [:show, :edit, :update, :destroy]

  # GET /pexes
  # GET /pexes.json
  def index

      @pexes = Pex.paginate(:page => params[:page]).order(:placa,:nro_compro)
  end

  # GET /pexes/1
  # GET /pexes/1.json
  def show
  end

  # GET /pexes/new
  def new
    @pex = Pex.new
  end

  # GET /pexes/1/edit
  def edit
  end

  # POST /pexes
  # POST /pexes.json
  def create
    @pex = Pex.new(pex_params)

    respond_to do |format|
      if @pex.save
        format.html { redirect_to @pex, notice: 'Pex was successfully created.' }
        format.json { render :show, status: :created, location: @pex }
      else
        format.html { render :new }
        format.json { render json: @pex.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pexes/1
  # PATCH/PUT /pexes/1.json
  def update
    respond_to do |format|
      if @pex.update(pex_params)
        format.html { redirect_to @pex, notice: 'Pex was successfully updated.' }
        format.json { render :show, status: :ok, location: @pex }
      else
        format.html { render :edit }
        format.json { render json: @pex.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /pexes/1
  # DELETE /pexes/1.json
  def destroy
    @pex.destroy
    respond_to do |format|
      format.html { redirect_to pexes_url, notice: 'Pex was successfully destroyed.' }
      format.json { head :no_content }
    end
  end





  def import
      Pex.import(params[:file])
       redirect_to root_url, notice: "Tickets Pex  importadas."
  end 
  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pex
      @pex = Pex.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pex_params
      params.require(:pex).permit(:doc, :razon, :red, :ruc_red, :placa, :nromiddia, :categoria, :fecha_inicio, :hora_inicio, :fecha_fin, :hora_fin, :fecha_apro, :hora_apro, :plaza, :pista, :importe, :nro_compro, :fecha_compro)
    end
end
