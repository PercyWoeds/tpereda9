class CoutsController < ApplicationController
  before_action :set_cout, only: [:show, :edit, :update, :destroy]

  # GET /couts
  # GET /couts.json
  def index
    @couts = Cout.all
      @company = Company.find(1)
  end

  # GET /couts/1
  # GET /couts/1.json
  def show
  end

  # GET /couts/new
  def new
    @cout = Cout.new

    @company   = Company.find(1)

      @employees = @company.get_employees() 

      @cout[:fecha] = Date.today 

      @cout[:importe] = 0.00
  end

  # GET /couts/1/edit
  def edit

      @company   = Company.find(1)


  end

  # POST /couts
  # POST /couts.json
  def create
    @cout = Cout.new(cout_params)

    respond_to do |format|
      if @cout.save
        format.html { redirect_to @cout, notice: 'Cout was successfully created.' }
        format.json { render :show, status: :created, location: @cout }
      else
        format.html { render :new }
        format.json { render json: @cout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /couts/1
  # PATCH/PUT /couts/1.json
  def update
    respond_to do |format|
      if @cout.update(cout_params)
        format.html { redirect_to @cout, notice: 'Cout was successfully updated.' }
        format.json { render :show, status: :ok, location: @cout }
      else
        format.html { render :edit }
        format.json { render json: @cout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /couts/1
  # DELETE /couts/1.json
  def destroy
    @cout.destroy
    respond_to do |format|
      format.html { redirect_to couts_url, notice: 'Cout was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

def get_employee(id)

  a = Employee.find(id)

  return a.full_name 



end 

def do_crear

    @company = Company.find(1)

    @action_txt = "do_crear" 
    @tranportorder = Tranportorder.find(params[:id] ) 

    puts params[:total_importe]

    puts "checked "

   puts params[:emp1]

      puts params[:emp2]
         puts params[:emp3]


    if params[:emp1] == "true"
        @employee_id = @tranportorder.employee_id
    end 
 if params[:emp2] == "true"
        @employee_id = @tranportorder.employee2_id
    end 

 if params[:emp3] == "true"
        @employee_id = @tranportorder.employee3_id
    end 
 if params[:emp4] == "true"
        @employee_id = @tranportorder.employee4_id
    end 


    if params[:placa1] == "true"
        @placa = @tranportorder.truck_id
    end 
 if params[:placa2] == "true"
        @placa = @tranportorder.truck2_id
    end 

 if params[:placa3] == "true"
        @placa = @tranportorder.truck3_id
    end 


    @couts = Cout.new
    @couts[:code] = @couts.generate_cout_number

    puts "code ----"

    puts @couts[:code]
    puts @employee_id
    
    puts @placa 
    


    @couts[:fecha] =  params[:fecha]
    @couts[:importe] = params[:total_importe]
    @couts[:tbk] = params[:tbk]
    @couts[:tbk_documento] = params[:tbk_documento]
    @couts[:truck_id] = @placa 
    @couts[:tranportorder_id] = @tranportorder.id
    @couts[:employee_id] = @employee_id
    @couts[:peajes] =  0
    @couts[:lavado] = 0
    @couts[:llanta] = 0
    @couts[:alimento] = 0
    @couts[:otros] = 0
    @couts[:monto_recibido] = 0
    @couts[:flete] = 0
    @couts[:recibido_ruta] = 0
    @couts[:vuelto] = 0
    @couts[:descuento] = 0
    @couts[:reembolso] = 0
    
     respond_to do |format|
       if    @couts.save           
        
          format.html { redirect_to("/companies/couts/do_cargar/#{@company.id}", :notice => 'Comprobante fue grabada con exito .') }
          format.xml  { render :xml => @couts, :status => :created, :location => @couts}
        else

          format.html { redirect_to("/companies/couts/do_cargar/#{@company.id}", :notice  => 'Ocurrio un error .') }
          format.xml  { render :xml => @couts.errors, :status => :unprocessable_entity }
        end 
        
      end


end 

def do_cargar
  @company   = Company.find(1)
   @osts   = Tranportorder.where(["fecha1 >= ?","2020-11-01 00:00:00"]).order("fecha desc ,code desc ").paginate(:page => params[:page])
                 
end 


def newviatico


@tranportorder =   Tranportorder.find(params[:id])



end 

  def update_employee

     @employees = Employee.where(params[:employee_id])
    # map to name and id for use in our options_for_select
     puts @employee.id
   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cout
      @cout = Cout.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cout_params
      params.require(:cout).permit(:code, :fecha, :importe, :truck_id, :punto_id, :tranportorder_id, :employee_id, :employee2_id, 
        :employee3_id, :peajes, :lavado, :llanta, :alimento, :otros, :monto_recibido, :flete, :recibido_ruta, :vuelto, :descuento, 
        :reembolso, :flete, :ost_id,:tnk,:tbk_documento)
    end
end
