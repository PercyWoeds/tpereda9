class TelecreditoDetailsController < ApplicationController
  before_action :set_telecredito_detail, only: [:show, :edit, :update, :destroy]

  # GET /telecredito_details
  # GET /telecredito_details.json
  def index
    @telecredito_details = TelecreditoDetail.all
  end

  # GET /telecredito_details/1
  # GET /telecredito_details/1.json
  def show
  end

  # GET /telecredito_details/new
  def new
    @telecredito_detail = TelecreditoDetail.new
  end

  # GET /telecredito_details/1/edit
  def edit
  end

  # POST /telecredito_details
  # POST /telecredito_details.json
  def create
    @telecredito_detail = TelecreditoDetail.new(telecredito_detail_params)

    respond_to do |format|
      if @telecredito_detail.save
        format.html { redirect_to @telecredito_detail, notice: 'Telecredito detail was successfully created.' }
        format.json { render :show, status: :created, location: @telecredito_detail }
      else
        format.html { render :new }
        format.json { render json: @telecredito_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /telecredito_details/1
  # PATCH/PUT /telecredito_details/1.json
  def update
    respond_to do |format|
      if @telecredito_detail.update(telecredito_detail_params)
        format.html { redirect_to @telecredito_detail, notice: 'Telecredito detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @telecredito_detail }
      else
        format.html { render :edit }
        format.json { render json: @telecredito_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /telecredito_details/1
  # DELETE /telecredito_details/1.json
  def destroy
    @telecredito_detail.destroy
    respond_to do |format|
      format.html { redirect_to telecredito_details_url, notice: 'Telecredito detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_telecredito_detail
      @telecredito_detail = TelecreditoDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def telecredito_detail_params
      params.require(:telecredito_detail).permit(:fecha, :nro, :operacion, :purchase_id, :beneficiario, :documento, :moneda, :importe, :egreso, :aprueba, :observacion, :telecredito_id)
    end
end
