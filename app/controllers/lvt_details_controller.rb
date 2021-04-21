class LvtDetailsController < ApplicationController
  before_action :set_lvt_detail, only: [:show, :edit, :update, :destroy]

  # GET /lvt_details
  # GET /lvt_details.json
  def index
    @lvt_details = LvtDetail.all
  end

  # GET /lvt_details/1
  # GET /lvt_details/1.json
  def show
  end

  # GET /lvt_details/new
  def new
    @lvt_detail = LvtDetail.new
  end

  # GET /lvt_details/1/edit
  def edit
  end

  # POST /lvt_details
  # POST /lvt_details.json
  def create
    @lvt_detail = LvtDetail.new(lvt_detail_params)

    respond_to do |format|
      if @lvt_detail.save
        format.html { redirect_to @lvt_detail, notice: 'Lvt detail was successfully created.' }
        format.json { render :show, status: :created, location: @lvt_detail }
      else
        format.html { render :new }
        format.json { render json: @lvt_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lvt_details/1
  # PATCH/PUT /lvt_details/1.json
  def update
    respond_to do |format|
      if @lvt_detail.update(lvt_detail_params)
        format.html { redirect_to @lvt_detail, notice: 'Lvt detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @lvt_detail }
      else
        format.html { render :edit }
        format.json { render json: @lvt_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lvt_details/1
  # DELETE /lvt_details/1.json
  def destroy
    @lvt_detail.destroy
    respond_to do |format|
      format.html { redirect_to lvt_details_url, notice: 'Lvt detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lvt_detail
      @lvt_detail = LvtDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lvt_detail_params
      params.require(:lvt_detail).permit(:fecha, :gasto_id, :document_id, :documento, :total, :lvt_id, :supplier_id, :td, :detalle)
    end
end
