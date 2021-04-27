class EgresosController < ApplicationController
  before_action :set_egreso, only: [:show, :edit, :update, :destroy]

  # GET /egresos
  # GET /egresos.json
  def index
    @egresos = Egreso.all
  end

  # GET /egresos/1
  # GET /egresos/1.json
  def show
  end

  # GET /egresos/new
  def new
    @egreso = Egreso.new
  end

  # GET /egresos/1/edit
  def edit
  end

  # POST /egresos
  # POST /egresos.json
  def create
    @egreso = Egreso.new(egreso_params)

    respond_to do |format|
      if @egreso.save
        format.html { redirect_to @egreso, notice: 'Egreso was successfully created.' }
        format.json { render :show, status: :created, location: @egreso }
      else
        format.html { render :new }
        format.json { render json: @egreso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /egresos/1
  # PATCH/PUT /egresos/1.json
  def update
    respond_to do |format|
      if @egreso.update(egreso_params)
        format.html { redirect_to @egreso, notice: 'Egreso was successfully updated.' }
        format.json { render :show, status: :ok, location: @egreso }
      else
        format.html { render :edit }
        format.json { render json: @egreso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /egresos/1
  # DELETE /egresos/1.json
  def destroy
    @egreso.destroy
    respond_to do |format|
      format.html { redirect_to egresos_url, notice: 'Egreso was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_egreso
      @egreso = Egreso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def egreso_params
      params.require(:egreso).permit(:code, :name,:extension,:orden)
    end
end
