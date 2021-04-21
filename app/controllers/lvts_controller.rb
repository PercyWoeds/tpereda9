class LvtsController < ApplicationController
  before_action :set_lvt, only: [:show, :edit, :update, :destroy]

  # GET /lvts
  # GET /lvts.json
  def index
    @lvts = Lvt.all
  end

  # GET /lvts/1
  # GET /lvts/1.json
  def show
  end

  # GET /lvts/new
  def new
    @lvt = Lvt.new
  end

  # GET /lvts/1/edit
  def edit
  end

  # POST /lvts
  # POST /lvts.json
  def create
    @lvt = Lvt.new(lvt_params)

    respond_to do |format|
      if @lvt.save
        format.html { redirect_to @lvt, notice: 'Lvt was successfully created.' }
        format.json { render :show, status: :created, location: @lvt }
      else
        format.html { render :new }
        format.json { render json: @lvt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lvts/1
  # PATCH/PUT /lvts/1.json
  def update
    respond_to do |format|
      if @lvt.update(lvt_params)
        format.html { redirect_to @lvt, notice: 'Lvt was successfully updated.' }
        format.json { render :show, status: :ok, location: @lvt }
      else
        format.html { render :edit }
        format.json { render json: @lvt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lvts/1
  # DELETE /lvts/1.json
  def destroy
    @lvt.destroy
    respond_to do |format|
      format.html { redirect_to lvts_url, notice: 'Lvt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lvt
      @lvt = Lvt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lvt_params
      params.require(:lvt).permit(:code, :tranportorder_id, :fecha, :viatico_id, :total, :devuelto_texto, :devuelto, :reembolso, :descuento, :observa, :company_id, :processed, :user_id, :tranportorder_id, :comments, :gasto_id, :compro_id, :inicial, :total_ing, :total_egreso, :saldo, :lgv_id, :peaje, :cdevuelto, :cdescuento, :creembolso)
    end
end
