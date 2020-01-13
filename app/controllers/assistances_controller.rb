class AssistancesController < ApplicationController
  before_action :set_assistance, only: [:show, :edit, :update, :destroy]

  # GET /assistances
  # GET /assistances.json
  def index
    @assistances = Assistance.all.order(:fecha ).paginate(:page => params[:page])
  end

  # GET /join
  # GET /assistances/1.json
  def show
  end


  # GET /assistances/new
  def new
    @assistance = Assistance.new

    @company = Company.find(1)
    @employees = @company.get_employees
    @inasists = @company.get_inasists


    now = Time.now.in_time_zone.change( hour: 8)
    puts "horaxxxxxxx"
    puts now.to_s 

    @assistance['fecha'] = Date.today
    @assistance['hora1'] = Time.now.in_time_zone.change( hour: 8) 
    @assistance['hora2'] = Time.now.in_time_zone.change( hour: 17, min: 45)
    @assistance['hora_efectivo'] = Time.now.in_time_zone.change( hour: 8)
    @assistance['hora_efectivo2'] = Time.now.in_time_zone.change( hour: 18, min: 30)
        

  end

  # GET /assistances/1/edit
  def edit
    @company = Company.find(1)

    @employees = @company.get_employees
    
    @inasists = @company.get_inasists

  end

  # POST /assistances
  # POST /assistances.json
  def create

    @company = Company.find(1)

    @employees = @company.get_employees
    
    @inasists = @company.get_inasists    

    @assistance = Assistance.new(assistance_params)

    @assistance[:equipo] ="1"
    @assistance[:cod_verificacion] ="FP"
    @assistance[:num_tarjeta] =""
    



    respond_to do |format|
      if @assistance.save
        format.html { redirect_to @assistance, notice: 'Registro creado con exito.' }
        format.json { render :show, status: :created, location: @assistance }
      else
        format.html { render :new }
        format.json { render json: @assistance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assistances/1
  # PATCH/PUT /assistances/1.json
  def update

    @company = Company.find(1)

    @employees = @company.get_employees
    
    @inasists = @company.get_inasists


    respond_to do |format|
      if @assistance.update(assistance_params)
        format.html { redirect_to @assistance, notice: 'Registro actualizado con exito ' }
        format.json { render :show, status: :ok, location: @assistance }
      else
        format.html { render :edit }
        format.json { render json: @assistance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assistances/1
  # DELETE /assistances/1.json
  def destroy

    @assistance.destroy

    respond_to do |format|
      format.html { redirect_to assistances_url, notice: 'Assistance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
      Time.zone = "America/Lima"
      Assistance.import(params[:file])
      Time.zone = "Lima"
      
       redirect_to root_url, notice: "Informacio  de asistencia  importadas."
  end 



def generar
        
    @company = Company.find(1)
    @users = @company.get_users()

end 

def generar1
        
    @company = Company.find(1)
    @users = @company.get_users()

end 


# Process an invoice
  def do_process
  
    fecha_asistencia = params[:fecha1]

    @assistance = Assistance.first 
    
      @assistance.process(fecha_asistencia)
      flash[:notice] = "Asistencia generada ..."
      redirect_to assistances_path
   
    
  end

    
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assistance
      @assistance = Assistance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assistance_params
      params.require(:assistance).permit(:departamento, :nombre, :nro, :fecha, :equipo, :cod_verificacion, :num_tarjeta,:hora1,:hora2,:hora_efectivo, :inasist_id,:observacion,:hora_efectivo2,:employee_id)
    end
end
