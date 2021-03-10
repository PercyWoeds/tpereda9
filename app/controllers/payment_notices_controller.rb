class PaymentNoticesController < ApplicationController
  before_action :set_payment_notice, only: [:show, :edit, :update, :destroy]

  # GET /payment_notices
  # GET /payment_notices.json
  def index
    @payment_notices = PaymentNotice.all
  end

  # GET /payment_notices/1
  # GET /payment_notices/1.json
  def show
  end

  # GET /payment_notices/new
  def new
    @payment_notice = PaymentNotice.new
    @payment_notice[:fecha] = Date.today 


     @company = Company.find(1)
    @employees = @company.get_employees 
    @tramits = @company.get_tramits
    @tipo_tramits = @company.get_tipo_tramits
    @antecedents = @company.get_antecedents
    @proyecto_mineros = @company.get_proyecto_minero 
    @suppliers_clinica = @company.get_supplier_clinica 
    @tecnic_revisions = @company.get_revision_tecnica
    @trucks = @company.get_trucks 
    @antecedents = @company.get_antecedents

 

  end

  # GET /payment_notices/1/edit
  def edit
  end

  # POST /payment_notices
  # POST /payment_notices.json
  def create
    @payment_notice = PaymentNotice.new(payment_notice_params)

    respond_to do |format|
      if @payment_notice.save
        format.html { redirect_to @payment_notice, notice: 'Payment notice was successfully created.' }
        format.json { render :show, status: :created, location: @payment_notice }
      else
        format.html { render :new }
        format.json { render json: @payment_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_notices/1
  # PATCH/PUT /payment_notices/1.json
  def update
    respond_to do |format|
      if @payment_notice.update(payment_notice_params)
        format.html { redirect_to @payment_notice, notice: 'Payment notice was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_notice }
      else
        format.html { render :edit }
        format.json { render json: @payment_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_notices/1
  # DELETE /payment_notices/1.json
  def destroy
    @payment_notice.destroy
    respond_to do |format|
      format.html { redirect_to payment_notices_url, notice: 'Payment notice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end




  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0

    for item in items
      if item != ""
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        product = Service.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_f
        product[:price] = price.to_f
        product[:discount] = discount.to_f
        
        total = product[:price] * product[:quantity]
        total -= total * (product[:discount] / 100)
        
        product[:currtotal] = total
        
        @products.push(product)
      end
      
      i += 1
   end
    
    render :layout => false
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_notice
      @payment_notice = PaymentNotice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_notice_params
      params.require(:payment_notice).permit(:code, :employee_id, :asunto, :fecha, :concepto, :total, :processed, :date_processed)
    end
end


