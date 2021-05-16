class Viaticotbks::ViaticotbkDetailsController < ApplicationController
  
  before_action :set_viaticotbk 
  
  before_action :set_viaticotbk_detail, :except=> [:new,:create]

  
  # GET /viaticotbk_details
  # GET /viaticotbk_details.json
  def index

    @viaticotbk_details = viaticotbkDetail.all
  end

  # GET /viaticotbk_details/1
  # GET /viaticotbk_details/1.json
  def show
    @gastos = Gasto.all
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @employees = @company.get_employees 
     @egresos = Egreso.order(:code)
  end

  # GET /viaticotbk_details/new
  def new
    @viaticotbk_detail = ViaticotbkDetail.new
    @gastos = Gasto.order(:codigo)
    @egresos = Egreso.where(["extension = ? or extension = ?", "TBK","ALL"]).order(:code)
    
    @company = Company.find(1)
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @viaticotbk_detail[:fecha] = Date.today 
    @destinos = Destino.all
    @employees = @company.get_employees 
    company_id = @company.id
    
  end

  # GET /viaticotbk_details/1/edit
  def edit

    @gastos = Gasto.order(:codigo)
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @destinos = Destino.all
    @employees = @company.get_employees 

    @egresos = Egreso.where(["extension = ? or extension = ?", "TBK","ALL"]).order(:code)
    
    
    

    
    if @viaticotbk_detail.supplier_id != nil
    @supplier = Supplier.find(@viaticotbk_detail.supplier_id)
    @ac_supplier = @supplier.name
    @ac_supplier_id = @supplier.id
    else
    @ac_supplier = ""
    @ac_supplier_id = ""
      
    end 
    
    @employee = Employee.find(@viaticotbk_detail.employee_id)
    @ac_employee = @employee.full_name
    @ac_employee_id = @employee.id
    

  end

  # POST /viaticotbk_details
  # POST /viaticotbk_details.json
  def create
    
    @gastos = Gasto.order(:codigo)
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @destinos = Destino.all
    @employees = @company.get_employees 
     @egresos = Egreso.where(["extension = ? or extension = ?", "TBK","ALL"]).order(:code)
    
    


    @viaticotbk_detail = ViaticotbkDetail.new(viaticotbk_detail_params)    
    @viaticotbk_detail.viaticotbk_id  = @viaticotbk.id 
    
    @viaticotbk_detail.tranportorder_id = params[:ac_item_id]

    if  params[:tipoproveedor] ==  "1"
      @viaticotbk_detail.supplier_id = params[:ac_supplier_id]

        @viaticotbk_detail.employee_id = 64 
    else
       @viaticotbk_detail.supplier_id = 2570 
       @viaticotbk_detail.employee_id = params[:viaticotbk_detail][:employee_id]
    end 
  
    @viaticotbk_detail.document_id = params[:viaticotbk_detail][:tm]

    
    
    
    

    zeros =' 00:00:00'
     @viaticotbk_detail.fecha = params[:viaticotbk_detail][:fecha] << zeros 
    
     respond_to do |format|
      if @viaticotbk_detail.save
         begin
      @viaticotbk[:inicial] = @viaticotbk.get_total_inicial
    rescue
      @viaticotbk[:inicial] = 0
    end 
    
    begin
      @viaticotbk[:total_ing] = @viaticotbk.get_total_ing
    rescue 
      @viaticotbk[:total_ing] = 0
    end 
    
    begin 
      @viaticotbk[:total_egreso]=  @viaticotbk.get_total_sal
    rescue 
      @viaticotbk[:total_egreso]= 0 
    end 
    puts "valooooo"
     puts @viaticotbk[:inicial]
    puts  @viaticotbk[:total_ing]
    puts @viaticotbk[:total_egreso]

   

    @viaticotbk[:saldo] = @viaticotbk[:inicial] +  @viaticotbk[:total_ing] - @viaticotbk[:total_egreso]


         @viaticotbk.save 

          if @viaticotbk.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 

        if @viaticotbk.caja_id == 5
          a = @cajas.find(5)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 

         if @viaticotbk.caja_id == 6
          a = @cajas.find(6)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 



         format.html { redirect_to @viaticotbk, notice: 'viaticotbk Detalle fue creado satisfactoriamente.' }
         format.json { render :show, status: :created, location: @viaticotbk }
       else
         format.html { render :new }
         format.json { render json: @viaticotbk_detail.errors, status: :unprocessable_entity }
       end
     end
  end

  # PATCH/PUT /viaticotbk_details/1
  # PATCH/PUT /viaticotbk_details/1.json
  def update
    @gastos = Gasto.order(:codigo)
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @employees = @company.get_employees()
    
    @cajas = Caja.all      

    @destinos = Destino.all
    
    @egresos = Egreso.where(["extension = ? or extension = ?", "TBK","ALL"]).order(:code)
    

    @viaticotbk_detail = ViaticotbkDetail.find(params[:id]) 
    @viaticotbk_detail.viaticotbk_id  = @viaticotbk.id 
    @viaticotbk_detail.fecha = params[:viaticotbk_detail][:fecha]
    @viaticotbk_detail.employee_id = params[:ac_employee_id]

    
    respond_to do |format|
      if @viaticotbk_detail.update_attributes(employee_id: params[:viaticotbk_detail][:employee_id],fecha: params[:viaticotbk_detail][:fecha],importe: params[:viaticotbk_detail][:importe],
        gasto_id: params[:viaticotbk_detail][:gasto_id],destino_id: params[:viaticotbk_detail][:destino_id],tm:params[:viaticotbk_detail][:tm],numero: params[:viaticotbk_detail][:numero],detalle: params[:viaticotbk_detail][:detalle],document_id: params[:viaticotbk_detail][:tm],egreso_id: params[:viaticotbk_detail][:egreso_id])
   begin
      @viaticotbk[:inicial] = @viaticotbk.get_total_inicial
    rescue
      @viaticotbk[:inicial] = 0
    end 
    
    begin
      @viaticotbk[:total_ing] = @viaticotbk.get_total_ing
    rescue 
      @viaticotbk[:total_ing] = 0
    end 
    begin 
      @viaticotbk[:total_egreso]=  @viaticotbk.get_total_sal
    rescue 
      @viaticotbk[:total_egreso]= 0 
    end 
    

    
    @viaticotbk[:saldo] = @viaticotbk[:inicial] +  @viaticotbk[:total_ing] - @viaticotbk[:total_egreso]
        @viaticotbk.save
        
         if @viaticotbk.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 5
          a = @cajas.find(5)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 

         if @viaticotbk.caja_id == 6
          a = @cajas.find(6)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 

        
        format.html { redirect_to @viaticotbk, notice: 'viaticotbk detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @viaticotbk }
      else
        format.html { render :edit }
        format.json { render json: @viaticotbk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /viaticotbk_details/1
  # DELETE /viaticotbk_details/1.json
  def destroy
      @cajas = Caja.all    


        a =  Cout.find(@viaticotbk_detail.cout_id)

        a.parent = nil

        a.save 

 
      if  @viaticotbk_detail.destroy


         begin
          @viaticotbk[:inicial] = @viaticotbk.get_total_inicial
        rescue
          @viaticotbk[:inicial] = 0
        end 
        
        begin
          @viaticotbk[:total_ing] = @viaticotbk.get_total_ing
        rescue 
          @viaticotbk[:total_ing] = 0
        end 
        begin 
          @viaticotbk[:total_egreso]=  @viaticotbk.get_total_sal
        rescue 
          @viaticotbk[:total_egreso]= 0 
        end 
        @viaticotbk[:saldo] = @viaticotbk[:inicial] +  @viaticotbk[:total_ing] - @viaticotbk[:total_egreso]


        @viaticotbk.save
        
         if @viaticotbk.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 

         if @viaticotbk.caja_id == 5
          a = @cajas.find(5)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 

         if @viaticotbk.caja_id == 6
          a = @cajas.find(6)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 

  
      flash[:notice]= "Item fue eliminado satisfactoriamente "
      redirect_to @viaticotbk
    else
      flash[:error]= "Item ha tenido un error y no fue eliminado"
      render :show 
    end 
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
      def set_viaticotbk 
      @viaticotbk= Viaticotbk.find(params[:viaticotbk_id])
    end 
    
    def set_viaticotbk_detail
      @viaticotbk_detail = ViaticotbkDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def viaticotbk_detail_params
      
      params.require(:viaticotbk_detail).permit(:fecha, :descrip, :document_id, :numero, :importe, :detalle, :tm, :CurrTotal, :tranportorder_id,:date_processed,:ruc,:supplier_id,:gasto_id,:employee_id,:destino_id,:egreso_id)
    end
end
