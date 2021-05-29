class VueltosController < ApplicationController
  before_action :set_vuelto, only: [:show, :edit, :update, :destroy]

  # GET /vueltos
  # GET /vueltos.json
  def index
    @vueltos = Vuelto.all
  end

  # GET /vueltos/1
  # GET /vueltos/1.json
  def show

    @vuelto  = Vuelto.find(params[:id])
    
    @vuelto_detail =  @vuelto.vuelto_details
    
    
     respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vuelto   }
    end
  end

  # GET /vueltos/new
  def new
    @vuelto = Vuelto.new
    
  end

  # GET /vueltos/1/edit
  def edit
  end

  # POST /vueltos
  # POST /vueltos.json
  def create
    @vuelto = Vuelto.new(vuelto_params)

     @vuelto[:code]  =   @vuelto.generate_viatico_number
     @vuelto[:user_id]  =  current_user.id 
     @vuelto[:processed]  =   "0"
    respond_to do |format|
      if @vuelto.save
        format.html { redirect_to @vuelto, notice: 'Vuelto was successfully created.' }
        format.json { render :show, status: :created, location: @vuelto }
      else
        format.html { render :new }
        format.json { render json: @vuelto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vueltos/1
  # PATCH/PUT /vueltos/1.json
  def update
    respond_to do |format|
      if @vuelto.update(vuelto_params)
        format.html { redirect_to @vuelto, notice: 'Vuelto was successfully updated.' }
        format.json { render :show, status: :ok, location: @vuelto }
      else
        format.html { render :edit }
        format.json { render json: @vuelto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vueltos/1
  # DELETE /vueltos/1.json
  def destroy
    @vuelto.destroy
    respond_to do |format|
      format.html { redirect_to vueltos_url, notice: 'Vuelto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def ac_couts 
    @couts = Cout.where([" (code  iLIKE ?)", "%" + params[:q] + "%"])
   
    render :layout => false
  end

  def list_items3
    
    @company = Company.find(1)
    items = params[:items3]
    items = items.split(",")
    items_arr = []
    @guias = []
    i = 0
    puts "item list items3 "
    puts items 
    
    for item in items
      if item != ""
        parts = item.split("|BRK|")

        puts parts

        id = parts[0]      
        product = Cout.find(id.to_i)
        product[:i] = i

        @guias.push(product)

      end
      
      i += 1
    end

    render :layout => false
  end 
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vuelto
      @vuelto = Vuelto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vuelto_params
      params.require(:vuelto).permit(:code, :fecha, :user_id, :processed, :date_processed, :total)
    end
end
