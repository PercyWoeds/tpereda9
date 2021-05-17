class ProvinsController < ApplicationController
  before_action :set_provin, only: [:show, :edit, :update, :destroy]

  # GET /provins
  # GET /provins.json
  def index
    @provins = Provin.all
  end

  # GET /provins/1
  # GET /provins/1.json
  def show
  end

  # GET /provins/new
  def new
    @provin = Provin.new
  end

  # GET /provins/1/edit
  def edit
  end

  # POST /provins
  # POST /provins.json
  def create
    @provin = Provin.new(provin_params)

    respond_to do |format|
      if @provin.save
        format.html { redirect_to @provin, notice: 'Provin was successfully created.' }
        format.json { render :show, status: :created, location: @provin }
      else
        format.html { render :new }
        format.json { render json: @provin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /provins/1
  # PATCH/PUT /provins/1.json
  def update
    respond_to do |format|
      if @provin.update(provin_params)
        format.html { redirect_to @provin, notice: 'Provin was successfully updated.' }
        format.json { render :show, status: :ok, location: @provin }
      else
        format.html { render :edit }
        format.json { render json: @provin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provins/1
  # DELETE /provins/1.json
  def destroy
    @provin.destroy
    respond_to do |format|
      format.html { redirect_to provins_url, notice: 'Provin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  def import
      Provin.import(params[:file])
       redirect_to root_url, notice: "Provincia  importadas."
  end 
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provin
      @provin = Provin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provin_params
      params.require(:provin).permit(:code, :name, :ubigeo)
    end
end