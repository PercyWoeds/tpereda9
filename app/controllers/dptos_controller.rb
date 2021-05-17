class DptosController < ApplicationController
  before_action :set_dpto, only: [:show, :edit, :update, :destroy]

  # GET /dptos
  # GET /dptos.json
  def index
    @dptos = Dpto.all
  end

  # GET /dptos/1
  # GET /dptos/1.json
  def show
  end

  # GET /dptos/new
  def new
    @dpto = Dpto.new
  end

  # GET /dptos/1/edit
  def edit
  end

  # POST /dptos
  # POST /dptos.json
  def create
    @dpto = Dpto.new(dpto_params)

    respond_to do |format|
      if @dpto.save
        format.html { redirect_to @dpto, notice: 'Dpto was successfully created.' }
        format.json { render :show, status: :created, location: @dpto }
      else
        format.html { render :new }
        format.json { render json: @dpto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dptos/1
  # PATCH/PUT /dptos/1.json
  def update
    respond_to do |format|
      if @dpto.update(dpto_params)
        format.html { redirect_to @dpto, notice: 'Dpto was successfully updated.' }
        format.json { render :show, status: :ok, location: @dpto }
      else
        format.html { render :edit }
        format.json { render json: @dpto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dptos/1
  # DELETE /dptos/1.json
  def destroy
    @dpto.destroy
    respond_to do |format|
      format.html { redirect_to dptos_url, notice: 'Dpto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  def import
      Dpto.import(params[:file])
       redirect_to root_url, notice: "Departamentos  importadas."
  end 
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dpto
      @dpto = Dpto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dpto_params
      params.require(:dpto).permit(:code, :name, :ubigeo)
    end
end
