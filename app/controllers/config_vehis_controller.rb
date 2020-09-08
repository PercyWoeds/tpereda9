class ConfigVehisController < ApplicationController
  before_action :set_config_vehi, only: [:show, :edit, :update, :destroy]

  # GET /config_vehis
  # GET /config_vehis.json
  def index
    @config_vehis = ConfigVehi.all
  end

  # GET /config_vehis/1
  # GET /config_vehis/1.json
  def show
  end

  # GET /config_vehis/new
  def new
    @config_vehi = ConfigVehi.new
  end

  # GET /config_vehis/1/edit
  def edit
  end

  # POST /config_vehis
  # POST /config_vehis.json
  def create
    @config_vehi = ConfigVehi.new(config_vehi_params)

    respond_to do |format|
      if @config_vehi.save
        format.html { redirect_to @config_vehi, notice: 'Config vehi was successfully created.' }
        format.json { render :show, status: :created, location: @config_vehi }
      else
        format.html { render :new }
        format.json { render json: @config_vehi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /config_vehis/1
  # PATCH/PUT /config_vehis/1.json
  def update
    respond_to do |format|
      if @config_vehi.update(config_vehi_params)
        format.html { redirect_to @config_vehi, notice: 'Config vehi was successfully updated.' }
        format.json { render :show, status: :ok, location: @config_vehi }
      else
        format.html { render :edit }
        format.json { render json: @config_vehi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /config_vehis/1
  # DELETE /config_vehis/1.json
  def destroy
    @config_vehi.destroy
    respond_to do |format|
      format.html { redirect_to config_vehis_url, notice: 'Config vehi was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_config_vehi
      @config_vehi = ConfigVehi.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def config_vehi_params
      params.require(:config_vehi).permit(:code, :name, :user_id, :company_id)
    end
end
