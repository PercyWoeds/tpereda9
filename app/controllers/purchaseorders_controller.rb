
include UsersHelper
include SuppliersHelper
include ProductsHelper

class PurchaseordersController < ApplicationController
  before_filter :authenticate_user!, :checkProducts
##
## REPORTE DE COMPRAS
##

 def build_pdf_header1(pdf)
    pdf.font "Helvetica" , :size => 6
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

      end

        pdf.move_down 10

      end

      pdf
  end

  def build_pdf_body1(pdf)

    pdf.text "Ordenes de compra Emitidas : Fecha "+@fecha1.to_s+ " Mes : "+@fecha2.to_s , :size => 11
    pdf.text ""
    pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6


      headers = []
      table_content = []

      Purchaseorder::TABLE_HEADERS1.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

      for ordencompra in @rpt_detalle_purchaseorder

           $lcNumero = ordencompra.code
           $lcFecha = ordencompra.fecha1
           $lcProveedor = ordencompra.supplier.name

          @orden_compra1  = @company.get_orden_detalle(ordencompra.id)


       for  orden in @orden_compra1
            row = []
            row << nroitem.to_s
            row << $lcProveedor
            row << $lcNumero
            row << $lcFecha.strftime("%d/%m/%Y")
            row << orden.quantity.to_s
            row << orden.product.code
            row << orden.product.name
            row << orden.price.round(2).to_s
            row << orden.discount.round(2).to_s
            row << orden.total.round(2).to_s
            table_content << row
            puts nroitem.to_s
            nroitem=nroitem + 1
        end

      end


      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:center
                                          columns([3]).align=:center
                                          columns([4]).align=:left
                                          columns([5]).align=:left
                                          columns([6]).align=:left
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                        end

      pdf.move_down 10
      pdf

    end


    def build_pdf_footer1(pdf)

        pdf.text ""
        pdf.text ""


     end


  # Export purchaseorder to PDF
  def rpt_purchaseorder_all

    @company =Company.find(1)
    @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]

    @rpt_detalle_purchaseorder = @company.get_purchaseorder_detail(@fecha1,@fecha2)

    Prawn::Document.generate("app/pdf_output/orden_1.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header1(pdf)
        pdf = build_pdf_body1(pdf)
        build_pdf_footer1(pdf)
        $lcFileName =  "app/pdf_output/orden_1.pdf"

    end

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName

    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end

##
##



def build_pdf_header(pdf)

     $lcCli  =  @purchaseorder.supplier.name
     $lcdir1 = @purchaseorder.supplier.address1
     $lcdir2 =@purchaseorder.supplier.address2
     $lcdis  =@purchaseorder.supplier.city
     $lcProv = @purchaseorder.supplier.state

     $lcFecha1= @purchaseorder.fecha1.strftime("%d/%m/%Y")
     $lcMon=@purchaseorder.moneda.description
     $lcPay= @purchaseorder.payment.descrip

     $lcSubtotal=sprintf("%.2f",(@purchaseorder.subtotal).round(2))
     $lcIgv=sprintf("%.2f",(@purchaseorder.tax).round(2))
     $lcTotal=sprintf("%.2f",(@purchaseorder.total).round(2))

     $lcDetracion=@purchaseorder.detraccion
     $lcAprobado= @purchaseorder.get_processed

      pdf.image "#{Dir.pwd}/public/images/logo2020.jpg", :width => 270

      pdf.move_down 6

      
      pdf.bounding_box([325, 725], :width => 200, :height => 80) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C: 20424092941", :align => :center
          pdf.text "ORDEN DE COMPRA", :align => :center
          pdf.text "#{@purchaseorder.code}", :align => :center,
                                 :style => :bold

        end
      end
      pdf.move_down 2
         pdf
  end

  def build_pdf_body(pdf)

    pdf.text "__________________________________________________________________________", :size => 13, :spacing => 4
    
    pdf.font "Helvetica" , :size => 6
    @direccion = ""
   if  @purchaseorder.supplier.address1 == nil 
    @direccion =""
   else 
    @direccion =  @purchaseorder.supplier.address1
  end 

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
          columns([1]).align = :left

        end

        pdf.move_down 5

      end

      headers = []
      table_content = []

      Purchaseorder::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @purchaseorder.get_products()
            row = []
            row << nroitem.to_s
            row << product.quantity.to_s

            row << product.get_unidad(product.unidad_id)
            row << product.code
            row << product.name
            row << product.numparte
            
            row << product.price.round(2).to_s
        
            row << product.total.round(2).to_s
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
                                          columns([4]).align=:left 
                                          
                                          columns([5]).align=:right
                                          columns([6]).align=:right
                                           columns([7]).align=:right


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
       pdf.text "SON : " + @purchaseorder.textify.upcase +  @purchaseorder.moneda.description 
        pdf.text ""
         pdf.move_down 5
                     pdf.text ""
        
         pdf.stroke_horizontal_rule
      
pdf.move_down 5
        pdf.text "Descripcion : #{@purchaseorder.description}", :size => 6, :spacing => 4
        pdf.text "Comentarios : #{@purchaseorder.comments}", :size => 6, :spacing => 4
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

        pdf.text "_________________               _____________________         ____________________      ", :size => 9, :spacing => 4
        pdf.text ""
        pdf.text "                  Elaborado por                                                 V.B.Jefe Compras                                            V.B.Gerencia           ", :size => 9, :spacing => 4
        pdf.draw_text "Company: #{@purchaseorder.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf

  end


  # Export purchaseorder to PDF
  def pdf
    @purchaseorder = Purchaseorder.find(params[:id])
    company =@purchaseorder.company_id
    @company =Company.find(company)

    @instrucciones = @company.get_instruccions()

    @lcEntrega =  @instrucciones.find(1)
    $lcEntrega1 =  @lcEntrega.description1
    $lcEntrega2 =  @lcEntrega.description2
    $lcEntrega3 =  @lcEntrega.description3
    $lcEntrega4 =  @lcEntrega.description4

    Prawn::Document.generate("app/pdf_output/#{@purchaseorder.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@purchaseorder.id}.pdf"

    end

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end

 def client_data_headers
  

      client_headers  = [["Proveedor: ",  @purchaseorder.supplier.name]]
      client_headers << [" RUC.: ",  @purchaseorder.supplier.ruc]
      client_headers << ["Direccion :" , @direccion ]
      client_headers << ["Cotizacion : ", @purchaseorder.cotiza ]
    
      client_headers
  end

  def invoice_headers
      invoice_headers  = [["Fecha de emisión: ",@purchaseorder.fecha1.strftime("%d/%m/%Y") ]]
      invoice_headers <<  ["Fecha Entrega: ", @purchaseorder.fecha2.strftime("%d/%m/%Y")]
      invoice_headers <<  ["Condiciones de pago : ",@purchaseorder.payment.descrip  ]
      invoice_headers <<  ["Otros/Referencia : ",@purchaseorder.otros  ]
      invoice_headers
  end

  def invoice_summary
      invoice_summary = []
      invoice_summary << ["SubTotal",  ActiveSupport::NumberHelper::number_to_delimited($lcSubtotal,delimiter:",",separator:".").to_s]
      invoice_summary << ["IGV 18% ",ActiveSupport::NumberHelper::number_to_delimited($lcIgv,delimiter:",",separator:".").to_s]
      invoice_summary << ["Total", ActiveSupport::NumberHelper::number_to_delimited($lcTotal ,delimiter:",",separator:".").to_s]

      invoice_summary
    end


  def populate_order

    for cart_item in @cart.cart_items
    order_item = Item.new(
    :product_id => cart_item.id,
    :description => cart_item.name,
    :quantity => cart_item.quantity,
    :qty      => cart_item.qty,
    :recibir  => cart_item.recibir
    )

    @purchaseorder.purchaseorder_details << order_item
    end
  end


  def do_grabar_ins
    @purchaseorder = Purchaseorder.find(params[:id])

    populate_order

    flash[:notice] = "The purchaseorder order has been grabada."
    redirect_to @purchaseorder
  end
  # Process an purchaseorder
  def do_cerrar
    @purchaseorder = Purchaseorder.find(params[:id])
    @purchaseorder[:processed] = "3"

    @purchaseorder.process

    flash[:notice] = "The purchaseorder order has been processed closed"
    redirect_to @purchaseorder
  end

  def do_process
    @purchaseorder = Purchaseorder.find(params[:id])
    @purchaseorder[:processed] = "1"

    @purchaseorder.process

    flash[:notice] = "The purchaseorder order has been processed."
    redirect_to @purchaseorder
  end

  # Do send purchaseorder via email
  def do_email
    @purchaseorder = Purchaseorder.find(params[:id])
    @email = params[:email]

    Notifier.purchaseorder(@email, @purchaseorder).deliver

    flash[:notice] = "The purchaseorder has been sent successfully."
    redirect_to "/purchaseorders/#{@purchaseorder.id}"
  end

  # Send purchaseorder via email
  def email
    @purchaseorder = Purchaseorder.find(params[:id])
    @company = @purchaseorder.company
  end

  # List items
  def list_items

    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0

    for item in items
      if item != ""
        parts = item.split("|BRK|")

        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]

        product = Product.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_f
        product[:price] = price.to_f
        product[:discount] = discount.to_f

        total = product[:price] * product[:quantity]
        total -= total * (product[:discount] / 100)

        product[:CurrTotal] = total

        @products.push(product)
      end

      i += 1
   end

    render :layout => false
  end


  # Autocomplete for products
  def ac_products
    @products = Product.where(["company_id = ? AND (code iLIKE ? OR name iLIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])

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
    @suppliers = Supplier.where(["company_id = ? AND (ruc  iLIKE ? OR name iLIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])

    render :layout => false
  end

  # Show purchaseorders for a company
  def list_purchaseorders
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
          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any purchaseorders for that supplier."
          redirect_to "/companies/purchaseorders/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = supplier.find(params[:supplier])

        if @supplier
          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any purchaseorders for that supplier."
          redirect_to "/companies/purchaseorders/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @purchaseorders = Purchaseorder.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  # Show purchaseorders for a company
  def list_receiveorders
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
          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any purchaseorders for that supplier."
          redirect_to "/companies/purchaseorders/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = supplier.find(params[:supplier])

        if @supplier
          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any purchaseorders for that supplier."
          redirect_to "/companies/purchaseorders/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @purchaseorders = Purchaseorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @purchaseorders = Purchaseorder.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @purchaseorders = Purchaseorder.where(company_id:  @company.id, :processed => "1").order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end

  # GET /purchaseorders
  # GET /purchaseorders.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'purchaseorders'
    @pagetitle = "purchaseorders"
  end

  # GET /purchaseorders/1
  # GET /purchaseorders/1.xml
  def show
    @purchaseorder = Purchaseorder.find(params[:id])
    @supplier = @purchaseorder.supplier

  end

  def receive
    @purchaseorder = Purchaseorder.find(params[:id])
    @supplier = @purchaseorder.supplier
    @company = Company.find(@purchaseorder.company_id)
    @documents =@company.get_documents()
  end

  # GET /purchaseorders/new
  # GET /purchaseorders/new.xml

  def new
    @pagetitle = "Nueva Orden Compra"
    @action_txt = "Create"

    @purchaseorder = Purchaseorder.new

    @purchaseorder[:code] = @purchaseorder.get_maximo()
    @purchaseorder[:processed] = false

    @company = Company.find(params[:company_id])
    @purchaseorder.company_id = @company.id

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments  = @company.get_payments()
    @monedas    = @company.get_monedas()


    @ac_user = getUsername()
    @purchaseorder[:user_id] = getUserId()
    @purchaseorder[:fecha1] = Date.today 
    @purchaseorder[:fecha2] = Date.today
    @purchaseorder[:location_id ] = 3 
    @purchaseorder[:cotiza] = ""
    @purchaseorder[:otros ] = ""
  end

  # GET /purchaseorders/1/edit
  def edit
    @pagetitle = "Editar Orden Compra"
    @action_txt = "Update"

    @purchaseorder = Purchaseorder.find(params[:id])
    @company = @purchaseorder.company
    @ac_supplier = @purchaseorder.supplier.name
    @ac_user = @purchaseorder.user.username
    @suppliers = @company.get_suppliers()
    @payments  = @company.get_payments()
    @monedas  = @company.get_monedas()

    @products_lines = @purchaseorder.products_lines

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /purchaseorders
  # POST /purchaseorders.xml
  def create
    @pagetitle = "Nueve Orden de Compra"
    @action_txt = "Create"

    items = params[:items].split(",")

    @purchaseorder = Purchaseorder.new(purchaseorder_params)

    @company = Company.find(params[:purchaseorder][:company_id])

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()
    @monedas  = @company.get_monedas()

    @tipodocumento = @purchaseorder[:document_id]


    if @tipodocumento == 3
    @purchaseorder[:subtotal] = @purchaseorder.get_subtotal(items)*-1
    else
    @purchaseorder[:subtotal] = @purchaseorder.get_subtotal(items)

    end

    begin
      if @tipodocumento == 3
      @purchaseorder[:tax] = @purchaseorder.get_tax(items, @purchaseorder[:supplier_id])*-1
      else
      @purchaseorder[:tax] = @purchaseorder.get_tax(items, @purchaseorder[:supplier_id])
      end
    rescue
      @purchaseorder[:tax] = 0
    end

    @purchaseorder[:total] = @purchaseorder[:subtotal] + @purchaseorder[:tax]

    if(params[:purchaseorder][:user_id] and params[:purchaseorder][:user_id] != "")
      curr_seller = User.find(params[:purchaseorder][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @purchaseorder.save
        # Create products for kit
        @purchaseorder.add_products(items)
        # Check if we gotta process the purchaseorder
        @purchaseorder.correlativo
        @purchaseorder.process()

        format.html { redirect_to(@purchaseorder, :notice => 'purchaseorder was successfully created.') }
        format.xml  { render :xml => @purchaseorder, :status => :created, :location => @purchaseorder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @purchaseorder.errors, :status => :unprocessable_entity }
      end
    end
  end


  # PUT /purchaseorders/1
  # PUT /purchaseorders/1.xml
  def update
    @pagetitle = "Editar Orden Compra"
    @action_txt = "Update"

    items = params[:items].split(",")

    @purchaseorder = Purchaseorder.find(params[:id])
    @company = @purchaseorder.company

    if(params[:ac_supplier] and params[:ac_supplier] != "")
      @ac_supplier = params[:ac_supplier]
    else
      @ac_supplier = @purchaseorder.supplier.name
    end

    @products_lines = @purchaseorder.products_lines

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()

    @monedas  = @company.get_monedas()

    @purchaseorder[:subtotal] = @purchaseorder.get_subtotal(items)
    @purchaseorder[:tax]      = @purchaseorder.get_tax(items, @purchaseorder[:supplier_id])
    @purchaseorder[:total]    = @purchaseorder[:subtotal] + @purchaseorder[:tax]

    respond_to do |format|
      if @purchaseorder.update_attributes(params[:purchaseorder])
        # Create products for kit
        @purchaseorder.delete_products()
        @purchaseorder.add_products(items)
        # Check if we gotta process the purchaseorder
        @purchaseorder.process()

        format.html { redirect_to(@purchaseorder, :notice => 'purchaseorder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchaseorder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /purchaseorders/1
  # DELETE /purchaseorders/1.xml
  def destroy
    @purchaseorder = Purchaseorder.find(params[:id])
    company_id = @purchaseorder[:company_id]
    @purchase =  Purchase.find_by(purchaseorder_id: @purchaseorder.id)
    @company = @purchaseorder.company

    if @purchase

    else
    @purchaseorder.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/purchaseorders/" + company_id.to_s) }
    end
    end
  end

  #reporte de order de compra

   def build_pdf_header2(pdf)
    pdf.font "Helvetica" , :size => 6
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

      end

        pdf.move_down 10

      end

      pdf
  end

  def build_pdf_body2(pdf)

    pdf.text "Ordenes de compra Emitidas : Fecha "+@fecha1.to_s+ " Hasta : "+@fecha2.to_s , :size => 11
    pdf.text ""
    pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6


      headers = []
      table_content = []

      Purchaseorder::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcmonedasoles   = 2
      lcmonedadolares = 1


      lcDoc='FT'

       lcCliente = @rpt_purchaseorder.first.supplier_id

       for  product in @rpt_purchaseorder

          if lcCliente == product.supplier_id

            fechas2 = product.fecha2

            row = []
            row << nroitem.to_s
            row << product.code
            row << product.fecha1.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
            row << product.supplier.name
            row << product.moneda.symbol

            if product.moneda_id == 1
                row << "0.00 "
                row << sprintf("%.2f",product.total.to_s)
            else
                row << sprintf("%.2f",product.total.to_s)
                row << "0.00 "
            end
            row << " "

            table_content << row

            nroitem = nroitem + 1

          else
            totals = []
            total_cliente_soles = 0
            total_cliente_soles = @company.get_purchases_by_day_value_supplier(@fecha1,@fecha2,lcmonedadolares,lcCliente)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_purchases_by_day_value_supplier(@fecha1,@fecha2,lcmonedasoles,lcCliente)

            row =[]
            row << ""
            row << ""
            row << ""
            row << ""
            row << "TOTALES POR PROVEEDOR=> "
            row << ""
            row << sprintf("%.2f",total_cliente_dolares.to_s)
            row << sprintf("%.2f",total_cliente_soles.to_s)
            row << " "

            table_content << row

            lcCliente = product.supplier_id

            row = []
            row << lcDoc
            row << product.code
            row << product.fecha1.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
            row << product.supplier.name
            row << product.moneda.symbol

            if product.moneda_id == 1
                row << "0.00 "
                row << sprintf("%.2f",product.total.to_s)
            else
                row << sprintf("%.2f",product.total.to_s)
                row << "0.00 "
            end
            row << " "


            table_content << row



          end


        end

            lcProveedor = @rpt_purchaseorder.last.supplier_id

            totals = []
            total_cliente = 0

            total_cliente_soles   = 0
            total_cliente_soles   = @company.get_purchaseorders_day_value2(@fecha1,@fecha2, lcProveedor, lcmonedadolares,'total')
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_purchaseorders_day_value2(@fecha1,@fecha2, lcProveedor, lcmonedasoles,'total')


            row =[]
            row << ""
            row << ""
            row << ""
            row << ""
            row << "TOTALES POR PROVEEDOR => "
            row << ""
            row << sprintf("%.2f",total_cliente_dolares.to_s)
            row << sprintf("%.2f",total_cliente_soles.to_s)
            row << " "
            table_content << row

          total_soles   = @company.get_purchaseorders_totalday_value(@fecha1,@fecha2, "total",lcmonedasoles)
          total_dolares = @company.get_purchaseorders_totalday_value(@fecha1,@fecha2, "total",lcmonedadolares)

           if $lcxCliente == "0"

          row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          row << "TOTALES => "
          row << ""
          row << sprintf("%.2f",total_soles.to_s)
          row << sprintf("%.2f",total_dolares.to_s)
          row << " "
          table_content << row
          end

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
                                          columns([8]).align=:right
                                        end

      pdf.move_down 10

      #totales

      pdf

    end


    def build_pdf_footer2(pdf)

        pdf.text ""
        pdf.text ""


     end


  # Export purchaseorder to PDF
  def rpt_purchaseorder2_all
    $lcxCliente = "0"
    @company =Company.find(1)
    @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]

    @rpt_purchaseorder = @company.get_purchaseorder_detail2(@fecha1,@fecha2)

    Prawn::Document.generate("app/pdf_output/orden_1.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header2(pdf)
        pdf = build_pdf_body2(pdf)
        build_pdf_footer2(pdf)
        $lcFileName =  "app/pdf_output/orden_1.pdf"

    end

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName

    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end

##
##

  #fin reporte de orden de compra

  def rpt_purchaseorder3_all
    $lcxCliente = "0"
    @company =Company.find(1)
    @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]

    @rpt_purchaseorder = @company.get_purchaseorder_detail2(@fecha1,@fecha2)

    Prawn::Document.generate("app/pdf_output/orden_1.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header2(pdf)
        pdf = build_pdf_body2(pdf)
        build_pdf_footer2(pdf)
        $lcFileName =  "app/pdf_output/orden_1.pdf"

    end

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName

    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end


  private
  def purchaseorder_params
    params.require(:purchaseorder).permit(:company_id,:location_id,:division_id,
      :supplier_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,
      :return,:date_processed,:user_id,:moneda_id,:fecha1,:fecha2,:payment_id,
      :cotiza,:fecha_entrega,:otros)

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



end

