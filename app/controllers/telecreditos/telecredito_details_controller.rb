class Telecreditos::TelecreditoDetailsController < ApplicationController
  

  before_action :set_telecredito
  before_action :set_telecredito_detail, except: [:new, :create]  
  
  # GET /telecredito_details
  # GET /telecredito_details.json
  def index
    @telecredito_details = telecreditoDetail.all
  end

  # GET /telecredito_details/1
  # GET /telecredito_details/1.json
  def show
  end

  # GET /telecredito_details/new
  def new
    @telecredito_detail = telecreditoDetail.new
    @employee = Employee.all.order(:full_name).where(active:"1")
    @telecredito_detail[:costo1]
    @telecredito_detail[:costo2]
    @telecredito_detail[:total]
    @telecredito_detail[:total2]
    
  end

  # GET /telecredito_details/1/edit
  def edit
    
  end

  # POST /telecredito_details
  # POST /telecredito_details.json
  def create
    @telecredito_detail = telecreditoDetail.new(telecredito_detail_params)
    @telecredito_detail.telecredito_id  = @telecredito.id 
    
    respond_to do |format|
      if @telecredito_detail.save
        format.html { redirect_to @telecredito, notice: 'telecredito detail was successfully created.' }
        format.json { render :show, status: :created, location: @telecredito }
      else
        format.html { render :new }
        format.json { render json: @telecredito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /telecredito_details/1
  # PATCH/PUT /telecredito_details/1.json
  def update
    @employee = Employee.all 
    @valor = Valor.all
    
    respond_to do |format|
      if @telecredito_detail.update(telecredito_detail_params)
        format.html { redirect_to @telecredito, notice: 'telecredito detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @telecredito }
      else
        format.html { render :edit }
        format.json { render json: @telecredito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /telecredito_details/1
  # DELETE /telecredito_details/1.json
  def destroy
    
    @telecredito_detail.destroy
    
    respond_to do |format|
      format.html { redirect_to telecredito_url, notice: 'telecredito detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
    def set_telecredito 
      @telecredito = Telecredito.find(params[:telecredito_id])
      
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_telecredito_detail
      @telecredito_detail = TelecreditoDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def telecredito_detail_params
      params.require(:telecredito_detail).permit(:item, :descrip, :costo1, :costo2,:telecredito_id,:total,:total2,:qty)
    end
end
