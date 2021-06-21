class MntosController < ApplicationController
  before_action :set_mnto, only: [:show, :edit, :update, :destroy]

  # GET /mntos
  # GET /mntos.json
  def index
    @mntos = Mnto.all
  end

  # GET /mntos/1
  # GET /mntos/1.json
  def show

 @company =  Company.find(1)
      @trucks = @company.get_trucks
    @divisions  = @company.get_divisions()

    @mnto_detail =  @mnto.mnto_details.order("mnto_details.activity_id")
      
  end

  # GET /mntos/new

  def new
    @company =  Company.find(1)
    @mnto = Mnto.new

    @mnto[:fecha]  = Date.today 

    @mnto[:fecha2]  = Date.today 
    @trucks = @company.get_trucks
    @divisions  = @company.get_divisions()
     @mnto[:division_id]  = 7

     

  end

  # GET /mntos/1/edit
  def edit
    @company =  Company.find(1)
    @trucks = @company.get_trucks
    @divisions  = @company.get_divisions()

  end

  # POST /mntos
  # POST /mntos.json
  def create
    @mnto = Mnto.new(mnto_params)
    @company =  Company.find(1)
    @trucks = @company.get_trucks
    @divisions  = @company.get_divisions()

   if  params[:tipo] == "1"
      @lcSerie =  1
   end 
   if  params[:tipo] == "2"
      @lcSerie =  2
   end 
   if  params[:tipo] == "3"
      @lcSerie =  3
   end 
   

   @mnto[:code] = @mnto.generate_mnto_number(@lcSerie)  
  
   @mnto[:user_id]   = @current_user.id 
   @mnto[:tipo] = params[:tipo] 


    respond_to do |format|
      if @mnto.save

             @detalle =  @mnto.get_activity( @mnto[:tipo])  
         for actividad in @detalle 

               mnto_detail =  MntoDetail.new( activity_id: actividad.id, process: "0", mnto_id: @mnto.id) 
               begin 
                 mnto_detail.save
               rescue
               end 



         end 

        format.html { redirect_to @mnto, notice: 'Mnto was successfully created.' }
        format.json { render :show, status: :created, location: @mnto }
      else
        format.html { render :new }
        format.json { render json: @mnto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mntos/1
  # PATCH/PUT /mntos/1.json
  def update
    @company =  Company.find(1)
    @trucks = @company.get_trucks
    @divisions  = @company.get_divisions()

    respond_to do |format|
      if @mnto.update(mnto_params)
        format.html { redirect_to @mnto, notice: 'Mnto was successfully updated.' }
        format.json { render :show, status: :ok, location: @mnto }
      else
        format.html { render :edit }
        format.json { render json: @mnto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mntos/1
  # DELETE /mntos/1.json
  def destroy
    @mnto.destroy
    respond_to do |format|
      format.html { redirect_to mntos_url, notice: 'Mnto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end




  def do_anular
    @invoice = Mnto.find(params[:id])


   a = Manifestship.find_by(:mnto_id=> @invoice.id)
    if a 
    flash[:notice] = "So


        º

        licitud de Transporte tiene OST asignadas, no se puede anular."
    
    else

    @invoice[:processed] = "2"
    @invoice.anular 
    
    flash[:notice] = "Documento a sido anulado."
    end 
    redirect_to @invoice 



  end


  def sendcancelar 
    
    @company  = Company.find(1)
    @mnto = Mnto.find(params[:id])

  end


  def do_cancelar


    @company =  Company.find(1)
    @mnto = Mnto.find(params[:id])
    @observa  = params[:motivo]
  
    @mnto[:processed] = "3"

     @mnto.update_attributes(:motivo => @observa,:processed =>"3") 
     @mnto.cancelar
    
    
    flash[:notice] = "Motivo grabado."
    redirect_to "/mntos/#{@mnto.id}"

  end

  # Send invoice via email
  def cancela
    @mnto = Mnto.find(params[:id])
    @company = @mnto.company
  end

   def do_process
    @mnto  = Mnto.find(params[:id])
    @mnto[:processed] = "1"


    @mnto.process
    
    flash[:notice] = "El documento ha sido procesado."
    redirect_to @mnto 
  end

  def self.search(search)
      where("code LIKE ?", "%#{search}%") 
        
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mnto
      @mnto = Mnto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mnto_params
      params.require(:mnto).permit(:code, :division_id, :ocupacion_id, :fecha, :truck_id, :km_programado,
       :km_actual, :fecha2, :user_id, :processed, :date_processed,:tipo)
    end
end
