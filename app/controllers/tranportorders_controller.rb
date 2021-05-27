class TranportordersController < ApplicationController
  before_action :set_tranportorder, only: [:show, :edit, :update, :destroy]

  # GET /tranportorders
  # GET /tranportorders.json
  def index
   @company = Company.find(1)
     @tranportorders = Tranportorder.all.order(:fecha1).paginate(:page => params[:page]) 


  if params[:search]
    @tranportorders = Tranportorder.search(params[:search]).order("fecha1 DESC").paginate(:page => params[:page]) 
  else
    @tranportorders = Tranportorder.all.order("fecha1 DESC").paginate(:page => params[:page])  
  end

    
  end


  def cargar
    @lcProcesado='1'
    @company = Company.find(1)

   # @manifests = Manifest.where(["processed =  ? and fecha1>=? ",@lcProcesado,"2020-08-01 00:00:00"])

   @manifests =  Manifest.where("processed = ? and fecha1 >=? ","1","2021-01-01 00:00:00").where( Manifestship.where('manifest_id = manifests.id').arel.exists.not).order("code DESC " )
    return @manifests

  end   

  
  def newost   
    @company = Company.find(1)
    @manifest = Manifest.find(params[:id])  

     @ost  = Tranportorder.new 

    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()
    @suppliers = @company.get_suppliers()      
    @almacens = @company.get_almacens()
    @puntos =    @ost.get_puntos()
    @trucks = Truck.all.order(:placa).where(estado: "1")
     @employees = @ost.get_employees() 
    
  

   if  @manifest.location_id == 5
      @lcSerie =  1
   end 
   if  @manifest.location_id == 1
      @lcSerie =  2
   end 
   if  @manifest.location_id == 6
      @lcSerie =  8
   end 
   puts "correlatio.v......................"
   puts @lcSerie

   @code = @ost.generate_ost_number(@lcSerie)  
  puts @code 

    @cargas = @company.get_cargas()
    
   
  end 

  # GET /tranportorders/1
  # GET /tranportorders/1.json
  def show

       @company =  Company.find(1)
 @cargas = @company.get_cargas()
  end

  def sendcancelar 
    
    @company  = Company.find(1)
    @tranportorder = Tranportorder.find(params[:id])

  end


  # GET /tranportorders/new
  def new
    @tranportorder = Tranportorder.new


    @customers = @tranportorder.get_customers()
    @puntos =    @tranportorder.get_puntos()
    @employees = @tranportorder.get_employees() 
    
    @trucks = Truck.all.order(:placa ).where(estado: "1")
    @tranportorder[:code] = "#{generate_guid6()}"
    
    @locations = Location.all
    @divisions = Division.all 
    
     @some_time1  = Time.now
    @some_time2  = Time.now

    @company =  Company.find(1)
    @tranportorder.company_id = @company.id   
    @tranportorder[:user_id] = getUserId()
    @cargas = @company.get_cargas()

    @tranportorder[:fecha1] = Date.today 
    @tranportorder[:fecha2] = Date.today 

  end

  # GET /tranportorders/1/edit
  def edit
     @company =  Company.find(1)
     @customers = @tranportorder.get_customers()
     @puntos    = @tranportorder.get_puntos()
     @cargas =  @company.get_cargas()

    
     @employees = @tranportorder.get_employees() 
     @trucks    = Truck.all.where(estado: "1")
     @locations = Location.all
     @divisions = Division.all 
     
      @tranportorder = Tranportorder.find(params[:id])
     
    
     puts @tranportorder.ubication_id
     puts @tranportorder[:ubication_id] 
    
  end

  # POST /tranportorders
  # POST /tranportorders.json
  def create
    @company =  Company.find(1)
    @tranportorder = Tranportorder.new(tranportorder_params)
    @customers = @tranportorder.get_customers()
    @puntos = @tranportorder.get_puntos()
    @employees = @tranportorder.get_employees() 
    @trucks = Truck.all.where(estado: "1") 
    @locations = Location.all
    @divisions = Division.all 
  
    @cargas = @company.get_cargas()

    @tranportorder[:user_id] = @current_user.id
    @tranportorder[:company_id] = 1
    @tranportorder[:processed] = "1"
   @tranportorder[:division_id] = 1

   items2 = []

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

      b = Cout.find_by(:tranportorder_id=> params[:id])


      if b

        format.html { redirect_to tranportorders_url, notice: 'Orden tiene Viaticos asignadas no se puede eliminar' }
        format.json { render json: a.errors, status: :unprocessable_entity }

      else


      @tranportorder.destroy

      format.html { redirect_to tranportorders_url, notice: 'Tranportorder was successfully destroyed.' }
      format.json { head :no_content }

       end
    end

    
   end 
  end



  def do_anular
    @invoice = Tranportorder.find(params[:id])


   a = Delivery.find_by(:tranportorder_id=> params[:id])


   if a 
    flash[:notice] = "OST tiene guias asignadas, no se puede anular. Elimine primero las guias "
    
    else

    @invoice[:processed] = "2"
    @invoice.anular 
    
    flash[:notice] = "Documento a sido anulado."

    end 
    redirect_to @invoice 



  end
  
  def do_anular2


    @company =  Company.find(1)
    @tranportorder = Tranportorder.find(params[:id])
    @observa  = params[:motivo]
  
   a = Delivery.find_by(:tranportorder_id=> params[:id])


    if a 
    flash[:notice] = "OST tiene guias asignadas, no se puede anular. Elimine primero las guias "
    
    else


        @tranportorder[:processed] = "2"
         @tranportorder.update_attributes(:comments => @observa,:processed =>"2") 
         @tranportorder.anular

        
        flash[:notice] = "OST anulado ."

    end 

    redirect_to @tranportorder 

  end

  def ac_osts
    procesado = '1'
    @osts = Tranportorder.where([" (code LIKE ?)   ",  "%" + params[:q] + "%"]) 
    render :layout => false
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
    @location= params[:location_id]
          
    @orden_transporte = @company.get_ordertransporte_day(@fecha1,@fecha2,@tipo,@location )  
      
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
      client_headers << ["Conducto de ruta :", @ost.get_empleado(@ost.employee2_id)]
      client_headers << ["Supervisor/apoyo :",@ost.get_empleado(@ost.employee3_id)]
      client_headers << ["Placa: Tracto/Carreta :",@ost.truck.placa + " " + @ost.get_placa(@ost.truck2_id) + "   Ejes: " +@ost.get_ejes2(@ost.id ) ]
      client_headers << ["Escolta:",@ost.get_empleado(@ost.employee4_id)]
      
      client_headers
  end

  def ost_headers            
      ost_headers  = [["De : ",@ost.get_punto(@ost.ubication_id)]]
      ost_headers << ["A :", @ost.get_punto(@ost.ubication2_id)]
      ost_headers << ["Fecha/Hora Salida :", @ost.fecha1.strftime('%d-%m-%Y')]
      ost_headers << ["  Fecha/Hora de llegada:",@ost.fecha2.strftime('%d-%m-%Y')]
      ost_headers << ["Placa: ",@ost.get_placa(@ost.truck3_id)]
      ost_headers
  end
   def invoice_summary
      lcTotal= 0.00
      invoice_summary = []
      invoice_summary << ["Nro.Factura: "," ","Total Facturado:", ActiveSupport::NumberHelper::number_to_delimited(lcTotal ,delimiter:",",separator:".").to_s]

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


     
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD EN EL TRABAJO ",:rowspan => 2},"CODIGO ","TP-RD-F-005"], 
          ["VERSION: ","9"], 
          ["ORDEN DE SERVICIO DE TRANSPORTE Nro. " + @ost.code ,"Pagina: ","1 de 1 "] 
         
          ])
        




       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
            columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 301.45
            columns([1]).align = :center
            columns([2]).align = :center
            columns([3]).align = :center

            columns([2]).width = 60

            columns([3]).width = 60

         end
        
      
        
         pdf.move_down 2
      pdf 

  end

  def build_pdf_body_ost(pdf)


       table_content = ([ ["Nro.DE S.T.: "+@ost.get_st ]   ])
      

       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([0]).font_style = :bold
          
            columns([0]).align = :center
          
      
         end
        
      

         pdf.move_down 2
   
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
          :cell_style => {:border_width => 0, :height => 17},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold
          columns([1]).width = 180 


        end

        pdf.move_down 5

      end

      headers = []
      table_content = []

    



    header_text = [ ]
    tb = [[{:content => "EMPRESA", :rowspan => 2},
      {:content => "N.GUIA", :rowspan => 2},
      {:content => "DESCRIPCION DE LA CARGA " },
      {:content => "PESO", :rowspan => 2, width: 60 },
      {:content => "PRECIO FACTURA", :rowspan => 2, width: 60 }],
     [ {:content => "GENERAL [  ] PESADA [  ] EXTRAPESADA [  ] SOBREDIMENSIONADA [  ] MATPEL/IQBF [  ]", size: 6  } ]]
  
   
      nroitem=1

      @dir3=""
      @dir4 =""

      if Manifestship.where(tranportorder_id: @ost.id ).exists? 

         a = Manifestship.where(tranportorder_id: @ost.id ).first 

           @manifest = Manifest.find(a.manifest_id) 
           @dir3 = @manifest.customer.name 
           @dir4 = @manifest.especificacion

      end 

      
  tb_text = [[@dir3,"",@dir4,"",""],

[" "," ","","",""],
[" "," ","","",""],
[" "," ","","",""],
[" "," ","","",""]

]

    pdf.table( tb + tb_text , header: 2 ,:position => :center,
                                        :header => true,

                                        :width => pdf.bounds.width,
                                        
                                              ) do

      row(0).font_style = :bold
       columns([0]).width = 120
    
    end

    
       
     
      pdf.move_down 2
      
      pdf.table invoice_summary, {
        :position => :right,
        :cell_style => {:border_width => 1},
        :width => pdf.bounds.width
      } do
        columns([0,2]).font_style = :bold
        columns([0]).align = :right

        columns([0]).width  = 280

        columns([2]).width  = 100
        columns([3]).width  = 60

      end


      @dir1 = ""
      @dir2 = ""
      if Manifestship.where(tranportorder_id: @ost.id ).exists? 

         a= Manifestship.where(tranportorder_id: @ost.id ).first 

           @manifest = Manifest.find(a.manifest_id) 
           @dir1 = @manifest.direccion1.upcase 
           @dir2 = @manifest.direccion2.upcase
           @contacto = "CARGA : "+ @manifest.contacto1 + " Telefono: "+ @manifest.telefono1 + "  DESCARGA: "+ @manifest.contacto2 + " Telefono :  " + @manifest.telefono2
      end 
      
          
            tb_text_guias = [ [{:content => "GUIAS EN BLANCO : ", :font_style => :bold , :border_width => 0 }, 
                          @ost.description,""," ","","",""],

                          [{:content => " ", :font_style => :bold , :border_width => 0 },"",""," ","","",""],
                        ]

            pdf.table( tb_text_guias ,:position => :right,
                                              
                                              :width =>  pdf.bounds.width,
                                              :cell_style => {:height => 17}
                                                    ) do

            row(0).font_style = :bold
            columns([0]).width = 120
            end

         pdf.move_down 2
      

          tb_text_direccion = [ [{:content => "CONTACTO: ", :font_style => :bold}, @contacto ],
                   [{:content => "DIRECCION CARGUIO  : ", :font_style => :bold},@dir1],
                   [{:content => "DIRECCION DESCARGA : ", :font_style => :bold},@dir2]]

      pdf.table( tb_text_direccion ,:position => :right,
                                              :width => pdf.bounds.width
                                                    ) do
              columns([0]).width = 120
              columns([0]).font_style = :bold
            end
      

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
        if @ost.comments == nil 
           comments = ""
         else
          comments = @ost.comments 

        end 

        
        
        data2 = [["RUTA :"+ @ost.get_punto(@ost.ubication_id) + "  -  "+ @ost.get_punto(@ost.ubication2_id) ,   "   FECHA: "+ @ost.fecha1.strftime("%d-%m-%Y")+" PLACA TRACTO/CAMION: " + @ost.truck.placa+ " " + @ost.get_placa(@ost.truck2_id)],
                 [ " EJES:"+ @ost.get_ejes2(@ost.id ) +  " ESCOLTA:" +@ost.get_empleado(@ost.employee4_id), "PLACA :"+ @ost.get_placa(@ost.truck2_id)],
                 [ " CONDUCTOR DE CARGA  " + @ost.employee.full_name,"SUPERVISOR/APOYO: "+@ost.get_empleado(@ost.employee3_id)],
                 
                 [ " CONDUCTOR DE RUTA  : "+@ost.get_empleado(@ost.employee2_id) ,"CLIENTE : " +@ost.customer.name  ],
                 
                 ["OBSERVACIONES: "+ comments, " "],
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




 # Export o2st to PDF
  def pdf2
    @ost = Tranportorder.find(params[:id])
    company =@ost.company_id
    @company =Company.find(company)
    @cabecera ="Facturacion"
    @abajo    ="Viatico"


    Prawn::Document.generate "app/pdf_output/#{@ost.id}.pdf", :page_layout => :landscape do  |pdf|
        pdf.font "Helvetica"

        pdf = build_pdf_header_ost2(pdf)
        pdf = build_pdf_body_ost2(pdf)
        build_pdf_footer_ost2(pdf)

        @cabecera ="Conductor"
        @abajo    ="Combustible"

        
        @lcFileName =  "app/pdf_output/#{@ost.id}.pdf"


    end


    @lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+@lcFileName
    send_file("#{@lcFileName1}", :type => 'application/pdf', :disposition => 'inline')

  end



def build_pdf_header_ost2(pdf)



      pdf.font "Helvetica" , :size => 8
      image_path = "#{Dir.pwd}/public/images/tpereda2.png"

       table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD OCUPACIONAL",:rowspan => 2},"CODIGO ","TP"], 
          ["VERSION: ","0"], 
          ["ORDEN DE SERVICIO DE TRANSPORTE : " +@ost.code  ,"Pagina: ","1 de 1 "] 
         
          ])
     
       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 401.45

            columns([1]).align = :center
            
            columns([2]).width = 100
          
            columns([3]).width = 100
      
         end
        
        
    
         
         pdf.move_down 2
      
      pdf 
  
  end

  def build_pdf_body_ost2(pdf)

  
      headers = []
      table_content = []

       table_content3 = []
        table_content4 = []
            table_content5 = []
        

      Tranportorder::TABLE_HEADERS_OST2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end


+ "  -  "+ @ost.get_punto(@ost.ubication2_id)
      table_content << headers




       table_content2 = ([ [{:content =>"CLIENTE: " , :rowspan => 2 },
        {:content =>  @ost.customer.name ,:rowspan => 2},
           {:content => "RUTA " ,:rowspan => 2},"DE",@ost.get_punto(@ost.ubication_id)  ,"FECHA : " , @ost.fecha1.strftime("%d/%m/%Y"), "N.GUIA REMISION TRANSPORTISTA" ,@ost.comments], 
          ["A: ",@ost.get_punto(@ost.ubication2_id) ,"Tipo Carga",@ost.get_tipocarga(@ost.tipocargue_id),"CARGA",@ost.carga]
         
          ])
     
       pdf.table(table_content2 ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([1,2]).font_style = :bold
            columns([0]).width = 80
             columns([1]).width = 120

            columns([1]).align = :center
            
            columns([2]).width = 35
          
            columns([3]).width = 35
            columns([4]).width = 60
         end

         pdf.move_down 10
      
      table_content3 = ([[{:content =>"DATOS DE LA UNIDAD : " } ]])
     
       pdf.table(table_content3 ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([0]).font_style = :bold
            
           columns([0]).align=:center
                                         
         end
      



      nroitem=1
    
           pdf.move_down 10
      
            row = []
            row << "TRACTO "
            row << @ost.get_placa(@ost.truck_id)
            row << @ost.get_tipounidad(@ost.truck_id)
            row << @ost.get_configura(@ost.truck_id)

            row << @ost.get_clase_cat(@ost.truck_id)

            row << @ost.get_color_unid(@ost.truck_id)

            row << @ost.get_anio(@ost.truck_id)

            row << @ost.get_modelo(@ost.truck_id)

            row << @ost.get_marca(@ost.truck_id)

            row << @ost.get_chv(@ost.truck_id)

            row << @ost.get_ejes(@ost.truck_id)


           
            table_content << row

            row = []
            row << "CARRETA "
            row << @ost.get_placa(@ost.truck2_id)
            row << @ost.get_tipounidad(@ost.truck2_id)
            row << @ost.get_configura(@ost.truck2_id)
row << @ost.get_clase_cat(@ost.truck2_id)

            row << @ost.get_color_unid(@ost.truck2_id)

            row << @ost.get_anio(@ost.truck2_id)

            row << @ost.get_modelo(@ost.truck2_id)

            row << @ost.get_marca(@ost.truck2_id)

            row << @ost.get_chv(@ost.truck2_id)

            row << @ost.get_ejes(@ost.truck2_id)

           
            table_content << row
row = []
            row << "ESCOLTA "
            row << @ost.get_placa(@ost.truck3_id)
            row << @ost.get_tipounidad(@ost.truck3_id)
            row << @ost.get_configura(@ost.truck3_id)

            row << @ost.get_clase_cat(@ost.truck3_id)

            row << @ost.get_color_unid(@ost.truck3_id)

            row << @ost.get_anio(@ost.truck3_id)

            row << @ost.get_modelo(@ost.truck3_id)

            row << @ost.get_marca(@ost.truck3_id)

            row << @ost.get_chv(@ost.truck3_id)

            row << @ost.get_ejes(@ost.truck3_id)
           
            table_content << row


       
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
      
     
  
      
      table_content5 = ([[{:content =>"DATOS DEL CONDUCTOR : " } ]])
     
       pdf.table(table_content5 ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([0]).font_style = :bold
            
           columns([0]).align=:center
                                         
         end
      


        row = []
            row << "CONDUCTOR"
            row << @ost.employee.full_name 
            row << "DNI :"
            row << @ost.employee.idnumber
            row << "LICENCIA:"
            row << @ost.get_licencia(@ost.employee_id)
           
            table_content4 << row


            row = []
            row << "ESCOLTA "
            row << @ost.get_empleado(@ost.employee4_id)
              row << "DNI :"
            row << @ost.get_dni(@ost.employee4_id)
               row << "LICENCIA:"
            row << @ost.get_licencia(@ost.employee4_id)
           
            table_content4 << row



           
       
      result = pdf.table table_content4, {:position => :center,
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
      
      pdf

    end


    def build_pdf_footer_ost2(pdf)
      
      

        pdf.text ""
      
    
         pdf

     end


  def do_crear

    @action_txt = "do_crear" 


    @company = Company.find(1)
    @ost = Tranportorder.last 
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()
    @suppliers = @company.get_suppliers()      
    @almacens = @company.get_almacens()
    @puntos =    @ost.get_puntos()
    @trucks = Truck.all.order(:placa )
     @employees = @ost.get_employees() 
    
  
    @cargas = @company.get_cargas()



    @manifest  = Manifest.find(params[:id] ) 



   if  @manifest.location_id == 5
      @lcSerie =  1
   end 
   if  @manifest.location_id == 1
      @lcSerie =  2
   end 
   if  @manifest.location_id == 6
      @lcSerie =  8
   end 
   

   @code = @ost.generate_ost_number(@lcSerie)  

    

   
    
    @ost = Tranportorder.new(code: @code ,
                             employee_id:  params[:employee_id],
                             employee2_id: params[:employee2_id],
                             employee3_id: params[:employee3_id],
                             employee4_id: params[:employee4_id],
                             truck_id:     params[:truck_id],
                             truck2_id:     params[:truck2_id],
                             truck3_id:     params[:truck3_id],
                             ubication_id:  params[:ubication_id],
                             ubication2_id:  params[:ubication2_id],
                             fecha1:         params[:fecha1], 
                             fecha2:         params[:fecha2], 
                             description:    params[:description],
                             processed:      "1",
                             company_id:     "1",
                             location_id:   @manifest[:location_id] ,
                             division_id:   "1",
                             user_id: current_user.id, 
                             customer_id: @manifest.customer_id,
                             tipocargue_id: @manifest.tipocargue_id,
                             carga: @manifest.especificacion)

        
   

    
    @company = Company.find(1)
    puts "sadas"
    puts @lcFechaEntrega


      respond_to do |format|
       if    @ost.save  
          # Create products for kit
          @ost.add_catalogo(@manifest.id)
          # Check if we gotta process the invoice
          
          
          format.html { redirect_to(tranportorders_path , :notice => 'OST fue grabada con exito .') }
          format.xml  { render :xml => @ost, :status => :created, :location => @ost}
        else
          format.html { render :action => "newost" }
          format.xml  { render :xml => @ost.errors, :status => :unprocessable_entity }
        end 
        
      end
  end 


  def do_stocks

    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Stocks "


    if(params[:year] and params[:year].numeric?)
      @year = params[:year].to_i
    else
      @year = Time.now.year
    end
    
    if(params[:month] and params[:month].numeric?)
      @month = params[:month].to_i
    else
      @month = Time.now.month
    end
    
    if(@month < 10)
      month_s = "0#{@month}"
    else
      month_s = @month.to_s
    end
    
    curr_year = Time.now.year
    c_year = curr_year
    c_month = 1
    
    @years = []
    @months = monthsArr
    @month_name = @months[@month - 1][0]
    
    
    
    while(c_year > Time.now.year - 2)
      @years.push(c_year)
      c_year -= 1
    end


        if(params[:search] and params[:search] != "") 
            @stocks =  @company.get_ost_detalle1( params[:year],params[:month],params[:year1],params[:month1],"%"+ params[:search]+"%")
  
        elsif(params[:search3] and  params[:search3] != "") 
            @stocks =  @company.get_ost_detalle3( params[:year],params[:month],params[:year1],params[:month1],"%"+ params[:search3]+"%")
  
        elsif(params[:search2] and  params[:search2] != "")  
          @stocks =  @company.get_ost_detalle2( params[:year],params[:month],params[:year1],params[:month1],"%"+ params[:search3]+"%")
  
         else  
          @stocks = Tranportorder.where("fecha >= ? ","2021-01-01 00:00:00").paginate(:page => params[:page]) 
        end
        
       return @stocks
    
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tranportorder
      @tranportorder = Tranportorder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tranportorder_params
      params.require(:tranportorder).permit(:code, :employee_id, :truck_id, :employee2_id,:employee3_id, :employee4_id,:truck2_id, :truck3_id,:ubication_id, :ubication2_id, :fecha1, :fecha2, :description, :comments, :processed, :company_id, :location_id, :division_id,:tipocargue_id,:customer_id,:carga)
    end
end
