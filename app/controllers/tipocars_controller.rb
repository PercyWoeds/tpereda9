class TipocarsController < ApplicationController
  before_action :set_tipocar, only: [:show, :edit, :update, :destroy]

  # GET /tipocars
  # GET /tipocars.json
  def index
    @tipocars = Tipocar.all
  end

  # GET /tipocars/1
  # GET /tipocars/1.json
  def show
  end

  # GET /tipocars/new
  def new
    @tipocar = Tipocar.new
  end

  # GET /tipocars/1/edit
  def edit
  end

  # POST /tipocars
  # POST /tipocars.json
  def create
    @tipocar = Tipocar.new(tipocar_params)

    respond_to do |format|
      if @tipocar.save
        format.html { redirect_to @tipocar, notice: 'Tipocar was successfully created.' }
        format.json { render :show, status: :created, location: @tipocar }
      else
        format.html { render :new }
        format.json { render json: @tipocar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipocars/1
  # PATCH/PUT /tipocars/1.json
  def update
    respond_to do |format|
      if @tipocar.update(tipocar_params)
        format.html { redirect_to @tipocar, notice: 'Tipocar was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipocar }
      else
        format.html { render :edit }
        format.json { render json: @tipocar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipocars/1
  # DELETE /tipocars/1.json
  def destroy
    @tipocar.destroy
    respond_to do |format|
      format.html { redirect_to tipocars_url, notice: 'Tipocar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipocar
      @tipocar = Tipocar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipocar_params
      params.require(:tipocar).permit(:code, :nombre)
    end
end
