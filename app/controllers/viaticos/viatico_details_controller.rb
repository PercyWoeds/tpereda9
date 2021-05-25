class Viaticos::ViaticoDetailsController < ApplicationController
  
  before_action :set_viatico 
  
  before_action :set_viatico_detail, :except=> [:new,:new2,:create,:agregar]

  
  # GET /viatico_details
  # GET /viatico_details.json
  def index
    @viatico_details = ViaticoDetail.all
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
    @viatico_detail = ViaticoDetail.new
    @gastos = Gasto.order(:codigo)

    
     if @viatico.caja_id  == 2

        @egresos = Egreso.order(:orden).where("extension = ? or extension =  ? or extension  =  ?","ALL","CAJA","CAJA-ALL")

     end    
    if @viatico.caja_id  == 3

         @egresos = Egreso.order(:orden).where("extension = ?  ","ALL" )

     end    
      if @viatico.caja_id  == 4

        @egresos = Egreso.order(:orden).where("extension = ? or extension =  ? or extension  =  ? ","ALL","CAJA-AQP","CAJA-ALL" )

     end    
     
    
    @company = Company.find(1)
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @viatico_detail[:fecha] = Date.today 
    @destinos = Destino.all
    @employees = @company.get_employees 
    company_id = @company.id
    

  end
 def new2

    @viatico_detail = ViaticoDetail.new
     @gastos = Gasto.order(:codigo)
    @egresos = Egreso.order(:code)
    
    @company = Company.find(1)
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents =  @company.get_documents_area("OPE")


    @cajas = Caja.all      
    @viatico_detail[:fecha] = Date.today 
    @destinos = Destino.all
    @employees = @company.get_employees 
    company_id = @company.id
  end

  def new2
    @pagetitle = "Nuevo Viatico"
    @action_txt = "Create"

     @gastos = Gasto.order(:codigo)
    @egresos = Egreso.order(:code)
    
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
    @viatico.company_id = @company.id    
   
  end



 def ac_facturas
    @docs = Purchase.where(["company_id =  ? and (documento iLIKE ? )",params[:company_id], "%" + params[:q] + "%"])   
    render :layout => false
  end

def agregar
 @company = Company.find(1)
    @viatico = Viatico.find(params[:viatico_id])
     @cajas = Caja.all     

      @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @destinos = Destino.all
    @employees = @company.get_employees 

    @egresos = Egreso.order(:code)



     @purchase_nuevo = Purchase.find(params[:purchase_id])

      detalle = ViaticoDetail.new 

      detalle.viatico_id= params[:viatico_id]
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
          @viatico[:inicial] = @viatico.get_total_inicial
          rescue
          @viatico[:inicial] = 0
          end 

          begin
          @viatico[:total_ing] = @viatico.get_total_ing
          rescue 
          @viatico[:total_ing] = 0
          end 

          begin 
          @viatico[:total_egreso]=  @viatico.get_total_sal
          rescue 
          @viatico[:total_egreso]= 0 
          end 
  
   

           @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]


         @viatico.save 

          if @viatico.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viatico[:saldo]
          a.save
          end 
          if @viatico.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viatico[:saldo]
          a.save
          end 
          if @viatico.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viatico[:saldo]
          a.save
          end 
          if @viatico.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viatico[:saldo]
          a.save
          end 


         format.html { redirect_to @viatico, notice: 'Viatico Detalle fue creado satisfactoriamente.' }
         format.json { render :show, status: :created, location: @viatico }
       else
         format.html { render :new }
         format.json { render json: @viatico_detail.errors, status: :unprocessable_entity }
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

    @egresos = Egreso.order(:code)
    
    
    if @viatico_detail.supplier_id != nil
    @supplier = Supplier.find(@viatico_detail.supplier_id)
    @ac_supplier = @supplier.name
    @ac_supplier_id = @supplier.id
    else
    @ac_supplier = ""
    @ac_supplier_id = ""
      
    end 
    
    @employee = Employee.find(@viatico_detail.employee_id)
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
     @egresos = Egreso.order(:code)
    


    @viatico_detail = ViaticoDetail.new(viatico_detail_params)    
    @viatico_detail.viatico_id  = @viatico.id 
    
    @viatico_detail.tranportorder_id = params[:ac_item_id]

    if  params[:tipoproveedor] ==  "1"
      @viatico_detail.supplier_id = params[:ac_supplier_id]

        @viatico_detail.employee_id = 64 
    else
       @viatico_detail.supplier_id = 2570 
       @viatico_detail.employee_id = params[:viatico_detail][:employee_id]
    end 
  
    @viatico_detail.document_id = params[:viatico_detail][:tm]

    
    
    
    

    zeros =' 00:00:00'
     @viatico_detail.fecha = params[:viatico_detail][:fecha] << zeros 
    
     respond_to do |format|


      if @viatico_detail.save
          begin
          @viatico[:inicial] = @viatico.get_total_inicial
          rescue
          @viatico[:inicial] = 0
          end 

          begin
          @viatico[:total_ing] = @viatico.get_total_ing
          rescue 
          @viatico[:total_ing] = 0
          end 

          begin 
          @viatico[:total_egreso]=  @viatico.get_total_sal
          rescue 
          @viatico[:total_egreso]= 0 
          end 
  
   

           @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]


         
          if @viatico[:caja_id] == 3

            begin
                @viatico[:importe_documento] = @viatico.get_total_saldo_documento
            rescue
                @viatico[:importe_documento] = 0
            end 

         
            begin
                @viatico[:fecha_saldo_final] = params[:viatico_detail][:fecha]
            rescue
                @viatico[:fecha_saldo_final] = nil
            end 

           


            begin
                @viatico[:importe_saldo_egreso]  =  @viatico[:total_egreso] -  @viatico[:importe_documento] 
                @viatico[:importe_saldo_final]   =  @viatico[:importe_saldo_ant] +   @viatico[:importe_saldo_egreso]
          
            rescue
                @viatico[:importe_saldo_egreso] = 0
                @viatico[:importe_saldo_final]  = 0

            end 

          end


         @viatico.save 

          if @viatico.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viatico[:saldo]
          a.save
          end 
          if @viatico.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viatico[:saldo]
          a.save
          end 
          if @viatico.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viatico[:saldo]
          a.save
          end 
          if @viatico.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viatico[:saldo]
          a.save
          end 


         format.html { redirect_to @viatico, notice: 'Viatico Detalle fue creado satisfactoriamente.' }
         format.json { render :show, status: :created, location: @viatico }
       else
         format.html { render :new }
         format.json { render json: @viatico_detail.errors, status: :unprocessable_entity }
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
    
    @egresos = Egreso.order(:code)
    ()
    @viatico_detail = ViaticoDetail.find(params[:id]) 
    @viatico_detail.viatico_id  = @viatico.id 
    @viatico_detail.fecha = params[:viatico_detail][:fecha]
    @viatico_detail.employee_id = params[:ac_employee_id]

    
    respond_to do |format|
      if @viatico_detail.update_attributes(employee_id: params[:viatico_detail][:employee_id],fecha: params[:viatico_detail][:fecha],importe: params[:viatico_detail][:importe],
        gasto_id: params[:viatico_detail][:gasto_id],destino_id: params[:viatico_detail][:destino_id],tm:params[:viatico_detail][:tm],numero: params[:viatico_detail][:numero],detalle: params[:viatico_detail][:detalle],document_id: params[:viatico_detail][:tm],egreso_id: params[:viatico_detail][:egreso_id])
   begin
      @viatico[:inicial] = @viatico.get_total_inicial
    rescue
      @viatico[:inicial] = 0
    end 
    
    begin
      @viatico[:total_ing] = @viatico.get_total_ing
    rescue 
      @viatico[:total_ing] = 0
    end 
    begin 
      @viatico[:total_egreso]=  @viatico.get_total_sal
    rescue 
      @viatico[:total_egreso]= 0 
    end 


    @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]

    
   
    if @viatico[:caja_id] == 3

      begin
          @viatico[:importe_documento] = @viatico.get_total_saldo_documento
      rescue
          @viatico[:importe_documento] = 0
      end 

   
      begin
          @viatico[:fecha_saldo_final] = params[:viatico_detail][:fecha]
      rescue
          @viatico[:fecha_saldo_final] = nil
      end 

     


      begin
          @viatico[:importe_saldo_egreso]  =  @viatico[:total_egreso] -  @viatico[:importe_documento] 
          @viatico[:importe_saldo_final]   =  @viatico[:importe_saldo_ant] +   @viatico[:importe_saldo_egreso]
    
      rescue
          @viatico[:importe_saldo_egreso] = 0
          @viatico[:importe_saldo_final]  = 0

      end 

    end


        @viatico.save
        
         if @viatico.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viatico[:saldo]
          a.saldo_inicial   =  @viatico[:importe_saldo_final] 
          a.fecha_inicial   =  @viatico[:fecha_saldo_final] 
          a.save
        end 
        if @viatico.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viatico[:saldo]
          a.save
        end 

 

        format.html { redirect_to @viatico, notice: 'Viatico detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @viatico }
      else
        format.html { render :edit }
        format.json { render json: @viatico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /viatico_details/1
  # DELETE /viatico_details/1.json
  def destroy
      @cajas = Caja.all      
      if @viatico_detail.destroy
         begin
      @viatico[:inicial] = @viatico.get_total_inicial
    rescue
      @viatico[:inicial] = 0
    end 
    
    begin
      @viatico[:total_ing] = @viatico.get_total_ing
    rescue 
      @viatico[:total_ing] = 0
    end 
    begin 
      @viatico[:total_egreso]=  @viatico.get_total_sal
    rescue 
      @viatico[:total_egreso]= 0 
    end 
    @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]


    
         
          if @viatico[:caja_id] == 3

            begin
                @viatico[:importe_documento] = @viatico.get_total_saldo_documento
            rescue
                @viatico[:importe_documento] = 0
            end 

         
            begin
                @viatico[:fecha_saldo_final] = params[:viatico_detail][:fecha]
            rescue
                @viatico[:fecha_saldo_final] = nil
            end 

           


            begin
                @viatico[:importe_saldo_egreso]  =  @viatico[:total_egreso] -  @viatico[:importe_documento] 
                @viatico[:importe_saldo_final]   =  @viatico[:importe_saldo_ant] +   @viatico[:importe_saldo_egreso]
          
            rescue
                @viatico[:importe_saldo_egreso] = 0
                @viatico[:importe_saldo_final]  = 0

            end 

          end
        @viatico.save
        
         if @viatico.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
  
      flash[:notice]= "Item fue eliminado satisfactoriamente "
      redirect_to @viatico
    else
      flash[:error]= "Item ha tenido un error y no fue eliminado"
      render :show 
    end 
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
      def set_viatico 
      @viatico = Viatico.find(params[:viatico_id])
    end 
    
    def set_viatico_detail
      @viatico_detail = ViaticoDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def viatico_detail_params
      
      params.require(:viatico_detail).permit(:fecha, :descrip, :document_id, :numero, :importe, :detalle, :tm, :CurrTotal, :tranportorder_id,:date_processed,:ruc,:supplier_id,:gasto_id,:employee_id,:destino_id,:egreso_id,
      :fecha_saldo_ant,
     :fecha_saldo_final,
    :importe_saldo_ant,
    :importe_saldo_final,
    :importe_documento,
    :importe_saldo_egreso)
    end



end
