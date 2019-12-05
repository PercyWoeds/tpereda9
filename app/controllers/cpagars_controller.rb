class CpagarsController < ApplicationController
  before_action :set_cpagar, only: [:show, :edit, :update, :destroy]

  # GET /cpagars
  # GET /cpagars.json
  def index
    @cpagars = Cpagar.all
  end

  # GET /cpagars/1
  # GET /cpagars/1.json
  def show
    @cpagar_details= @cpagar.cpagar_details

  end

  # GET /cpagars/new
  def new
    @cpagar = Cpagar.new
    @company =Company.find(1)
     @bank_acounts = @company.get_bank_acounts()        
    @monedas  = @company.get_monedas()
    @documents  = @company.get_documents()
    @cpagar.fecha1 = Date.today 
    @cpagar[:code] = "#{generate_guid9()}"
    @cpagar[:processed] = false
   

  end

  # GET /cpagars/1/edit
  def edit
  end

  # POST /cpagars
  # POST /cpagars.json
  def create
    @cpagar = Cpagar.new(cpagar_params)

    respond_to do |format|
      if @cpagar.save
        format.html { redirect_to @cpagar, notice: 'Cpagar was successfully created.' }
        format.json { render :show, status: :created, location: @cpagar }
      else
        format.html { render :new }
        format.json { render json: @cpagar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cpagars/1
  # PATCH/PUT /cpagars/1.json
  def update
    respond_to do |format|
      if @cpagar.update(cpagar_params)
        format.html { redirect_to @cpagar, notice: 'Cpagar was successfully updated.' }
        format.json { render :show, status: :ok, location: @cpagar }
      else
        format.html { render :edit }
        format.json { render json: @cpagar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cpagars/1
  # DELETE /cpagars/1.json
  def destroy
    @cpagar.destroy
    respond_to do |format|
      format.html { redirect_to cpagars_url, notice: 'Cpagar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  
  # Autocomplete for documents
  def ac_documentos
    @docs = Purchase.where(["company_id = ? AND (documento iLIKE ? )", params[:company_id], "%" + params[:q] + "%"])   
    render :layout => false
  end
  
  # Autocomplete for products
  def ac_suppliers
    @supplier = Supplier.where(["company_id = ? AND (ruc iLIKE ? OR name iLIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])   
    render :layout => false
  end
  
  # Autocomplete for users
  def ac_user
    company_users = CompanyUser.where(company_id: params[:company_id])
    user_ids = []
    
    for cu in company_users
      user_ids.push(cu.user_id)
    end
    
    @users = User.where(["id IN (#{user_ids.join(",")}) AND (email LIKE ? OR username LIKE ?)", "%" + params[:q] + "%", "%" + params[:q] + "%"])
    alr_ids = []
    
    for user in @users
      alr_ids.push(user.id)
    end
    
    if(not alr_ids.include?(getUserId()))
      @users.push(current_user)
    end
   
    render :layout => false
  end
  
  # Autocomplete for suppliers
  def ac_suppliers
    @suppliers = Supplier.where(["company_id = ? AND  (ruc LIKE ? ) ", params[:company_id],  "%" + params[:q] + "%"])

    render :layout => false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cpagar
      @cpagar = Cpagar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cpagar_params
      params.require(:cpagar).permit(:company_id, :location_id, :division_id, :bank_acount_id, :document_id, :documento, :supplier_id, :tm, :total, :fecha1, :fecha2, :nrooperacion, :operacion, :comments, :user_id, :processed, :date_processed, :code)
    end
end
