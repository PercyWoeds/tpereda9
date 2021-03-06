class TelecreditosController < ApplicationController
  
  before_action :set_telecredito, only: [:show, :edit, :update, :destroy]


  # GET /telecreditos
  # GET /telecreditos.json
  def index
    @telecreditos = Telecredito.all
  end

  # GET /telecreditos/1
  # GET /telecreditos/1.json
  def show
      company = Company.find(1)
      @suppliers = company.get_suppliers
      @telecredito_details = @telecredito.telecredito_details

  end

 
def newtelecredito 
    
    @company = Company.find(1)
    @factura = Telecredito.find(params[:factura_id])
    @supplier  = Supplier.find(params[:supplier_id]) 

    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    
    @supplier_name = @customer.name

    @telecredito_details = Telecredito.new
  
    @detalleitems =  Purchase.where("date2 >=? and date2 <=? and balance <> 0 and supplier_id = ? 
     ","#{@fecha1} 00:00:00","#{@fecha2} 23:59:59","0",@supplier).order(:fecha)
    
  
  end 



  # GET /telecreditos/new
  def new

    @company = Company.find(1)
    
    @telecredito = Telecredito.new
    @bank_acounts = @company.get_bank_acounts()     

    @telecredito[:fecha1] =Date.today
    @telecredito[:fecha2] =Date.today
  end

  # GET /telecreditos/1/edit
  def edit
  end

  # POST /telecreditos
  # POST /telecreditos.json
  def create
    @telecredito = Telecredito.new(telecredito_params)

    respond_to do |format|
      if @telecredito.save
        format.html { redirect_to @telecredito, notice: 'Telecredito was successfully created.' }
        format.json { render :show, status: :created, location: @telecredito }
      else
        format.html { render :new }
        format.json { render json: @telecredito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /telecreditos/1
  # PATCH/PUT /telecreditos/1.json
  def update
    respond_to do |format|
      if @telecredito.update(telecredito_params)
        format.html { redirect_to @telecredito, notice: 'Telecredito was successfully updated.' }
        format.json { render :show, status: :ok, location: @telecredito }
      else
        format.html { render :edit }
        format.json { render json: @telecredito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /telecreditos/1
  # DELETE /telecreditos/1.json
  def destroy
    @telecredito.destroy
    respond_to do |format|
      format.html { redirect_to telecreditos_url, notice: 'Telecredito was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_telecredito
      @telecredito = Telecredito.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def telecredito_params
      params.require(:telecredito).permit(:fecha1, :fecha2, :code, :bank_acount_id, :importe)
    end
end
