class ModelosController < ApplicationController
  before_action :set_modelo, only: [:show, :edit, :update, :destroy]

  # GET /modelos
  # GET /modelos.json
  def index
    @modelos = Modelo.all

           
 respond_to do |format|
    format.html
    format.xls # { send_data @products.to_csv(col_sep: "\t") }
  end

  end

  # GET /modelos/1
  # GET /modelos/1.json
  def show
  end

  # GET /modelos/new
  def new
    @modelo = Modelo.new
  end

  # GET /modelos/1/edit
  def edit
  end

  # POST /modelos
  # POST /modelos.json
  def create
    @modelo = Modelo.new(modelo_params)

    respond_to do |format|
      if @modelo.save
        format.html { redirect_to @modelo, notice: 'Modelo was successfully created.' }
        format.json { render :show, status: :created, location: @modelo }
      else
        format.html { render :new }
        format.json { render json: @modelo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modelos/1
  # PATCH/PUT /modelos/1.json
  def update
    respond_to do |format|
      if @modelo.update(modelo_params)
        format.html { redirect_to @modelo, notice: 'Modelo was successfully updated.' }
        format.json { render :show, status: :ok, location: @modelo }
      else
        format.html { render :edit }
        format.json { render json: @modelo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modelos/1
  # DELETE /modelos/1.json
  def destroy
    @modelo.destroy
    respond_to do |format|
      format.html { redirect_to modelos_url, notice: 'Modelo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  def import
      Modelo.import(params[:file])
       redirect_to root_url, notice: "Modelos importadas."
  end 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modelo
      @modelo = Modelo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modelo_params
      params.require(:modelo).permit(:descrip,:company_id)
    end
end
