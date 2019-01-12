class Quotations::QuotationDetailsController < ApplicationController
  

  before_action :set_quotation
  before_action :set_quotation_detail, except: [:new, :create]  
  
  # GET /quotation_details
  # GET /quotation_details.json
  def index
    @quotation_details = QuotationDetail.all
  end

  # GET /quotation_details/1
  # GET /quotation_details/1.json
  def show
  end

  # GET /quotation_details/new
  def new
    @quotation_detail = QuotationDetail.new
    @employee = Employee.all.order(:full_name).where(active:"1")
    @quotation_detail[:costo1]
    @quotation_detail[:costo2]
    @quotation_detail[:total]
    @quotation_detail[:total2]
    
  end

  # GET /quotation_details/1/edit
  def edit
    
  end

  # POST /quotation_details
  # POST /quotation_details.json
  def create
    @quotation_detail = QuotationDetail.new(quotation_detail_params)
    @quotation_detail.quotation_id  = @quotation.id 
    
    respond_to do |format|
      if @quotation_detail.save
        format.html { redirect_to @quotation, notice: 'Quotation detail was successfully created.' }
        format.json { render :show, status: :created, location: @quotation }
      else
        format.html { render :new }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotation_details/1
  # PATCH/PUT /quotation_details/1.json
  def update
    @employee = Employee.all 
    @valor = Valor.all
    
    respond_to do |format|
      if @quotation_detail.update(quotation_detail_params)
        format.html { redirect_to @quotation, notice: 'Quotation detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @quotation }
      else
        format.html { render :edit }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotation_details/1
  # DELETE /quotation_details/1.json
  def destroy
    
    @quotation_detail.destroy
    
    respond_to do |format|
      format.html { redirect_to quotation_url, notice: 'Quotation detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
    def set_quotation 
      @quotation = Quotation.find(params[:quotation_id])
      
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_quotation_detail
      @quotation_detail = QuotationDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quotation_detail_params
      params.require(:quotation_detail).permit(:item, :descrip, :costo1, :costo2,:quotation_id,:total,:total2,:qty)
    end
end
