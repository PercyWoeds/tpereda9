class ColorVehisController < ApplicationController
  before_action :set_color_vehi, only: [:show, :edit, :update, :destroy]

  # GET /color_vehis
  # GET /color_vehis.json
  def index
    @color_vehis = ColorVehi.all
  end

  # GET /color_vehis/1
  # GET /color_vehis/1.json
  def show
  end

  # GET /color_vehis/new
  def new
    @color_vehi = ColorVehi.new
  end

  # GET /color_vehis/1/edit
  def edit
  end

  # POST /color_vehis
  # POST /color_vehis.json
  def create
    @color_vehi = ColorVehi.new(color_vehi_params)

    respond_to do |format|
      if @color_vehi.save
        format.html { redirect_to @color_vehi, notice: 'Color vehi was successfully created.' }
        format.json { render :show, status: :created, location: @color_vehi }
      else
        format.html { render :new }
        format.json { render json: @color_vehi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /color_vehis/1
  # PATCH/PUT /color_vehis/1.json
  def update
    respond_to do |format|
      if @color_vehi.update(color_vehi_params)
        format.html { redirect_to @color_vehi, notice: 'Color vehi was successfully updated.' }
        format.json { render :show, status: :ok, location: @color_vehi }
      else
        format.html { render :edit }
        format.json { render json: @color_vehi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /color_vehis/1
  # DELETE /color_vehis/1.json
  def destroy
    @color_vehi.destroy
    respond_to do |format|
      format.html { redirect_to color_vehis_url, notice: 'Color vehi was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_color_vehi
      @color_vehi = ColorVehi.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def color_vehi_params
      params.require(:color_vehi).permit(:code, :name, :user_id, :company_id)
    end
end
