class TrucksController < ApplicationController


  before_action :set_truck, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json
 
  def import
      Truck.import(params[:file])
       redirect_to root_url, notice: "Vehiculos importadas."
  end 
  
  # GET /trucks
  # GET /trucks.json
  def index

     if(params[:search])                 
  
        @trucks = Truck.paginate(:page => params[:page]).search(params[:search]).order(:placa)
      else
        @trucks = Truck.where(estado: "1").order("placa").paginate(:page => params[:page])
      end
  end

  # GET /trucks/1
  # GET /trucks/1.jso
  def show
    @truck = Truck.new
    @marcas = @truck.get_marcas() 
    @modelos = @truck.get_modelos()    
    @tipo_unidad  = @truck.get_tipos()
    @config  = @truck.get_config()
    @clase   = @truck.get_clase()
    @color   = @truck.get_color()
  end

  # GET /trucks/new
  def new
    @truck   = Truck.new
    @marcas  = @truck.get_marcas() 
    @modelos = @truck.get_modelos() 
    @tipo_unidad  = @truck.get_tipos()
    @config  = @truck.get_config()
    @clase   = @truck.get_clase()
    @color   = @truck.get_color()

   


  end

  # GET /trucks/1/edit
  def edit
    @truck = Truck.find(params[:id])    
    @marcas = @truck.get_marcas() 
    @modelos = @truck.get_modelos()
    @tipo_unidad  = @truck.get_tipos()
    @config  = @truck.get_config()
    @clase   = @truck.get_clase()
    @color   = @truck.get_color()
         
  end

  # POST /trucks
  # POST /trucks.json
  def create
    @truck = Truck.new(truck_params)
    @marcas = @truck.get_marcas() 
    @modelos = @truck.get_modelos()
    @tipo_unidad  = @truck.get_tipos()
    @config  = @truck.get_config()
    @clase   = @truck.get_clase()
    @color   = @truck.get_color()
    @serie = 1
          
   @truck[:code] = @truck.generate_truck_number(@serie)  
  

    respond_to do |format|
      if @truck.save
        format.html { redirect_to @truck, notice: 'Truck was successfully created.' }
        format.json { render :show, status: :created, location: @truck }
      else
        format.html { render :new }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trucks/1
  # PATCH/PUT /trucks/1.json
  def update
    @marcas = @truck.get_marcas() 
    @modelos = @truck.get_modelos()
    @tipo_unidad  = @truck.get_tipos()
    @config  = @truck.get_config()
    @clase   = @truck.get_clase()
    @color   = @truck.get_color()


    respond_to do |format|
      if @truck.update(truck_params)
        format.html { redirect_to @truck, notice: 'Truck was successfully updated.' }
        format.json { render :show, status: :ok, location: @truck }
      else
        format.html { render :edit }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trucks/1
  # DELETE /trucks/1.json
  def destroy

       if  @truck.destroy


        respond_to do |format|
          format.html { redirect_to trucks_url, notice: 'Truck was successfully destroyed.' }
          format.json { head :no_content }
        end
        else 

      respond_to do |format|
          format.html { redirect_to trucks_url, notice: 'Vehiculo esta siendo usado, no puedes eliminar .' }
          format.json { head :no_content }
        end
       end 

  end


  def ac_placas
    @placas = Truck.where(["placa  iLIKE ? ", "%" + params[:q] + "%"])  
    render :layout => false
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_truck
      @truck = Truck.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def truck_params
      params.require(:truck).permit(:code, :placa, :clase, :marca_id, :modelo_id, :certificado, :ejes, :licencia, :neumatico, :config, :carroceria, :anio, :estado, :propio,:search ,:tipo_unidad_id , :config_vehi_id,:clase_cat_id,:color_vehi_id)
    end


end
