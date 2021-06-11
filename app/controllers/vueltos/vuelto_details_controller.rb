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
         @employees = @company.get_employees
     @puntos   =  @company.get_puntos 
     @trucks  =  @company.get_trucks 

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

    @employees = @company.get_employees
     @puntos   =  @company.get_puntos 
     @trucks  =  @company.get_trucks 
  end

  # GET /vuelto_details/1/edit
  def edit
    @company   =  Company.find(1)
       @employees = @company.get_employees
     @puntos   =  @company.get_puntos 
     @trucks  =  @company.get_trucks 
  end

  # POST /vuelto_details
  # POST /vuelto_details.json
  def create
    @company   =  Company.find(1)
    @vuelto_detail = VueltoDetail.new(vuelto_detail_params)
    @vuelto_detail.vuelto_id  = @vuelto.id 
    @employees = @company.get_employees
     @puntos   =  @company.get_puntos 
     @trucks  =  @company.get_trucks 

   
     puts "0ddddd"
     puts   params[:vuelto_detail][:fecha]
     puts   params[:vuelto_detail][:observa]

    @vuelto_detail[:code ] = @vuelto_detail.generate_vuelto_number(1)
     @vuelto_detail[:total] = params[:vuelto_detail][:importe].to_f + params[:vuelto_detail][:flete].to_f + 
                              params[:vuelto_detail][:egreso].to_f
  

    respond_to do |format|

    
      if @vuelto_detail.save
        @vuelto[:total] =  @vuelto.get_total
        @vuelto.save 
             
        # Check if we gotta process the ajust
    
        format.html { redirect_to @vuelto, notice: 'Vuelto detail was successfully created.' }
        format.json { render :show, status: :created, location: @vuelto }
      else
        format.html { render :new }
        format.json { render json: @vuelto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vuelto_details/1
  # PATCH/PUT /vuelto_details/1.json
  def update

   
     @vuelto_detail[:total] = params[:vuelto_detail][:importe].to_f + params[:vuelto_detail][:flete].to_f + 
                              params[:vuelto_detail][:egreso].to_f
   
    puts params[:vuelto_detail][:importe]
    puts params[:vuelto_detail][:flete] 
    puts params[:vuelto_detail][:egreso] 

    puts 'Vuelto Total .'
    puts @vuelto_detail[:total]

    respond_to do |format|
      if @vuelto_detail.update(vuelto_detail_params)

        @vuelto[:total] =  @vuelto.get_total
        @vuelto.save 

        
        format.html { redirect_to @vuelto, notice: 'Vuelto detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @vuelto }
      else
        format.html { render :edit }
        format.json { render json: @vuelto.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /vuelto_details/1
  # DELETE /vuelto_details/1.json
  def destroy
    @vuelto_detail.destroy
    respond_to do |format|
      format.html { redirect_to @vuelto, notice: 'Vuelto detail was successfully destroyed.' }
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
      params.require(:vuelto_detail).permit(:fecha, :cout_id, :importe, :flete, :egreso, :total, :observa, :vuelto_id,
        :employee_id, :ubication_id, :ubication2_id, :truck_id , :truck2_id , :truck3_id )
    end
end
