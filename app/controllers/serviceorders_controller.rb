
include UsersHelper
include SuppliersHelper
include ServicebuysHelper

class ServiceordersController < ApplicationController

  before_filter :authenticate_user!, :checkServices
 

  def build_pdf_header(pdf)

     $lcCli  =  @serviceorder.supplier.name
     $lcdir1 = @serviceorder.supplier.address1
     $lcdir2 =@serviceorder.supplier.address2
     $lcdis  =@serviceorder.supplier.city
     $lcProv = @serviceorder.supplier.state
     $lcFecha1= @serviceorder.fecha1.strftime("%d/%m/%Y") 
     $lcPlaca  = @serviceorder.get_placa
     $lcEmpleado  = @serviceorder.get_empleado 
     
      $lcMon=@serviceorder.moneda.description     
     $lcPay= @serviceorder.payment.descrip
     $lcSubtotal=sprintf("%.2f",@serviceorder.subtotal)
     $lcIgv=sprintf("%.2f",@serviceorder.tax)
     $lcTotal=sprintf("%.2f",@serviceorder.total)

     $lcDetracion=sprintf("%.2f",@serviceorder.detraccion)

     $lcTotal0 = @serviceorder.total   - @serviceorder.detraccion 
     $lcTotal2 = sprintf("%.2f",$lcTotal0)

     $lcAprobado= @serviceorder.get_processed 
    
      pdf.image "#{Dir.pwd}/public/images/logo2020.jpg", :width => 270
        
      pdf.move_down 6
        
      pdf.move_down 4
      #pdf.text supplier.street, :size => 10
      #pdf.text supplier.district, :size => 10
      #pdf.text supplier.city, :size => 10
      pdf.move_down 4

      pdf.bounding_box([325, 725], :width => 200, :height => 80) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C: 20424092941", :align => :center
          pdf.text "ORDEN DE SERVICIO", :align => :center
          pdf.text "#{@serviceorder.code}", :align => :center,
                                 :style => :bold
          
        end
      end
      pdf.move_down 5
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text "__________________________________________________________________________", :size => 13, :spacing => 4
 
    pdf.font "Helvetica" , :size => 6

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
          columns([1]).width = 300
          
        end

        pdf.move_down 5

      end

      headers = []
      table_content = []

      Serviceorder::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @serviceorder.get_services() 
            row = []
            row << nroitem.to_s
            row << product.quantity.to_s
            row << product.name
            row << product.get_name_ext(product.ext_id) 
            row << product.price.round(2).to_s
            row << product.total.round(2).to_s
            table_content << row

            nroitem=nroitem + 1
        end
      ##agrego description para orden de servicio                                     
      row=[]
      row << nroitem.to_s
      row << ""
      row << @serviceorder.description
      row << ""                                  
      row << ""                                  
      row << ""                                  
                         
      
      table_content << row


      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:right
                                          columns([1]).width = 35 
          
                                          columns([2]).align=:left
                                          columns([2]).width = 200
                                          columns([3]).align=:left
                                          columns([3]).width = 150
                                          
                                          columns([4]).align=:right
                                          columns([5]).align=:right
                                        
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

      pdf

    end


    def build_pdf_footer(pdf)

        pdf.font "Helvetica" , :size => 6

        pdf.text ""
        pdf.text ""
        pdf.move_down 10

         pdf.stroke_horizontal_rule

        pdf.text ""
         pdf.text ""
 pdf.move_down 5
       pdf.text "SON : " + @serviceorder.textify.upcase +  @serviceorder.moneda.description 
        pdf.text ""
         pdf.move_down 5
                     pdf.text ""
        
         pdf.stroke_horizontal_rule
      
pdf.move_down 5
        pdf.text "Descripcion : #{@serviceorder.description}", :size => 6, :spacing => 4
        pdf.text "Comentarios : #{@serviceorder.comments}", :size => 6, :spacing => 4
pdf.move_down 5
    
        data =[[$lcEntrega1,{:content=> $lcEntrega3,:rowspan=>2}],
               [$lcEntrega2],
               [$lcEntrega4],
               ]

           {:border_width=>0  }.each do |property,value|
            pdf.text " Instrucciones: "
            pdf.table(data,:cell_style=> {property =>value})
            pdf.move_down 20
           end

   pdf.font "Helvetica" , :size => 6
        pdf.bounding_box([0, 20], :width => 535, :height => 40) do

        pdf.text "_________________                                _____________________                            ____________________      ", :size => 9, :spacing => 4
        pdf.text ""
        pdf.text "                  Elaborado por                                                 V.B.Jefe Compras                                            V.B.Gerencia           ", :size => 9, :spacing => 4
        pdf.draw_text "Company: #{@serviceorder.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf
      
  end



  # Export serviceorder to PDF
  def pdf
    @serviceorder = Serviceorder.find(params[:id])
    company =@serviceorder.company_id
    @company =Company.find(company)

    @instrucciones = @company.get_instruccions()

    @lcEntrega =  @instrucciones.find(6)
    $lcEntrega1 =  @lcEntrega.description1
    $lcEntrega2 =  ""
    $lcEntrega3 =  @lcEntrega.description3
    $lcEntrega4 =  ""

    Prawn::Document.generate("app/pdf_output/#{@serviceorder.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@serviceorder.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end
  
  # Process an serviceorder
  def do_process
    @serviceorder = Serviceorder.find(params[:id])
    @serviceorder[:processed] = "1"
    
    @serviceorder.process
    
    flash[:notice] = "The serviceorder order has been processed."
    redirect_to @serviceorder
  end
  # Process an serviceorder
  def do_anular
    @serviceorder = Serviceorder.find(params[:id])
    @serviceorder[:processed] = "2"
    
    @serviceorder.anular 
    
    flash[:notice] = "The serviceorder order has been anulado."
    redirect_to @serviceorder
  end
  
  # Do send serviceorder via email
  def do_email
    @serviceorder = Serviceorder.find(params[:id])
    @email = params[:email]
    
    Notifier.serviceorder(@email, @serviceorder).deliver
      
    flash[:notice] = "The serviceorder has been sent successfully."
    redirect_to "/serviceorders/#{@serviceorder.id}"
  end

  def do_grabar_ins
    
    @serviceorder = Serviceorder.find(params[:id])

    @company = @serviceorder.company
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()    
    @monedas  = @company.get_monedas()    

    ##Cerrar la order de servicio
    @serviceorder[:processed]='3'
    documento =  @serviceorder[:documento]
    documento_id =  params[:documento_id]

    puts "documento----------------------------------------------**********"
    puts documento
    puts documento_id
    
    if(params[:documento] and params[:documento] != "")
     
    else
        puts documento x
    end
    
    submision_hash = {"document_id" => params[:document_id],
                       "documento"  => params[:documento] }

    respond_to do |format| 
    if  @serviceorder.update2(submision_hash)
        @serviceorder.cerrar()
        
        format.html { redirect_to(@serviceorder, :notice => 'Orden de servicio actualizada  ') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @serviceorder.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # Send serviceorder via email
  def email
    @serviceorder = Serviceorder.find(params[:id])
    @company = @serviceorder.company
  end
  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0
    puts "items "
    puts items 

    for item in items
      if item != ""
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        ext_id = parts[4]
        
        
        
        product = Servicebuy.find(id.to_i)
        product2 = ServiceExtension.find(ext_id.to_i)
        #truck2 = Truck.find(truck_id.to_i)
        #empleado2 = Truck.find(empleado_id.to_i)
        
        product[:i] = i
        product[:quantity] = quantity.to_i
        product[:price] = price.to_f
        product[:discount] = discount.to_f
        product[:ext_id] = product2.id
        product[:name_ext] = product2.name 
        #product[:truck_ext] = truck2.name 
        #product[:empleado_ext] = empleado2.name 
        
        
        total = product[:price] * product[:quantity]
        total -= total * (product[:discount] / 100)
        
        product[:currtotal] = total
        
        @products.push(product)
      end
      
      i += 1
   end
    
    render :layout => false
  end
  
  
  # Autocomplete for products
  def ac_products
    @products = Product.where(["company_id = ? AND (code ILIKE ? OR name ILIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])   
    render :layout => false
  end
  
  # Autocomplete for users
  def ac_user
    company_users = CompanyUser.where(company_id: params[:company_id])
    user_ids = []
    
    for cu in company_users
      user_ids.push(cu.user_id)
    end
    
    @users = User.where(["id IN (#{user_ids.join(",")}) AND (email LIKE ? OR username LIKE ?)", "%" + params[:q] + "%", "%" + params[:q] + "%"])
    alr_ids = []
    
    for user in @users
      alr_ids.push(user.id)
    end
    
    if(not alr_ids.include?(getUserId()))
      @users.push(current_user)
    end
   
    render :layout => false
  end
  
  # Autocomplete for suppliers
  def ac_suppliers
    @suppliers = Supplier.where(["company_id = ? AND (ruc ILIKE ? OR name ILIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])

    render :layout => false
  end
  
  # Show serviceorders for a company
  
  def list_serviceorders
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - serviceorders"
    @filters_display = "block"
    
    @locations = Location.where(company_id: @company.id).order("name ASC")
    @divisions = Division.where(company_id: @company.id).order("name ASC")
    
    if(params[:location] and params[:location] != "")
      @sel_location = params[:location]
    end
    
    if(params[:division] and params[:division] != "")
      @sel_division = params[:division]
    end
  
    if(@company.can_view(current_user))
     
      
        if(params[:search] and params[:search] != "")

          @serviceorders = Serviceorder.paginate(:page => params[:page]).search(params[:search]).order("created_at desc  ")
        else
          @serviceorders = Serviceorder.where(company_id:  @company.id).order("created_at desc").paginate(:page => params[:page])
      

        end

    
      else
        errPerms()
      end
  end
  
  # GET /serviceorders
  # GET /serviceorders.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'serviceorders'
    @pagetitle = "serviceorders"
  end

  # GET /serviceorders/1
  # GET /serviceorders/1.xml
  def show
    @serviceorder = Serviceorder.find(params[:id])
    @supplier = @serviceorder.supplier
  end

  # GET /serviceorders/new
  # GET /serviceorders/new.xml
  
  def new
    @pagetitle = "Nueva Orden"
    @action_txt = "Create"
    
    @serviceorder = Serviceorder.new
    
    @serviceorder[:code] = "#{generate_guid4()}"
    @serviceorder[:processed] = false
    @serviceorder[:detracion_percent] = 12.00
    @serviceorder[:cotiza] = ""
    @serviceorder[:otros] = ""

    #@serviceorder[:fecha1] = Date.today.strftime("%d/%m/%Y").to_s
    
    
    @company = Company.find(params[:company_id])
    @serviceorder.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()    
    @employees = @company.get_employees()
    @trucks = @company.get_trucks()
    @servicebuys  = @company.get_servicebuys()
    @serviceexts  = ServiceExtension.all 
    
    @monedas  = @company.get_monedas()

    @ac_user = getUsername()
    @serviceorder[:user_id] = getUserId()
    
  end

  # GET /serviceorders/1/edit
  def edit
    @pagetitle = "Edit serviceorder"
    @action_txt = "Update"
    
    @serviceorder = Serviceorder.find(params[:id])
    @company = @serviceorder.company
    @ac_supplier = @serviceorder.supplier.name
    @ac_user = @serviceorder.user.username
    @suppliers = @company.get_suppliers()
    @servicebuys  = @company.get_servicebuys()
    @payments = @company.get_payments()
    @monedas  = @company.get_monedas()
    
    @products_lines = @serviceorder.services_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /serviceorders
  # POST /serviceorders.xml
  def create
    @pagetitle = "Nueva Orden"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @serviceorder = Serviceorder.new(serviceorder_params)
    
    @company = Company.find(params[:serviceorder][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @servicebuys  = @company.get_servicebuys()
    @payments = @company.get_payments()
    @monedas  = @company.get_monedas()

    @serviceorder[:subtotal] = @serviceorder.get_subtotal(items)
    
    begin
      @serviceorder[:tax] = @serviceorder.get_tax(items, @serviceorder[:supplier_id])
    rescue
      @serviceorder[:tax] = 0
    end
    
    @serviceorder[:total] = @serviceorder[:subtotal] + @serviceorder[:tax]

    @serviceorder[:dolar] = 0 


    if @serviceorder[:moneda_id] == 2

      if @serviceorder[:total] >= 700.00

        @serviceorder[:detraccion] = @serviceorder[:total] * @serviceorder[:detracion_percent]/100
      else
        @serviceorder[:detraccion] = 0
      end 

    else

      @dolar1 = @company.get_dolar(@serviceorder[:fecha1].to_date )
      if @dolar1
      if @dolar1.compra != nil 
        if @serviceorder[:total]*@dolar1.compra >= 700.00

          @serviceorder[:detraccion] = @serviceorder[:total] * @serviceorder[:detracion_percent]/100

          @serviceorder[:dolar] = @dolar1.compra 
        else
          @serviceorder[:detraccion] = 0
        end 
      end 
     else
          
        if  @serviceorder[:total]* 3.22 >= 700.00

          @serviceorder[:detraccion] = @serviceorder[:total] * @serviceorder[:detracion_percent]/100

          @serviceorder[:dolar] = 3.22
        else
          @serviceorder[:detraccion] = 0
        end 
     end 
    end 
    puts "detracion" 
    puts params[:cbox1]
    
    if  params[:cbox1] == "1"
      
    else 
        @serviceorder[:detraccion] = 0
        
    end 

    
    if(params[:serviceorder][:user_id] and params[:serviceorder][:user_id] != "")
      curr_seller = User.find(params[:serviceorder][:user_id])
      @ac_user = curr_seller.username    
    end


    respond_to do |format|
      if @serviceorder.save
        # Create products for kit
        @serviceorder.add_services(items)
        @serviceorder.correlativo
        # Check if we gotta process the serviceorder
        @serviceorder.process()
        
        format.html { redirect_to(@serviceorder, :notice => 'serviceorder was successfully created.') }
        format.xml  { render :xml => @serviceorder, :status => :created, :location => @serviceorder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @serviceorder.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /serviceorders/1
  # PUT /serviceorders/1.xml
  def update
    @pagetitle = "Editar Orden"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @serviceorder = Serviceorder.find(params[:id])
    @company = @serviceorder.company
    
    if(params[:ac_supplier] and params[:ac_supplier] != "")
      @ac_supplier = params[:ac_supplier]
    else
      @ac_supplier = @serviceorder.supplier.name
    end
    
    @products_lines = @serviceorder.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    
    @serviceorder[:subtotal] = @serviceorder.get_subtotal(items)
    @serviceorder[:tax] = @serviceorder.get_tax(items, @serviceorder[:supplier_id])
    @serviceorder[:total] = @serviceorder[:subtotal] + @serviceorder[:tax]

    respond_to do |format|
      if @serviceorder.update_attributes(params[:serviceorder])
        # Create products for kit
        @serviceorder.delete_products()
        @serviceorder.add_products(items)
        
        # Check if we gotta process the serviceorder
        @serviceorder.process()
        
        format.html { redirect_to(@serviceorder, :notice => 'serviceorder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @serviceorder.errors, :status => :unprocessable_entity }
      end
    end
  end

# PUT /serviceorders/1
  # PUT /serviceorders/1.xml
  def update2
    @pagetitle = "Editar Orden"
    @action_txt = "Update"
    
  
    
    @serviceorder = Serviceorder.find(params[:id])
    @company = @serviceorder.company
    
    if(params[:ac_supplier] and params[:ac_supplier] != "")
      @ac_supplier = params[:ac_supplier]
    else
      @ac_supplier = @serviceorder.supplier.name
    end
    
    @products_lines = @serviceorder.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    
    @serviceorder[:subtotal] = @serviceorder.get_subtotal(items)
    @serviceorder[:tax] = @serviceorder.get_tax(items, @serviceorder[:supplier_id])
    @serviceorder[:total] = @serviceorder[:subtotal] + @serviceorder[:tax]

    respond_to do |format|
      if @serviceorder.update(serviceorder_params)
        # Create products for kit
        @serviceorder.delete_products()
        @serviceorder.add_products(items)
        
        # Check if we gotta process the serviceorder
        @serviceorder.process()
        
        format.html { redirect_to(@serviceorder, :notice => 'serviceorder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @serviceorder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /serviceorders/1
  # DELETE /serviceorders/1.xml
  def destroy
    @serviceorder = Serviceorder.find(params[:id])
    company_id = @serviceorder[:company_id]
    @serviceorder.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/serviceorders/" + company_id.to_s) }
    end
  end

 
 def client_data_headers
      

      client_headers  = [["Proveedor: ",  @serviceorder.supplier.name]]
      client_headers << [" RUC.: ",  @serviceorder.supplier.ruc]
      client_headers << ["Direccion :" , @direccion ]
      client_headers << ["Cotizacion : ", @serviceorder.cotiza ]
    
      client_headers
  end

  def invoice_headers
      invoice_headers  = [["Fecha de emisión: ",@serviceorder.fecha1.strftime("%d/%m/%Y") ]]
      invoice_headers <<  ["Fecha Entrega: ", @serviceorder.fecha2.strftime("%d/%m/%Y")]
      invoice_headers <<  ["Condiciones de pago : ",@serviceorder.payment.descrip  ]
      invoice_headers <<  ["Otros/Referencia : ",@serviceorder.otros  ]
      invoice_headers
  end

  def invoice_summary
      invoice_summary = []
      invoice_summary << ["SubTotal",  ActiveSupport::NumberHelper::number_to_delimited($lcSubtotal,delimiter:",",separator:".").to_s]
      invoice_summary << ["IGV 18% ",ActiveSupport::NumberHelper::number_to_delimited($lcIgv,delimiter:",",separator:".").to_s]
      invoice_summary << ["Total", ActiveSupport::NumberHelper::number_to_delimited($lcTotal ,delimiter:",",separator:".").to_s]

      invoice_summary
    end



  def invoice_summary
      invoice_summary = []
      invoice_summary << ["SubTotal",  ActiveSupport::NumberHelper::number_to_delimited($lcSubtotal,delimiter:",",separator:".").to_s]
      invoice_summary << ["IGV",ActiveSupport::NumberHelper::number_to_delimited($lcIgv,delimiter:",",separator:".").to_s]
      invoice_summary << ["Total", ActiveSupport::NumberHelper::number_to_delimited($lcTotal ,delimiter:",",separator:".").to_s]
      invoice_summary << ["Detraccion", ActiveSupport::NumberHelper::number_to_delimited($lcDetracion,delimiter:",",separator:".")]
      invoice_summary << ["Total a pagar", ActiveSupport::NumberHelper::number_to_delimited($lcTotal2,delimiter:",",separator:".")]
      invoice_summary
    end

# reporte completo
  def build_pdf_header_rpt(pdf)
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
        rows[rows_index] += (client_data_headers_rpt.length >= row ? client_data_headers_rpt[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers_rpt.length >= row ? invoice_headers_rpt[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold
          columns([1]).width = 320
          
        end

        pdf.move_down 10

      end


      
      pdf 
  end   

  def build_pdf_body_rpt(pdf)
    
    pdf.text "Orden Servicio  Emitidas : Año "+@year.to_s+ " Mes : "+@month.to_s , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 8

      headers = []
      table_content = []

      Serviceorder::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @serviceorder_rpt

            row = []
            row << nroitem.to_s
            row << product.fecha1.strftime("%d/%m/%Y")
            row << product.payment.descrip
            row << product.code
            row << product.supplier.name  
            row << product.subtotal.to_s
            row << product.tax.to_s
            row << product.total.to_s
            row << product.get_processed
            table_content << row

            nroitem=nroitem + 1
        
        end


  ## TOTALES  PIE DE PAGINA 
      subtotals = []
      taxes = []
      totals = []
      detraccions =[]

      services_subtotal = 0
      services_tax = 0
      services_total = 0
      services_detraccion = 0

          subtotal = @company.get_services_day2(@fecha1,@fecha2, "subtotal")
          subtotals.push(subtotal)
          services_subtotal += subtotal          

      
        
        
          tax = @company.get_services_day2(@fecha1,@fecha2, "tax")
          taxes.push(tax)
          services_tax += tax
        
                
          total = @company.get_services_day2(@fecha1,@fecha2, "total")
          totals.push(total)
          services_total += total
        
      

          detraccion = @company.get_services_day2(@fecha1,@fecha2, "detraccion")
          detraccions.push(detraccion)
          services_detraccion += detraccion
                    
            row = []
            row << " "
            row << " "
            row << " "
            row << " "
            row << " "
            row << subtotal.to_s
            row << tax.to_s
            row << total.to_s
            row << " "

            table_content << row

  ## TOTAL PIE DE PAGINA 

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left  
                                          columns([5]).align=:right
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer_rpt(pdf)
                  

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end



  # Export serviceorder to PDF
  def rpt_serviceorder_all_pdf
    @company=Company.find(params[:id])      
    
      @fecha1 = params[:fecha1]
      @fecha2 = params[:fecha2]
    
    

    @serviceorder_rpt = @company.get_services_day(@fecha1,@fecha2)  
      
    Prawn::Document.generate("app/pdf_output/rpt_serviceall.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt(pdf)
        pdf = build_pdf_body_rpt(pdf)
        build_pdf_footer_rpt(pdf)
        $lcFileName =  "app/pdf_output/rpt_serviceall.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end

  def receive

    @pagetitle = "Generar "
    @action_txt = "grabar_ins"
    
    @serviceorder = Serviceorder.find(params[:id])
    @supplier = @serviceorder.supplier
    @company = Company.find(@serviceorder.company_id)
    @documents =@company.get_documents()

    
  end


  def client_data_headers_rpt
      client_headers  = [["Empresa  :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]
      client_headers
  end

  def invoice_headers_rpt            
      invoice_headers  = [["Fecha : ",$lcHora]]    
      invoice_headers
  end
def list_receive_serviceorders
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Orden Compra"
    @filters_display = "block"
    
    @locations = Location.where(company_id: @company.id).order("name ASC")
    @divisions = Division.where(company_id: @company.id).order("name ASC")
    
    if(params[:location] and params[:location] != "")
      @sel_location = params[:location]
    end
    
    if(params[:division] and params[:division] != "")
      @sel_division = params[:division]
    end
  
    if(@company.can_view(current_user))
      if(params[:ac_supplier] and params[:ac_supplier] != "")
        @supplier = supplier.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_supplier].strip})
        
        if @supplier
          @serviceorders = Seriveorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any serviceorders for that supplier."
          redirect_to "/companies/serviceorders/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = supplier.find(params[:supplier])
        
        if @supplier
          @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any serviceorders for that supplier."
          redirect_to "/companies/serviceorders/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @serviceorders = Serviceorder.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @serviceorders = Serviceorder.where(company_id:  @company.id, :processed => "1").order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end

  def discontinue

  end 
  
  
  private
  def serviceorder_params
    params.require(:serviceorder).permit(:company_id,:location_id,:division_id,:supplier_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:detraccion,:payment_id,:moneda_id,:fecha1,:fecha2,:fecha3,:fecha4,:document_id,:documento,:dolar,:truck_id,:employee_id,:detracion_percent,:cotiza,:otros)
  end

end

