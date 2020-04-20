class Suppliers::SupplierDetailsController < ApplicationController
  before_action :set_supplier
  before_action :set_supplier_detail, :except => [:new, :create ]

  # GET /supplier_details
  # GET /supplier_details.json
  def index
    @supplier_details = SupplierDetail.all
  end

  # GET /supplier_details/1
  # GET /supplier_details/1.json
  def show
  end

  # GET /supplier_details/new
  def new
    @supplier_detail = SupplierDetail.new
  end

  # GET /supplier_details/1/edit
  def edit
  end

  # POST /supplier_details
  # POST /supplier_details.json
  def create
    @supplier_detail = SupplierDetail.new(supplier_detail_params)
    @supplier_detail.supplier_id  = @supplier.id 

    respond_to do |format|
      if @supplier_detail.save
        format.html { redirect_to @supplier, notice: 'Supplier detail was successfully created.' }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new }
        format.json { render json: @supplier_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplier_details/1
  # PATCH/PUT /supplier_details/1.json
  def update

     @supplier_detail.supplier_id  = @supplier.id 
    respond_to do |format|
      if @supplier_detail.update(supplier_detail_params)
        format.html { redirect_to @supplier, notice: 'Supplier detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /supplier_details/1
  # DELETE /supplier_details/1.json
  def destroy



   if  @supplier_detail.destroy

flash[:notice]= "Item fue eliminado satisfactoriamente "
      redirect_to @supplier 
    else
      flash[:error]= "Item ha tenido un error y no fue eliminado"
      render :show 
    end 
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_supplier
      @supplier = Supplier.find(params[:supplier_id])
    end 
    
    def set_supplier_detail
      @supplier_detail = SupplierDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_detail_params
      params.require(:supplier_detail).permit(:name, :cargo, :telefono, :correo, :area, :supplier_id)
    end
end
