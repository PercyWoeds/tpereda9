class PaymentnoticeDetailsController < ApplicationController
  before_action :set_paymentnotice_detail, only: [:show, :edit, :update, :destroy]

  # GET /paymentnotice_details
  # GET /paymentnotice_details.json
  def index
    @paymentnotice_details = PaymentnoticeDetail.all
  end

  # GET /paymentnotice_details/1
  # GET /paymentnotice_details/1.json
  def show
  end

  # GET /paymentnotice_details/new
  def new
    @paymentnotice_detail = PaymentnoticeDetail.new
    
  end

  # GET /paymentnotice_details/1/edit
  def edit
  end

  # POST /paymentnotice_details
  # POST /paymentnotice_details.json
  def create
    @paymentnotice_detail = PaymentnoticeDetail.new(paymentnotice_detail_params)

    respond_to do |format|
      if @paymentnotice_detail.save
        format.html { redirect_to @paymentnotice_detail, notice: 'Paymentnotice detail was successfully created.' }
        format.json { render :show, status: :created, location: @paymentnotice_detail }
      else
        format.html { render :new }
        format.json { render json: @paymentnotice_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paymentnotice_details/1
  # PATCH/PUT /paymentnotice_details/1.json
  def update
    respond_to do |format|
      if @paymentnotice_detail.update(paymentnotice_detail_params)
        format.html { redirect_to @paymentnotice_detail, notice: 'Paymentnotice detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @paymentnotice_detail }
      else
        format.html { render :edit }
        format.json { render json: @paymentnotice_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paymentnotice_details/1
  # DELETE /paymentnotice_details/1.json
  def destroy
    @paymentnotice_detail.destroy
    respond_to do |format|
      format.html { redirect_to paymentnotice_details_url, notice: 'Paymentnotice detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paymentnotice_detail
      @paymentnotice_detail = PaymentnoticeDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paymentnotice_detail_params
      params.require(:paymentnotice_detail).permit(:fecha_inicio, :fecha_culmina, :total, :descrip, :lugar, :price_unit, :sub_total, :igv, :total, :nro_compro, :nro_documento, :observa, :payment_notices_id)
    end
end
