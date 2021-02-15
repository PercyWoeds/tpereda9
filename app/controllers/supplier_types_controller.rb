class SupplierTypesController < ApplicationController
  before_action :set_supplier_type, only: [:show, :edit, :update, :destroy]

  # GET /supplier_types
  # GET /supplier_types.json
  def index
    @supplier_types = SupplierType.all
  end

  # GET /supplier_types/1
  # GET /supplier_types/1.json
  def show
  end

  # GET /supplier_types/new
  def new
    @supplier_type = SupplierType.new
  end

  # GET /supplier_types/1/edit
  def edit
  end

  # POST /supplier_types
  # POST /supplier_types.json
  def create
    @supplier_type = SupplierType.new(supplier_type_params)

    respond_to do |format|
      if @supplier_type.save
        format.html { redirect_to @supplier_type, notice: 'Supplier type was successfully created.' }
        format.json { render :show, status: :created, location: @supplier_type }
      else
        format.html { render :new }
        format.json { render json: @supplier_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplier_types/1
  # PATCH/PUT /supplier_types/1.json
  def update
    respond_to do |format|
      if @supplier_type.update(supplier_type_params)
        format.html { redirect_to @supplier_type, notice: 'Supplier type was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier_type }
      else
        format.html { render :edit }
        format.json { render json: @supplier_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplier_types/1
  # DELETE /supplier_types/1.json
  def destroy
    @supplier_type.destroy
    respond_to do |format|
      format.html { redirect_to supplier_types_url, notice: 'Supplier type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_type
      @supplier_type = SupplierType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_type_params
      params.require(:supplier_type).permit(:code, :name)
    end
end
