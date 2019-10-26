class CotizacionsController < ApplicationController
  before_action :set_cotizacion, only: [:show, :edit, :update, :destroy]

  # GET /cotizacions
  # GET /cotizacions.json
  def index
    @cotizacions = Cotizacion.all
  end

  # GET /cotizacions/1
  # GET /cotizacions/1.json
  def show
  end

  # GET /cotizacions/new
  def new
    @cotizacion = Cotizacion.new
    @company = Company.find(1)
    @customers = @company.get_customers

    @puntos = @company.get_puntos 
    @tipocarga = Tipocargue.all 

    @cotizacion[:fecha]= Date.today 

  end

  # GET /cotizacions/1/edit
  def edit
     @company = Company.find(1)
    @customers = @company.get_customers

    @puntos = @company.get_puntos 
    @tipocarga = Tipocargue.all 
  end

  # POST /cotizacions
  # POST /cotizacions.json
  def create
     @company = Company.find(1)
    @customers = @company.get_customers

   


    @puntos = @company.get_puntos 
    @tipocarga = Tipocargue.all 
    @cotizacion = Cotizacion.new(cotizacion_params)
   @cotizacion[:code] = @cotizacion.generate_number("1")  

    respond_to do |format|
      if @cotizacion.save
        format.html { redirect_to @cotizacion, notice: 'Cotizacion was successfully created.' }
        format.json { render :show, status: :created, location: @cotizacion }
      else
        format.html { render :new }
        format.json { render json: @cotizacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cotizacions/1
  # PATCH/PUT /cotizacions/1.json
  def update
    respond_to do |format|
      if @cotizacion.update(cotizacion_params)
        format.html { redirect_to @cotizacion, notice: 'Cotizacion was successfully updated.' }
        format.json { render :show, status: :ok, location: @cotizacion }
      else
        format.html { render :edit }
        format.json { render json: @cotizacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cotizacions/1
  # DELETE /cotizacions/1.json
  def destroy
    @cotizacion.destroy
    respond_to do |format|
      format.html { redirect_to cotizacions_url, notice: 'Cotizacion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def do_anular

    @cotizacion = Cotizacion.find(params[:id])  
    @cotizacion[:processed] = "2"
    @cotizacion.anular    

    flash[:notice] = "Documento a sido anulado."

    redirect_to @cotizacion

  end
  
  def do_cancelar
    @cotizacion = Cotizacion.find(params[:id])  
    @cotizacion[:processed] = "3"
    @cotizacion.cancelar      
    flash[:notice] = "Documento a sido cancelado."
     redirect_to @cotizacion

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cotizacion
      @cotizacion = Cotizacion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cotizacion_params
      params.require(:cotizacion).permit(:fecha, :code, :customer_id, :punto_id, :punto2_id, :tipocargue_id, :tarifa, :processed, :comments)
    end
end
