class EmployeesController < ApplicationController
  before_filter :authenticate_user!
    
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  
  

  def import
      Employee.import(params[:file])
       redirect_to root_url, notice: "Empleados importadas."
  end 
  
  # GET /employees
  # GET /employees.json
  def index
    
    if params[:search]
      @employees = Employee.paginate(:page => params[:page], :per_page => 20).search(params[:search]).order("lastname ")
    else
      @employees = Employee.paginate(:page => params[:page], :per_page => 20).where(active: "1",planilla:"1").order('lastname ')
    end
        
 respond_to do |format|
    format.html
    format.xls # { send_data @products.to_csv(col_sep: "\t") }
  end


end 
  # GET /employees/1
  # GET /employees/1.json
  def show


  end


  # Autocomplete for customers
  def ac_distritos
   


       @distritos = Distrito.find_by_sql(["Select distritos.id,distritos.code, distritos.name as a,provins.name as b,
     dptos.name  as c
    from distritos INNER JOIN provins ON SUBSTRING(distritos.code,1,4) = SUBSTRING(provins.code,1,4)
                   INNER JOIN dptos on SUBSTRING(provins.code,1,2) = SUBSTRING(dptos.code,1,2) 
                   WHERE  (distritos.name iLIKE ? )",  "%" + params[:q] + "%"])


    render :layout => false
  end



  # GET /employees/new
  def new
    @company = Company.find(1)

    @employee = Employee.new
    @categorias =Categorium.all 
    @afps = Afp.all
    @employee.fecha_nacimiento = Date.today
    @employee.fecha_ingreso    = Date.today
    @employee.fecha_cese    = Date.today
    @locations =Location.all
    @divisions =Division.all 
    @ocupacions = Ocupacion.all 
    @ccostos = Ccosto.all
    @employee[:company_id]=1
    @employee[:hora_ex]=0
    @employee[:efectivo]=0

    @dptos = Dpto.all 
    @provins = Provin.all 


    
  end

  # GET /employees/1/edit
  def edit

     @company = Company.find(1)
    @categorias =Categorium.all 
    @afps = Afp.all
    @locations =Location.all
    @divisions =Division.all 
    @ocupacions = Ocupacion.all 
    @ccostos = Ccosto.all
      @employee[:company_id]=1

        @dptos = Dpto.all 
    @provins = Provin.all 
    @distritos = Distrito.all 

    if !@employee.distrito_id.nil?

      @ac_distrito0 = Distrito.find(@employee.distrito_id) 
      @ac_distrito  = @ac_distrito0.name 

       @ac_distrito_id  = @employee.distrito_id
    
    else
       @ac_distrito = " "
       @ac_distrito_id = @employee.distrito_id
    end 
  


  end

  # POST /employees
  # POST /employees.json
  def create

     @company = Company.find(1)
    @employee = Employee.new(employee_params)
    @categorias =Categorium.all 
     @locations =Location.all
    @divisions =Division.all 
    @ocupacions = Ocupacion.all 
    @ccostos = Ccosto.all
      @employee[:company_id]=1
    @afps = Afp.all

      @dptos = Dpto.all 
    @provins = Provin.all 
    @distritos = Distrito.all 



    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update

     @company = Company.find(1)
     @employee[:company_id] = 1

     @categorias =Categorium.all 
    @afps = Afp.all
    @employee.fecha_nacimiento = Date.today
    @employee.fecha_ingreso    = Date.today
    @employee.fecha_cese    = Date.today
    @locations =Location.all
    @divisions =Division.all 
    @ocupacions = Ocupacion.all 
    @ccostos = Ccosto.all

    @dptos = Dpto.all 
    @provins = Provin.all 
    @distritos = Distrito.all 


    
    
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    
    a = PayrollDetail.find_by(employee_id: @employee.id)
    if a 
    else 
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
    
  end 
  end


  def ac_employees
    @employees = Employee.where(["company_id = ? AND (idnumber LIKE ? OR full_name  iLIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])  
    render :layout => false
  end




  def update_provincias

     dpto_id = Dpto.find_by(code: params[:dpto_id])
    # map to name and id for use in our options_for_select
     puts "upppdaeteeeeeeeeeeeeeeeeeeee"
     puts dpto_id

     @provincias = Provincia.where("SUBSTRING(code,1,2) = ?",dpto_id )
     @distritos  = Distrito.where("SUBSTRING(code,3,2) = ?",@provincias.first)


    respond_to do |format|
      format.js
    end


  end


  def update_distritos

     provincia_id =  params[:provincia_id]
     @distritos  = Distrito.where("SUBSTRING(code,3,2) = ?",provincia_id)
    


  end

  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:firstname, :lastname, :address1, :address2, :city, :state, :zip, :country,
       :phone1, :phone2, :email1, :email2, :company_id,:licencia,:idnumber,:active,:afp_id,:onp,:sueldo,:file_nro,
       :fecha_nacimiento,:fecha_ingreso,:fecha_cese,:sexo_id,:estado_civil_id,:asignacion,:comision_flujo,
       :ocupacion_id,:planilla,:division_id,:location_id,:carnet_seguro,:cusspp,:ccosto_id,:categoria_id,
       :interasistence,:cod_interno,:efectivo,:hora_ex,:dpto_id,:provin_id,:distrito_id)
    end
end
