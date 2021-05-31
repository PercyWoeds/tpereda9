class Vueltos::VueltoDetailsController < ApplicationController
    
  before_action :set_vuelto 


  before_action :set_vuelto_detail, only: [:show, :edit, :update, :destroy]

  # GET /vuelto_details
  # GET /vuelto_details.json
  def index
    @vuelto_details = VueltoDetail.all
  end

  # GET /vuelto_details/1
  # GET /vuelto_details/1.json
  def show
      @company   =  Company.find(1)

  end

  # GET /vuelto_details/new
  def new
    @company   =  Company.find(1)
    @vuelto_detail = VueltoDetail.new



    @vuelto_detail[:fecha] = Date.today 
    @vuelto_detail[:importe] = 0.00
    @vuelto_detail[:flete]   =  0.00
    @vuelto_detail[:egreso]  =  0.00
    @vuelto_detail[:total ]  =  0.00

  end

  # GET /vuelto_details/1/edit
  def edit
    @company   =  Company.find(1)
  end

  # POST /vuelto_details
  # POST /vuelto_details.json
  def create
    @company   =  Company.find(1)
    @vuelto_detail = VueltoDetail.new(vuelto_detail_params)

    items = params[:items]
     puts "0ddddd"
         
     puts   params[:vuelto_detail][:fecha]

     puts   params[:vuelto_detail][:observa]

     puts items 

    respond_to do |format|

      

      if @vuelto_detail.save

         @vuelto.add_products(items,params[:vuelto_detail][:fecha],params[:vuelto_detail][:observa] )        
        # Check if we gotta process the ajust
    
        format.html { redirect_to @vuelto_detail, notice: 'Vuelto detail was successfully created.' }
        format.json { render :show, status: :created, location: @vuelto_detail }
      else
        format.html { render :new }
        format.json { render json: @vuelto_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vuelto_details/1
  # PATCH/PUT /vuelto_details/1.json
  def update
    respond_to do |format|
      if @vuelto_detail.update(vuelto_detail_params)
        format.html { redirect_to @vuelto_detail, notice: 'Vuelto detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @vuelto_detail }
      else
        format.html { render :edit }
        format.json { render json: @vuelto_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vuelto_details/1
  # DELETE /vuelto_details/1.json
  def destroy
    @vuelto_detail.destroy
    respond_to do |format|
      format.html { redirect_to vuelto_details_url, notice: 'Vuelto detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private


  private

 # Use callbacks to share common setup or constraints between actions.
    def set_vuelto
      @vuelto = Vuelto.find(params[:vuelto_id])
    end 
    
   
    # Use callbacks to share common setup or constraints between actions.
    def set_vuelto_detail
      @vuelto_detail = VueltoDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vuelto_detail_params
      params.require(:vuelto_detail).permit(:fecha, :cout_id, :importe, :flete, :egreso, :total, :observa, :vuelto_id)
    end
end
