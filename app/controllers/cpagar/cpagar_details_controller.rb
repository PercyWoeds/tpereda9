  
 class Cpagar::CpagarDetailsController < ApplicationController
  
  before_action :set_cpagar 
  before_action :set_cpagar_detail, only: [:show, :edit, :update, :destroy]
  

  # GET /cpagar_details
  # GET /cpagar_details.json
  def index
    @cpagar_details = CpagarDetail.all
  end

  # GET /cpagar_details/1
  # GET /cpagar_details/1.json
  def show
  end

  # GET /cpagar_details/new
  def new
    @cpagar_detail = CpagarDetail.new

    @supplier = Supplier.all.order(:name).where(active:"1")
  
    
  end

  # GET /cpagar_details/1/edit
  def edit
        @supplier = Supplier.all.order(:name).where(active:"1")


  end

  # POST /cpagar_details
  # POST /cpagar_details.json
  def create

    @cpagar_detail = CpagarDetail.new(cpagar_detail_params)
    @cpagar_detail.cpagar_id  = @cpagar.id 
    
    @cpagar_detail = CpagarDetail.new(cpagar_detail_params)

    respond_to do |format|
      if @cpagar_detail.save
        format.html { redirect_to @cpagar_detail, notice: 'Cancelacion Detalle fue creado satisfactoriamemnte' }
        format.json { render :show, status: :created, location: @cpagar_detail }
      else
        format.html { render :new }
        format.json { render json: @cpagar_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cpagar_details/1
  # PATCH/PUT /cpagar_details/1.json
  def update
    respond_to do |format|
      if @cpagar_detail.update(cpagar_detail_params)
        format.html { redirect_to @cpagar_detail, notice: 'Cpagar detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @cpagar }
      else
        format.html { render :edit }
        format.json { render json: @cpagar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cpagar_details/1
  # DELETE /cpagar_details/1.json
  def destroy
    @cpagar_detail.destroy
    respond_to do |format|
      format.html { redirect_to cpagar_url, notice: 'Cpagar detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_cpagar 
      @cpagar = Cpagar.find(params[:cpagar_id])
      
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_cpagar_detail
      @cpagar_detail = CpagarDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cpagar_detail_params
      params.require(:cpagar_detail).permit(:document_id, :documento, :supplier_id, :tm, :total, :descrip, :cpagar_id)
    end
end
