class CoutsController < ApplicationController
  before_action :set_cout, only: [:show, :edit, :update, :destroy]

  # GET /couts
  # GET /couts.json
  def index
    @couts = Cout.all
  end

  # GET /couts/1
  # GET /couts/1.json
  def show
  end

  # GET /couts/new
  def new
    @cout = Cout.new
  end

  # GET /couts/1/edit
  def edit
  end

  # POST /couts
  # POST /couts.json
  def create
    @cout = Cout.new(cout_params)

    respond_to do |format|
      if @cout.save
        format.html { redirect_to @cout, notice: 'Cout was successfully created.' }
        format.json { render :show, status: :created, location: @cout }
      else
        format.html { render :new }
        format.json { render json: @cout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /couts/1
  # PATCH/PUT /couts/1.json
  def update
    respond_to do |format|
      if @cout.update(cout_params)
        format.html { redirect_to @cout, notice: 'Cout was successfully updated.' }
        format.json { render :show, status: :ok, location: @cout }
      else
        format.html { render :edit }
        format.json { render json: @cout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /couts/1
  # DELETE /couts/1.json
  def destroy
    @cout.destroy
    respond_to do |format|
      format.html { redirect_to couts_url, notice: 'Cout was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cout
      @cout = Cout.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cout_params
      params.require(:cout).permit(:code, :fecha, :importe, :truck_id, :punto_id, :tranportorder_id, :employee_id, :employee2_id, :employee3_id, :peajes, :lavado, :llanta, :alimento, :otros, :monto_recibido, :flete, :recibido_ruta, :vuelto, :descuento, :reembolso, :flete, :ost_id)
    end
end
