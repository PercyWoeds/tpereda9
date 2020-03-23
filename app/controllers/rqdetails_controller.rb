class RqdetailsController < ApplicationController
  before_action :set_rqdetail, only: [:show, :edit, :update, :destroy]

  # GET /rqdetails
  # GET /rqdetails.json
  def index
    @rqdetails = Rqdetail.all
  end

  # GET /rqdetails/1
  # GET /rqdetails/1.json
  def show
  end

  # GET /rqdetails/new
  def new
    @rqdetail = Rqdetail.new
  end

  # GET /rqdetails/1/edit
  def edit
  end

  # POST /rqdetails
  # POST /rqdetails.json
  def create
    @rqdetail = Rqdetail.new(rqdetail_params)

    respond_to do |format|
      if @rqdetail.save
        format.html { redirect_to @rqdetail, notice: 'Rqdetail was successfully created.' }
        format.json { render :show, status: :created, location: @rqdetail }
      else
        format.html { render :new }
        format.json { render json: @rqdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rqdetails/1
  # PATCH/PUT /rqdetails/1.json
  def update
    respond_to do |format|
      if @rqdetail.update(rqdetail_params)
        format.html { redirect_to @rqdetail, notice: 'Rqdetail was successfully updated.' }
        format.json { render :show, status: :ok, location: @rqdetail }
      else
        format.html { render :edit }
        format.json { render json: @rqdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rqdetails/1
  # DELETE /rqdetails/1.json
  def destroy
    @rqdetail.destroy
    respond_to do |format|
      format.html { redirect_to rqdetails_url, notice: 'Rqdetail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
      
    # Use callbacks to share common setup or constraints between actions.
    def set_rqdetail
      @rqdetail = Rqdetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rqdetail_params
      params.require(:rqdetail).permit(:requerimiento_id, :codigo, :qty, :unidad_id, :descrip, :placa_destino )
    end


     
end
