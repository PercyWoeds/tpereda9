class TranportordersController < ApplicationController
  before_action :set_tranportorder, only: [:show, :edit, :update, :destroy]

  # GET /tranportorders
  # GET /tranportorders.json
  def index

  @tranportorders = Tranportorder.all.order(:fecha1).paginate(:page => params[:page]) 


  if params[:search]
    @tranportorders = Tranportorder.search(params[:search]).order("fecha1 DESC").paginate(:page => params[:page]) 
  else
    @tranportorders = Tranportorder.all.order("fecha1 DESC").paginate(:page => params[:page])  
  end

    
  end

  # GET /tranportorders/1
  # GET /tranportorders/1.json
  def show

  end

  # GET /tranportorders/new
  def new
    @tranportorder = Tranportorder.new

    @customers = @tranportorder.get_customers()
    @puntos =    @tranportorder.get_puntos()
    @employees = @tranportorder.get_employees() 
    
    @trucks = Truck.all.order(:placa )
    @tranportorder[:code] = "#{generate_guid6()}"
    
    @locations = Location.all
    @divisions = Division.all 
    
     @some_time1  = Time.now
    @some_time2  = Time.now

    @company =  Company.find(1)
    @tranportorder.company_id = @company.id   
    @tranportorder[:user_id] = getUserId()
    @cargas = @company.get_cargas()

    

  end

  # GET /tranportorders/1/edit
  def edit
     @customers = @tranportorder.get_customers()
     @puntos    = @tranportorder.get_puntos()
     
    
     @employees = @tranportorder.get_employees() 
     @trucks    = Truck.all 
     @locations = Location.all
     @divisions = Division.all 
     
      @tranportorder = Tranportorder.find(params[:id])
     
    
     puts @tranportorder.ubication_id
     puts @tranportorder[:ubication_id] 
    
  end

  # POST /tranportorders
  # POST /tranportorders.json
  def create
    @tranportorder = Tranportorder.new(tranportorder_params)
    @customers = @tranportorder.get_customers()
    @puntos = @tranportorder.get_puntos()
    @employees = @tranportorder.get_employees() 
    @trucks = Truck.all 
    @locations = Location.all
    @divisions = Division.all 
    @company = @tranportorder.company

    items2 = params[:items2].split(",")
    @tranportorder[:user_id] = @current_user.id
    @tranportorder[:company_id] = 1
    @tranportorder[:processed] = "1"

    respond_to do |format|
      if @tranportorder.save
        
         @tranportorder.correlativo
         @tranportorder.add_guias(items2)


        format.html { redirect_to @tranportorder, notice: 'Tranportorder was successfully created.' }
        format.json { render :show, status: :created, location: @tranportorder }
      else
        format.html { render :new }
        format.json { render json: @tranportorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tranportorders/1
  # PATCH/PUT /tranportorders/1.json
  def update
    respond_to do |format|
      if @tranportorder.update(tranportorder_params)
        format.html { redirect_to @tranportorder, notice: 'Tranportorder was successfully updated.' }
        format.json { render :show, status: :ok, location: @tranportorder }
      else
        format.html { render :edit }
        format.json { render json: @tranportorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tranportorders/1
  # DELETE /tranportorders/1.json
  def destroy
   respond_to do |format|
   a = Delivery.find_by(:tranportorder_id=> params[:id])
   if a 
        format.html { redirect_to tranportorders_url, notice: 'Orden tiene guias asignadas no se puede eliminar' }
        format.json { render json: a.errors, status: :unprocessable_entity }
   else 
      @tranportorder.destroy

      format.html { redirect_to tranportorders_url, notice: 'Tranportorder was successfully destroyed.' }
      format.json { head :no_content }
    end
   end 
  end


  def do_camion
    ##no need to write anything

    
  end

##-----------------------------------------------------------------------------------
## REPORTE DE GUIAS EMITIDAS
##-----------------------------------------------------------------------------------
  def build_pdf_header(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers.length, invoice_headers.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers.length >= row ? client_data_headers[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers.length >= row ? invoice_headers[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold

        end

        pdf.move_down 10

      end


      pdf.move_down 25
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text "Ordenes de Transporte Emitidas : Desde "+@fecha1.to_s + " Hasta: "+@fecha2.to_s, :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Tranportorder::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  orden in @orden_transporte
  
            row = []
            row << nroitem.to_s
            row << orden.code
            if orden.employee != nil
              row << orden.employee.full_name
            else
              row << "*Empleado no registrado ** " 
            end
            row << orden.get_placa(orden.truck2_id) 
            row << orden.get_punto(orden.ubication_id) 
            row << orden.get_punto(orden.ubication2_id)
            row << orden.fecha1.strftime("%d/%m/%Y")  
            row << orden.fecha2.strftime("%d/%m/%Y")
            row << orden.get_processed

            table_content << row

            nroitem=nroitem + 1
        end

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:center 
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left  
                                          columns([5]).align=:left 
                                          columns([6]).align=:left
                                          columns([7]).align=:left 
                                          columns([8]).align=:left
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer(pdf)

        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end



  # Export serviceorder to PDF
  def rpt_ost1_pdf

    @company=Company.find(params[:company_id])      

    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @tipo = params[:tiporeporte]
          
    @orden_transporte = @company.get_ordertransporte_day(@fecha1,@fecha2,@tipo)  
      
    Prawn::Document.generate("app/pdf_output/ost1.pdf") do |pdf|      
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/ost1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    #send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    send_file("app/pdf_output/ost1.pdf", :type => 'application/pdf', :disposition => 'inline')
  end
  
  
  
  

##-----------------------------------------------------------------------------------
## REPORTE 2
##-----------------------------------------------------------------------------------
  def build_pdf_header2(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers.length, invoice_headers.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers.length >= row ? client_data_headers[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers.length >= row ? invoice_headers[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold

        end

        pdf.move_down 10

      end


      pdf.move_down 25
      pdf 
  end   

  def build_pdf_body2(pdf)
    
    pdf.text "Ordenes de Transporte Emitidas : Desde "+@fecha1.to_s + " Hasta: "+@fecha2.to_s, :size => 11 
    pdf.text ""
   pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6

      headers = []
      table_content = []

      Tranportorder::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  orden in @orden_transporte
  
            row = []
            row << nroitem.to_s
            row << orden.code
            row << ""
            row << ""
            
            row << ""
            row << ""
            @ordenfecha1 = orden.fecha1.strftime("%d/%m/%Y")  
            @ordenfecha2 = orden.fecha2.strftime("%d/%m/%Y")
            row << ""
            row << "" 
            row << ""
            row << orden.get_placa(orden.truck2_id) 
            
            if orden.employee != nil
              row << orden.employee.full_name
            else
              row << "*Empleado no registrado ** " 
            end
            
            @destino =  orden.get_punto(orden.ubication_id) +"-" + orden.get_punto(orden.ubication2_id)
            row << @destino
            row << ""
            row << ""
            row << ""
            row << ""
            row << ""
            
            table_content << row

            nroitem=nroitem + 1
            
            @guias = orden.get_delivery(orden.id)
            
            for guias in @guias 
            
            
              row = []
              row << ""
              row << ""
              
              row << guias.fecha1.strftime("%d/%m/%Y")  
              b = business_days_between(orden.fecha1,guias.fecha1)
              
              row << b
              
              row << guias.code
              row << guias.fecha1.strftime("%d/%m/%Y")  
              row << @ordenfecha1
              row << @ordenfecha2
              @facturas= guias.get_factura_delivery(guias.id)
              if @facturas != ""
                
                row << guias.get_delivery_customer(guias.id)
              else
                
                row << ""
              end 
              row << ""
              row << ""
              
              if @facturas !=""
                row << ""
                row << @facturas.total 
                a=business_days_between(orden.fecha1,@facturas.fecha)
                row << a
                row << @facturas.code
                row << @facturas.fecha.strftime("%d/%m/%Y")    
                row << @facturas.get_dias_formapago.to_s 
              else
                row << ""
                row << ""
                row << ""
                row << ""
                row << ""
                row << ""
              end 
              
              
              
              table_content << row
            
              if @facturas != ""    
              @cancela = guias.get_factura_cancela(@facturas.id)
              
              for cancela in  @cancela
              @fecha_cobranza = cancela.get_fecha_cobranza(cancela.customer_payment_id)
              
              if @fecha_cobranza
              row = []
              row << ""
              row << ""
              row << ""
              row << ""
              row << ""
              row << ""
              row << ""
              row << ""
              
              row << ""
              row << ""
              row << ""
              row << ""
              row << ""
              row << ""
              
              row << cancela.total 
              row << "CANCELA"
              
              row << @fecha_cobranza.fecha1.strftime("%d/%m/%Y")  
              
              table_content << row
              
              end 
              end 
                
              
              
              end 
              
              
            
            
            end 
            
            
            
            
        end

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:center 
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left  
                                          columns([5]).align=:left 
                                          columns([6]).align=:left
                                          columns([7]).align=:left 
                                          columns([8]).align=:left
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer2(pdf)

        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end



  # Export serviceorder to PDF
  def rpt_ost2_pdf

    @company=Company.find(params[:company_id])      

    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @tipo   = params[:tiporeporte]
    @tipo = 1      
    @orden_transporte = @company.get_ordertransporte_day(@fecha1,@fecha2,@tipo)  
      
    Prawn::Document.generate "app/pdf_output/ost2.pdf" , :page_layout => :landscape do |pdf|      
        pdf.font "Helvetica"
        pdf = build_pdf_header2(pdf)
        pdf = build_pdf_body2(pdf)
        build_pdf_footer2(pdf)
        $lcFileName =  "app/pdf_output/ost2.pdf"      
        
    end     


    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    #send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    send_file("app/pdf_output/ost2.pdf", :type => 'application/pdf', :disposition => 'inline')
  end
  
  def business_days_between(date1, date2)
  business_days = 0
  date = date2
  while date > date1
   business_days = business_days + 1 
   date = date.to_date  - 1.day
  end
  business_days
end
  
def client_data_headers

    #{@serviceorder.description}
      client_headers  = [["Empresa  :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]
      client_headers
  end

  def invoice_headers            
      invoice_headers  = [["Fecha : ",$lcHora]]
    
      invoice_headers
  end
  
 def client_ost_headers

    #{@serviceorder.description}
      client_headers  = [["Conductor de carga :",@ost.employee.full_name ]]
      client_headers << ["Conducto de ruta :",""  ]
      client_headers << ["Supervisor/apoyo :",@ost.get_empleado(@ost.employee2_id)]
      client_headers << ["Placa: Tracto/Carreta :",@ost.truck.placa + " " + @ost.get_placa(@ost.truck2_id)   ]
      client_headers << ["Escolta:","" ]
      
      client_headers
  end

  def ost_headers            
      ost_headers  = [["De : ",@ost.get_punto(@ost.ubication_id)]]
      ost_headers << ["A :", @ost.get_punto(@ost.ubication2_id)]
      ost_headers << ["Fecha/Hora Salida :", @ost.fecha1.strftime('%d-%m-%Y')]
      ost_headers << ["Fecha/Hora de llegada:",""]
      ost_headers << ["Placa: ","" ]
      ost_headers
  end
   def invoice_summary
      lcTotal= 0.00
      invoice_summary = []
      invoice_summary << ["Total Facturado:", ActiveSupport::NumberHelper::number_to_delimited(lcTotal ,delimiter:",",separator:".").to_s]

      invoice_summary
    end
  
  
  
  # Export ost to PDF
  def pdf
    @ost = Tranportorder.find(params[:id])
    company =@ost.company_id
    @company =Company.find(company)
    @cabecera ="Facturacion"
    @abajo    ="Viatico"


    Prawn::Document.generate("app/pdf_output/#{@ost.id}.pdf") do |pdf|
        pdf.font "Helvetica"

        pdf = build_pdf_header_ost(pdf)
        pdf = build_pdf_body_ost(pdf)
        build_pdf_footer_ost(pdf)

        @cabecera ="Conductor"
        @abajo    ="Combustible"

        pdf = build_pdf_header_ost(pdf)
        pdf = build_pdf_body_ost(pdf)
        build_pdf_footer_ost(pdf)
        @cabecera ="Operaciones"
        @abajo    ="Pre Uso"

        pdf = build_pdf_header_ost(pdf)
        pdf = build_pdf_body_ost(pdf)
        build_pdf_footer_ost(pdf)

        $lcFileName =  "app/pdf_output/#{@ost.id}.pdf"


    end


    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end


def build_pdf_header_ost(pdf)

     pdf.font "Helvetica"  , :size => 8
     image_path = "#{Dir.pwd}/public/images/tpereda2.png"

      two_dimensional_array0 = [["SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD "],["OCUPACIONAL "],["ORDEN DE SERVICIO DE TRANSPORTE : "+@ost.code ]]    
      two_dimensional_array1 = [["CODIGO png "],["VERSION"],["PAGINA"]] 
      two_dimensional_array2 = [["TP-RD-F-005"],["08"],["1 DE 1 "]]
       

      table_content = ([ [{:image=> image_path, :width => 100 },{:content => two_dimensional_array0,:width=>320,},two_dimensional_array1,two_dimensional_array2 ]
                ]) 

      pdf.table(table_content, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold

          
        end


      pdf.move_down 2
      pdf 

  end

  def build_pdf_body_ost(pdf)

    pdf.text "__________________________________________________________________________", :size => 13, :spacing => 2
    pdf.font "Helvetica" , :size => 8

    max_rows = [client_ost_headers.length, ost_headers.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_ost_headers.length >= row ? client_ost_headers[rows_index] : ['',''])
        rows[rows_index] += (ost_headers.length >= row ? ost_headers[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold
          columns([1]).width = 180 


        end

        pdf.move_down 5

      end

      headers = []
      table_content = []

      Tranportorder::TABLE_HEADERS_OST.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      
      ary = [1,2,3,4,5,6,7]
      
      ary.each do |i|
      
            row = []
            row << " "
            row << " "
            row << " "
            row << " "
            row << " "
            table_content << row

            nroitem=nroitem + 1
        end
      

       
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                              } do
                                          columns([0]).align=:center
                                          columns([1]).align=:right
                                          columns([2]).align=:center
                                          columns([3]).align=:center
                                          columns([4]).align=:right
                                          columns([5]).align=:right
                                          columns([6]).align=:right

                                        end

      pdf.move_down 10
      
      pdf.table invoice_summary, {
        :position => :right,
        :cell_style => {:border_width => 1},
        :width => pdf.bounds.width/2
      } do
        columns([0]).font_style = :bold
        columns([1]).align = :right

      end
     
      
      
      pdf.text "GUIAS EN BLANCO    : "+  @ost.description
      pdf.text "CONTACTO           : "
      pdf.text "DIRECCION CARGUIO  : "
      pdf.text "DIRECCION DESCARGA : "
      
      pdf.move_down 10
      
        data3=  [["-----------------------------------","-----------------------------------","-----------------------------------" ],
        ["DESPACHADOR","CONDUCTOR","SUPERVISOR" ]]
        pdf.table(data3,:column_widths => [180, 180, 180], :cell_style => { :border_width => 0 })
        pdf.text " "
        pdf.text "Este documento tiene valor de declaracion jurada el cual el conductor asume la responsabilidad de la carga y documentots (G.R./G.T. y otros)" , :size => 8
        pdf.text " "
        
        pdf.text @cabecera , :align => :right 

      pdf

    end


    def build_pdf_footer_ost(pdf)
      
      

        pdf.text ""
        
        data2 = [["RUTA :"+ @ost.get_punto(@ost.ubication_id) + "  -  "+ @ost.get_punto(@ost.ubication2_id) ,   "   FECHA: "+ @ost.fecha1.strftime("%d-%m-%Y")],
                 ["PLACA: " + @ost.truck.placa + " EJES:          "+  "ESCOLTA:                   ", "PLACA :"+ @ost.get_placa(@ost.truck2_id)],
                 [ " CONDUCTOR : " + @ost.employee.full_name,"SUPERVISOR/APOYO: "+@ost.get_empleado(@ost.employee2_id)],
                 
                 [ " CONDUCTOR DE CARGA : " ,"CLIENTE : " ],
                 
                 ["OBSERVACIONES: "+@ost.comments, " "],
                 [" ", " "],
                 ["................................ ", " ................................ "],
                 ["V.B.Recepcion y Despacho ", "          V.B. Responsable"]]

                         pdf.bounding_box([0, 200], :width => 535, :height => 200) do
          
          
        pdf.text "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
        pdf.text "FORMATO DE AUTORIZACION:  " + @ost.code , :size => 13 
        
        
        pdf.table(data2, :cell_style => { :border_width => 0 }, :column_widths => [267, 268] )
        pdf.text @abajo , :align => :right 
      end
      
      
      pdf

     end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tranportorder
      @tranportorder = Tranportorder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tranportorder_params
      params.require(:tranportorder).permit(:code, :employee_id, :truck_id, :employee2_id, :truck2_id, :ubication_id, :ubication2_id, :fecha1, :fecha2, :description, :comments, :processed, :company_id, :location_id, :division_id)
    end
end
