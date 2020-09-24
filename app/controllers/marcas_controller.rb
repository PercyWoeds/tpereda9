class MarcasController < ApplicationController
  before_action :set_marca, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json
  
 
  # GET /marcas
  # GET /marcas.json
  def index
        @marcas = Marca.all
       respond_to do |format|
          format.html
          format.xls # { send_data @products.to_csv(col_sep: "\t") }
        end

  end


  # GET /marcas/1
  # GET /marcas/1.json
  def show
  end

  # GET /marcas/new
  def new
    @marca = Marca.new

    
  end

  # GET /marcas/1/edit
  def edit
  end

  # POST /marcas
  # POST /marcas.json
  def create
    @marca = Marca.new(marca_params)

    
 
    respond_to do |format|
      if @marca.save
        format.html { redirect_to @marca, notice: 'Marca was successfully created.' }
        format.json { render :show, status: :created, location: @marca }
      else
        format.html { render :new }
        format.json { render json: @marca.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marcas/1
  # PATCH/PUT /marcas/1.json
  def update
    respond_to do |format|
      if @marca.update(marca_params)
        format.html { redirect_to @marca, notice: 'Marca was successfully updated.' }
        format.json { render :show, status: :ok, location: @marca }
      else
        format.html { render :edit }
        format.json { render json: @marca.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marcas/1
  # DELETE /marcas/1.json
  def destroy

      if    @marca.destroy
        respond_to do |format|
          format.html { redirect_to marcas_url, notice: 'Marca ha sido eliminado.' }
            format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to marcas_url, notice: 'Marca esta siendo usado por otro archivo, no se puede eliminar.' }
            format.json { head :no_content }
        end


      end 
    
  end



  def import
      Marca.import(params[:file])
       redirect_to root_url, notice: "Marca importadas."
  end 


 def create_ajax
    if(params[:company_id] and params[:company_id] != "" and params[:name] and params[:name] != "" )
      @marca = Marca.new(:company_id => params[:company_id].to_i, :name => params[:name])
      
      if @marca.save
        render :text => "#{@marca.id}|BRK|#{@marca.descrip}"
      else
        render :text => "error"
      end
    else
      render :text => "error_empty"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marca
      @marca = Marca.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marca_params
      params.require(:marca).permit(:descrip,:company_id)
    end


   
  
end
