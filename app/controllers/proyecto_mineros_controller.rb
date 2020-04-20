include UsersHelper

class ProyectoMinerosController < ApplicationController
   before_action :authenticate_user!
    
  before_action :set_proyecto_minero, only: [:show, :edit, :update, :destroy]

  # GET /proyecto_mineros
  # GET /proyecto_mineros.json
  def index
    @proyecto_mineros = ProyectoMinero.all
  end

  # GET /proyecto_mineros/1
  # GET /proyecto_mineros/1.json
  def show
  end

  # GET /proyecto_mineros/new
  def new
    @company = Company.find(1)
    @proyecto_minero = ProyectoMinero.new
    @puntos = @company.get_puntos()
    @proyecto_minero[:fecha1] = Date.today
    @proyecto_minero[:fecha2] = Date.today

  end

  # GET /proyecto_mineros/1/edit
  def edit
     @company = Company.find(1)
      @puntos = @company.get_puntos()
  end

  # POST /proyecto_mineros
  # POST /proyecto_mineros.json
  def create
    @proyecto_minero = ProyectoMinero.new(proyecto_minero_params)
    @proyecto_minero[:code] = @proyecto_minero.generate_rq_number("001")

    respond_to do |format|
      if @proyecto_minero.save
        format.html { redirect_to @proyecto_minero, notice: 'Proyecto minero was successfully created.' }
        format.json { render :show, status: :created, location: @proyecto_minero }
      else
        format.html { render :new }
        format.json { render json: @proyecto_minero.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proyecto_mineros/1
  # PATCH/PUT /proyecto_mineros/1.json
  def update

    respond_to do |format|
      if @proyecto_minero.update(proyecto_minero_params)
        format.html { redirect_to @proyecto_minero, notice: 'Proyecto minero was successfully updated.' }
        format.json { render :show, status: :ok, location: @proyecto_minero }
      else
        format.html { render :edit }
        format.json { render json: @proyecto_minero.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proyecto_mineros/1
  # DELETE /proyecto_mineros/1.json
  def destroy
    @proyecto_minero.destroy
    respond_to do |format|
      format.html { redirect_to proyecto_mineros_url, notice: 'Proyecto minero was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proyecto_minero
      @proyecto_minero = ProyectoMinero.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proyecto_minero_params
      params.require(:proyecto_minero).permit(:code, :fecha1, :fecha2, :descrip, :punto_id)
    end
end
