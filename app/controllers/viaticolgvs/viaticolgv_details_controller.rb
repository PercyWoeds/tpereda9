class Viaticolgvs::ViaticolgvDetailsController < ApplicationController
  
  before_action :set_viaticolgv 
  
  before_action :set_viaticolgv_detail, :except=> [:new,:new2,:create,:agregar]



  
  # GET /viatico_details
  # GET /viatico_details.json
  def index
    @viaticolgv_details = ViaticolgvDetail.all
  end

  # GET /viatico_details/1
  # GET /viatico_details/1.json
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

  # GET /viatico_details/new

  def new
     @viaticolgv_detail = ViaticolgvDetail.new
    @gastos = Gasto.order(:codigo)
    @egresos = Egreso.where(["extension = ? or extension = ?", "LGV","ALL"]).order(:code)
   
    
    @company = Company.find(1)
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @viaticolgv_detail[:fecha] = Date.today 
    @destinos = Destino.all
    @employees = @company.get_employees 
    company_id = @company.id
    
    
  end
 def new2

    @viaticolgv_detail = ViaticolgvDetail.new
     @gastos = Gasto.order(:codigo)
     @egresos = Egreso.where(["extension = ? or extension = ?", "LGV","ALL"]).order(:code)
   
    

        @company = Company.find(1)
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents_area("OPE")


    @cajas = Caja.all      
    @viaticolgv_detail[:fecha] = Date.today 
    @destinos = Destino.all
    @employees = @company.get_employees 
    company_id = @company.id
  end

  def new2
    @pagetitle = "Nuevo viaticolgv"
    @action_txt = "Create"

     @gastos = Gasto.order(:codigo)
     @egresos = Egreso.where(["extension = ? or extension = ?", "LGV","ALL"]).order(:code)
   
    @company = Company.find(1)
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents =  @company.get_documents_area("OPE")
    @suppliers = @company.get_suppliers 

    @cajas = Caja.all      
  
    @destinos = Destino.all
    @employees = @company.get_employees 
    company_id = @company.id
    

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents =  @company.get_documents_area("OPE")
    @moneda = @company.get_monedas 




    fecha1 ="2021-01-01"   
       if  params[:search] != ""

           @purchases = Purchase.where("documento ilike ? ",  "%#{params[:search]}%").order("date1 DESC","documento DESC").paginate(:page => params[:page])
           puts "else 2 "

        else
          @purchases = Purchase.order('date1 DESC',"documento DESC").where(status: nil,user_id: 9).paginate(:page => params[:page]) 
        end


     puts "new2 "
    @viaticolgv.company_id = @company.id    
   
  end



 def ac_facturas
    @docs = Purchase.where(["company_id =  ? and (documento iLIKE ? )",params[:company_id], "%" + params[:q] + "%"])   
    render :layout => false
  end

def agregar
     @company = Company.find(1)
     @viaticolgv = Viaticolgv.find(params[:viaticolgv_id])
     @cajas = Caja.all     

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @destinos = Destino.all
    @employees = @company.get_employees 

      @egresos = Egreso.where(["extension = ? or extension = ?", "LGV","ALL"]).order(:code)
   

     @purchase_nuevo = Purchase.find(params[:purchase_id])

      detalle = ViaticolgvDetail.new 

      detalle.viaticolgv_id= params[:viaticolgv_id]
      detalle.fecha =  @purchase_nuevo.date1 
      detalle.descrip= nil 
      detalle.document_id =  @purchase_nuevo.document_id
      detalle.numero = @purchase_nuevo.documento 
      detalle.importe = @purchase_nuevo.total_amount 
      detalle.detalle = @purchase_nuevo.comments 
      detalle.tm = "1"
      detalle.supplier_id = @purchase_nuevo.supplier_id 
      detalle.gasto_id = 338
      detalle.employee_id =  64
      detalle.destino_id = 1
      detalle.egreso_id = 5
      
    

        respond_to do |format|

      if detalle.save
          begin
          @viaticolgv[:inicial] = @viaticolgv.get_total_inicial
          rescue
          @viaticolgv[:inicial] = 0
          end 

          begin
          @viaticolgv[:total_ing] = @viaticolgv.get_total_ing
          rescue 
          @viaticolgv[:total_ing] = 0
          end 

          begin 
          @viaticolgv[:total_egreso]=  @viaticolgv.get_total_sal
          rescue 
          @viaticolgv[:total_egreso]= 0 
          end 
  
   

           @viaticolgv[:saldo] = @viaticolgv[:inicial] +  @viaticolgv[:total_ing] - @viaticolgv[:total_egreso]


         @viaticolgv.save 

          if @viaticolgv.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
          if @viaticolgv.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
          if @viaticolgv.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
          if @viaticolgv.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
          if @viaticolgv.caja_id == 7 
          a = @cajas.find(4)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 


         format.html { redirect_to @viaticolgv, notice: 'Viaticolgv Detalle fue creado satisfactoriamente.' }
         format.json { render :show, status: :created, location: @viaticolgv }
       else
         format.html { render :new }
         format.json { render json: @viaticolgv_detail.errors, status: :unprocessable_entity }
       end
     end


end 

  # GET /viatico_details/1/edit
  def edit

    @gastos = Gasto.order(:codigo)
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @destinos = Destino.all
    @employees = @company.get_employees 

    @egresos = Egreso.where(["extension = ? or extension = ?", "LGV","ALL"]).order(:code)
    
    
    if @viaticolgv_detail.supplier_id != nil
    @supplier = Supplier.find(@viaticolgv_detail.supplier_id)
    @ac_supplier = @supplier.name
    @ac_supplier_id = @supplier.id
    else
    @ac_supplier = ""
    @ac_supplier_id = ""
      
    end 
    
    @employee = Employee.find(@viaticolgv_detail.employee_id)
    @ac_employee = @employee.full_name
    @ac_employee_id = @employee.id
    

  end

  # POST /viatico_details
  # POST /viatico_details.json
  def create
    
    @gastos = Gasto.order(:codigo)
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @destinos = Destino.all
    @employees = @company.get_employees 
    @egresos = Egreso.where(["extension = ? or extension = ?", "LGV","ALL"]).order(:code)
   


    @viaticolgv_detail = ViaticolgvDetail.new(viaticolgv_detail_params)    
    @viaticolgv_detail.viaticolgv_id  = @viaticolgv.id 
    

    @viaticolgv_detail.tranportorder_id = params[:ac_item_id]

    if  params[:tipoproveedor] ==  "1"
      @viaticolgv_detail.supplier_id = params[:ac_supplier_id]

        @viaticolgv_detail.employee_id = 64 
    else
       @viaticolgv_detail.supplier_id = 2570 
       @viaticolgv_detail.employee_id = params[:viaticolgv_detail][:employee_id]
    end 
  
    @viaticolgv_detail.document_id = params[:viaticolgv_detail][:tm]

    

    zeros =' 00:00:00'
     @viaticolgv_detail.fecha = params[:viaticolgv_detail][:fecha] << zeros 
    
     respond_to do |format|


      if @viaticolgv_detail.save
          begin
          @viaticolgv[:inicial] = @viaticolgv.get_total_inicial
          rescue
          @viaticolgv[:inicial] = 0
          end 

          begin
          @viaticolgv[:total_ing] = @viaticolgv.get_total_ing
          rescue 
          @viaticolgv[:total_ing] = 0
          end 

          begin 
          @viaticolgv[:total_egreso]=  @viaticolgv.get_total_sal
          rescue 
          @viaticolgv[:total_egreso]= 0 
          end 
  
   
           @viaticolgv[:saldo] = @viaticolgv[:inicial] +  @viaticolgv[:total_ing] - @viaticolgv[:total_egreso]


         @viaticolgv.save 

          if @viaticolgv.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
          if @viaticolgv.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
          if @viaticolgv.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
          if @viaticolgv.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
        if @viaticolgv.caja_id == 5 
          a = @cajas.find(5)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
          if @viaticolgv.caja_id == 6 
          a = @cajas.find(6)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end  

          if @viaticolgv.caja_id == 7 
          a = @cajas.find(7)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 

         format.html { redirect_to (@viaticolgv), notice: 'viaticolgv Detalle fue creado satisfactoriamente.' }
         format.json { render :show, status: :created, location: @viaticolgv }
       else
         format.html { render :new }
         format.json { render json: @viaticolgv_detail.errors, status: :unprocessable_entity }
       end
     end
  end

  # PATCH/PUT /viatico_details/1
  # PATCH/PUT /viatico_details/1.json
  def update
    @gastos = Gasto.order(:codigo)
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @employees = @company.get_employees()
    
    @cajas = Caja.all      

    @destinos = Destino.all
    
    @egresos = Egreso.where(["extension = ? or extension = ?", "LGV","ALL"]).order(:code)
   

    @viaticolgv_detail = ViaticolgvDetail.find(params[:id]) 
    @viaticolgv_detail.viatico_id  = @viaticolgv.id 
    @viaticolgv_detail.fecha = params[:viaticolgv_detail][:fecha]
    @viaticolgv_detail.employee_id = params[:ac_employee_id]

    
    respond_to do |format|
      if @viaticolgv_detail.update(viaticolgv_detail_params)
   begin
      @viaticolgv[:inicial] = @viaticolgv.get_total_inicial
    rescue
      @viaticolgv[:inicial] = 0
    end 
    
    begin
      @viaticolgv[:total_ing] = @viaticolgv.get_total_ing
    rescue 
      @viaticolgv[:total_ing] = 0
    end 
    begin 
      @viaticolgv[:total_egreso]=  @viaticolgv.get_total_sal
    rescue 
      @viaticolgv[:total_egreso]= 0 
    end 
    @viaticolgv[:saldo] = @viaticolgv[:inicial] +  @viaticolgv[:total_ing] - @viaticolgv[:total_egreso]


        @viaticolgv.save
        
         if @viaticolgv.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viaticolgv[:saldo]
          a.save
        end 
        if @viaticolgv.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viaticolgv[:saldo]
          a.save
        end 
        if @viaticolgv.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viaticolgv[:saldo]
          a.save
        end 
        if @viaticolgv.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viaticolgv[:saldo]
          a.save
        end 

        if @viaticolgv.caja_id == 5 
          a = @cajas.find(5)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
          if @viaticolgv.caja_id == 6 
          a = @cajas.find(6)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end  

          if @viaticolgv.caja_id == 7 
          a = @cajas.find(7)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 


        format.html { redirect_to @viaticolgv, notice: 'viaticolgv detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @viaticolgv }
      else
        format.html { render :edit }
        format.json { render json: @viaticolgv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /viatico_details/1
  # DELETE /viatico_details/1.json
  def destroy
      @cajas = Caja.all      
      if @viaticolgv_detail.destroy
         begin
      @viaticolgv[:inicial] = @viaticolgv.get_total_inicial
    rescue
      @viaticolgv[:inicial] = 0
    end 
    
    begin
      @viaticolgv[:total_ing] = @viaticolgv.get_total_ing
    rescue 
      @viaticolgv[:total_ing] = 0
    end 
    begin 
      @viaticolgv[:total_egreso]=  @viaticolgv.get_total_sal
    rescue 
      @viaticolgv[:total_egreso]= 0 
    end 
    @viaticolgv[:saldo] = @viaticolgv[:inicial] +  @viaticolgv[:total_ing] - @viaticolgv[:total_egreso]
        @viaticolgv.save
        
         if @viaticolgv.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viaticolgv[:saldo]
          a.save
        end 
        if @viaticolgv.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viaticolgv[:saldo]
          a.save
        end 
        if @viaticolgv.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viaticolgv[:saldo]
          a.save
        end 
        if @viaticolgv.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viaticolgv[:saldo]
          a.save
        end 

          if @viaticolgv.caja_id == 5 
          a = @cajas.find(5)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 
          if @viaticolgv.caja_id == 6 
          a = @cajas.find(6)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end  

          if @viaticolgv.caja_id == 7 
          a = @cajas.find(7)
          a.inicial =  @viaticolgv[:saldo]
          a.save
          end 


  
      flash[:notice]= "Item fue eliminado satisfactoriamente "
      redirect_to @viaticolgv
    else
      flash[:error]= "Item ha tenido un error y no fue eliminado"
      render :show 
    end 
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
      def set_viaticolgv  
      @viaticolgv = Viaticolgv.find(params[:viaticolgv_id])
    end 
    
    def set_viaticolgv_detail
      @viaticolgv_detail = ViaticolgvDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def viaticolgv_detail_params
      
      params.require(:viaticolgv_detail).permit(:fecha, :descrip, :document_id, :numero, :importe, :detalle, :tm,
       :CurrTotal, :tranportorder_id,:date_processed,:ruc,:supplier_id,:gasto_id,:employee_id,:destino_id,
       :egreso_id,:cout_id )
    end



end
