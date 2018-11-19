include UsersHelper
include CustomersHelper
include ServicesHelper
require "open-uri"
 
class FacturasController < ApplicationController
  
    $: << Dir.pwd  + '/lib'

 # before_filter :authenticate_user!
 
 
 

  def reportes
  
    @company=Company.find(1)          
    @fecha = params[:fecha1]    
    
    @parte_rpt = @company.get_parte_1(@fecha)
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "varillajes/parte_rpt.pdf.erb",locals: {:varillajes => @parte_rpt}
        
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
  end
  
  def reportes2 
  
    @company=Company.find(1)          
    @fecha = params[:fecha1]    
    
    @parte_rpt = @company.get_parte_1(@fecha)
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "varillajes/parte2_rpt.pdf.erb",locals: {:varillajes => @parte_rpt}
        
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
  end
  
  def reportes3 
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    
    @contado_rpt = @company.get_parte_2(@fecha1,@fecha2)
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "varillajes/parte3_rpt.pdf.erb",locals: {:varillajes => @contado_rpt}
        
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
  end

def reportes4 
    $lcFacturasall = '1'

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    
  

    @facturas_rpt = @company.get_facturas_day(@fecha1,@fecha2,@moneda)          
    
    @total1  = @company.get_facturas_by_day_value(@fecha1,@fecha2,@moneda,"subtotal")  
    @total2  = @company.get_facturas_by_day_value(@fecha1,@fecha2,@moneda,"tax")  
    @total3  = @company.get_facturas_by_day_value(@fecha1,@fecha2,@moneda,"total")  
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas_rpt.pdf.erb",locals: {:facturas => @facturas_rpt}
        
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
  end
  
def reportes03


    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_ventas_combustibles(@fecha1,@fecha2)          
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas03_rpt.pdf.erb",
         locals: {:facturass => @facturas_rpt},
         :orientation      => 'Landscape',
         
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
  end
  
def reportes05


    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_ventas_combustibles_producto(@fecha1,@fecha2)          
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas05_rpt.pdf.erb",
         locals: {:facturass => @facturas_rpt},
         :orientation      => 'Landscape',
         
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        end   
      when "To Excel" then render xlsx: 'reportes05'
        
      else render action: "index"
    end
  end

  def discontinue
    
    @facturasselect = Factura.find(params[:products_ids])

    for item in @guiasselect
        begin
          a = item.id
          b = item.remite_id               
          new_invoice_guia = Deliverymine.new(:mine_id =>$minesid, :delivery_id =>item.id)          
          new_invoice_guia.save
           
        
         end              
    end
  end  
  def excel

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]

    @facturas_rpt = @company.get_facturas_day(@fecha1,@fecha2)      

    respond_to do |format|
      format.html    
        format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end 
  end 

  def import
      Factura.import(params[:file])
       redirect_to root_url, notice: "Factura importadas."
  end 


    # Export invoice to PDF
  def pdf
    @invoice = Factura.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/facturas/pdf/#{@invoice.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an invoice
  def do_process
    @invoice = Factura.find(params[:id])
    @invoice[:processed] = "1"
    @invoice.process
    
    flash[:notice] = "The invoice order has been processed."
    redirect_to @invoice
  end
  
  # Do send invoice via email
  def do_email
    @invoice = Factura.find(params[:id])
    @email = params[:email]
    
    Notifier.invoice(@email, @invoice).deliver
    
    flash[:notice] = "The invoice has been sent successfully."
    redirect_to "/facturas/#{@invoice.id}"
  end
  
  # Send invoice via email
  def email
    @invoice = Factura.find(params[:id])
    @company = @invoice.company
  end

  def do_anular
    @invoice = Factura.find(params[:id])
    @invoice[:processed] = "2"
    
    @invoice.anular 
    @invoice.delete_guias()
  
    flash[:notice] = "Documento a sido anulado."
    redirect_to @invoice 
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
        
        product = Service.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_f
        product[:price] = price.to_f
        product[:discount] = discount.to_f
        
        total = product[:price] * product[:quantity]
        total -= total * (product[:discount] / 100)
        
        product[:currtotal] = total
        
        @products.push(product)
      end
      
      i += 1
   end
    
    render :layout => false
  end
  
  def list_items2
    
    @company = Company.find(params[:company_id])
    items = params[:items2]
    items = items.split(",")
    items_arr = []
    @guias = []
    i = 0

    for item in items
      if item != ""
        parts = item.split("|BRK|")

        puts parts

        id = parts[0]      
        product = Delivery.find(id.to_i)
        product[:i] = i

        @guias.push(product)


      end
      
      i += 1
    end

    render :layout => false
  end 

  def ac_facturas  

    @facturas = Factura.where(["company_id = ? AND (code LIKE ?)", params[:company_id], "%" + params[:q] + "%"])   
    render :layout => false
  end
  
  
  # Autocomplete for products
  def ac_guias
    procesado = '1'
    @guias = Delivery.where(["company_id = ? AND (code LIKE ?)   ", params[:company_id], "%" + params[:q] + "%"])   
    render :layout => false
  end

  
  # Autocomplete for products
  def ac_services
    @products = Service.where(["company_id = ? AND (code LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
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
  
  # Autocomplete for customers
  def ac_customers
    @customers = Customer.where(["company_id = ? AND (ruc iLIKE ? OR name iLIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show invoices for a company
  def list_invoices
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Invoices"
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

         @invoices = Factura.all.order('fecha DESC',"code DESC").paginate(:page => params[:page])
        if params[:search]
          @invoices = Factura.search(params[:search]).order('fecha DESC',"code DESC").paginate(:page => params[:page])
        else
          @invoices = Factura.order('fecha DESC',"code DESC").paginate(:page => params[:page]) 
        end

    
    else
      errPerms()
    end
  end
  
  # GET /invoices
  # GET /invoices.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'factura'
    @pagetitle = "Facturas"
    

    @invoicesunat = Invoicesunat.order(:numero)    

    @company= Company.find(1)

  end

  def export
    @company = Company.find(params[:company_id])
    @facturas  = Factura.all
  end
  def export3
    @company = Company.find(params[:company_id])
    @facturas  = Factura.all
  end
  def export4
    @company = Company.find(params[:company_id])
    @facturas  = Factura.all
  end

  def generar4
    
    @company = Company.find(params[:company_id])
     Csubdiario.delete_all
     Dsubdiario.delete_all


     fecha1 =params[:fecha1]
     fecha2 =params[:fecha2]

     @facturas = @company.get_facturas_day(fecha1,fecha2)

      $lcSubdiario='05'

      subdiario = Numera.find_by(:subdiario=>'12')

      lastcompro = subdiario.compro.to_i + 1
      $lastcompro1 = lastcompro.to_s.rjust(4, '0')

        item = fecha1.to_s 
        parts = item.split("-")        
        
        mm    = parts[1]        

      if subdiario
          nrocompro = mm << $lastcompro1
      end


     for f in @facturas
        
        $lcFecha =f.fecha.strftime("%Y-%m-%d")   
        

      newsubdia =Csubdiario.new(:csubdia=>$lcSubdiario,:ccompro=>$lastcompro1,:cfeccom=>$lcFecha, :ccodmon=>"MN",
        :csitua=>"F",:ctipcam=>"0.00",:cglosa=>f.code,:csubtotal=>f.subtotal,:ctax=>f.tax,:ctotal=>f.total,
        :ctipo=>"V",:cflag=>"N",:cdate=>$lcFecha ,:chora=>"",:cfeccam=>"",:cuser=>"SIST",
        :corig=>"",:cform=>"M",:cextor=>"",:ccodane=>f.customer.ruc ) 

        newsubdia.save

      lastcompro = lastcompro + 1
      $lastcompro1 = lastcompro.to_s.rjust(4, '0')      

      end 

      subdiario.compro = $lastcompro1
      subdiario.save

      @invoice = Csubdiario.all
      send_data @invoice.to_csv  , :filename => 'CC0317.csv'

    
  end

  def generar5

      option =  params[:archivo]
      puts option

      if option == "Ventas Cabecera"

        @invoice = Csubdiario.all
        send_data @invoice.to_csv  , :filename => 'CC0317.csv'

      else
        @invoice = Dsubdiario.all
        send_data @invoice.to_csv  , :filename => 'CD0317.csv'
      end 
  end 

  def export2
    Invoicesunat.delete_all
    @company = Company.find(params[:company_id])
    
    @facturas  = Factura.where(:tipo => 1)
     a = ""
     
     lcGuia=""
    for f in @facturas      
        @fec =(f.code)
        parts = @fec.split("-")
        lcSerie  = parts[0]
        lcNumero = parts[1]
        lcFecha  = f.fecha 
        
        lcTD = f.document.descripshort
        lcVventa = f.subtotal
        lcIGV = f.tax
        lcImporte = f.total 
        lcFormapago = f.payment.descrip
        lcRuc = f.customer.ruc         
        lcDes = f.description
        lcMoneda = f.moneda_id 
        lcDescrip=""
        lcPsigv = 0 
        lcPcigv = 0
        lcCantidad = 0
        lcGuia = ""
        lcComments = ""
        lcDes1 = ""
        
        for productItem in f.get_products2(f.id)

        lcPsigv= productItem.price
        lcPsigv1= lcPsigv*1.18
        lcPcigv = lcPsigv1.round(2)
        lcCantidad= productItem.quantity
        lcDescrip = ""
        lcDescrip << productItem.name + "\n"
        lcDescrip << lcDes
        a = ""        
        lcDes1 = ""

        begin
          a << " "
              for guia in f.get_guias2(f.id)
              a << " GT: " <<  guia.code << " "
              if guia.description == nil
                
              else  
                  a << " " << guia.description                   
              end   
              existe1 = f.get_guias_remision(guia.id)
                if existe1.size > 0 
                  a<<  "\n GR:" 
                  for guias in  f.get_guias_remision(guia.id)    
                     a<< guias.delivery.code<< ", " 
                  end     
                end      
              end
              existe2 = f.get_guiasremision2(f.id)
              if existe2.size > 0
              a << "\n GR : "
                for guia in f.get_guiasremision2(f.id)
                  a << guia.code << "  "            
                end
              end 
            lcDes1 << a
            lcComments = ""
        end
        
        new_invoice_item= Invoicesunat.new(:cliente => lcRuc, :fecha => lcFecha,:td =>lcTD,
        :serie => lcSerie,:numero => lcNumero,:preciocigv => lcPcigv ,:preciosigv =>lcPsigv,:cantidad =>lcCantidad,
        :vventa => lcVventa,:igv => lcIGV,:importe => lcImporte,:ruc =>lcRuc,:guia => lcGuia,:formapago =>lcFormapago,
        :description => lcDescrip,:comments => lcComments,:descrip =>lcDes1,:moneda =>lcMoneda )
        new_invoice_item.save
        
      end  
    end 
    lcFecha='2017-05-30 00:00:00'
    lcTD="FT"
    lcSerie = "001"
    lcNumero= '470'
    lcRuc='20100082391'
    

     new_invoice_item= Invoicesunat.new(:cliente =>lcRuc, :fecha => lcFecha ,:td =>lcTD,
        :serie => lcSerie,:numero => lcNumero,:preciocigv => 0.00 ,:preciosigv =>0.00,:cantidad =>0.00,
        :vventa => 0.00 ,:igv => 0.00,:importe => 0.00 ,:ruc =>lcRuc,:guia => "",:formapago => "",
        :description => "",:comments =>"",:descrip =>"",:moneda =>"2" )
        new_invoice_item.save
        
    lcFecha='2017-05-30 00:00:00'
    lcTD="FT"
    lcSerie = "001"
    lcNumero= '472'
    lcRuc='20600373863'
    
     new_invoice_item= Invoicesunat.new(:cliente =>lcRuc, :fecha => lcFecha,:td =>lcTD,
        :serie => lcSerie,:numero => lcNumero,:preciocigv => 0.00 ,:preciosigv =>0.00,:cantidad =>0.00,
        :vventa => 0.00 ,:igv => 0.00,:importe => 0.00 ,:ruc =>lcRuc,:guia => "",:formapago => "",
        :description => "",:comments =>"",:descrip =>"",:moneda =>"2" )
        new_invoice_item.save

    lcFecha='2017-05-30 00:00:00'
    lcTD="FT"
    lcSerie = "001"
    lcNumero= '530'
    lcRuc='20506675457'
    
     new_invoice_item= Invoicesunat.new(:cliente =>lcRuc, :fecha => lcFecha,:td =>lcTD,
        :serie => lcSerie,:numero => lcNumero,:preciocigv => 0.00 ,:preciosigv =>0.00,:cantidad =>0.00,
        :vventa => 0.00 ,:igv => 0.00,:importe => 0.00 ,:ruc =>lcRuc,:guia => "",:formapago => "",
        :description => "",:comments =>"",:descrip =>"",:moneda =>"2" )
        new_invoice_item.save
        
    lcFecha='2017-05-30 00:00:00'
    lcTD="FT"
    lcSerie = "001"
    lcNumero= '531'
    lcRuc='20506675457'
    
     new_invoice_item= Invoicesunat.new(:cliente =>lcRuc, :fecha => lcFecha,:td =>lcTD,
        :serie => lcSerie,:numero => lcNumero,:preciocigv => 0.00 ,:preciosigv =>0.00,:cantidad =>0.00,
        :vventa => 0.00 ,:igv => 0.00,:importe => 0.00 ,:ruc =>lcRuc,:guia => "",:formapago => "",
        :description => "",:comments =>"",:descrip =>"",:moneda =>"2" )
        new_invoice_item.save
         
    
    @invoice = Invoicesunat.all
    send_data @invoice.to_csv  
    
  end
  
  def generar
        
    @company = Company.find(params[:company_id])
    @users = @company.get_users()
    @users_cats = []
    
    @pagetitle = "Generar archivo txt"
    
    @f =(params[:fecha1])

        parts = @f.split("-")
        yy = parts[0]
        mm = parts[1]
        dd = parts[2]

     @fechadoc=dd+"/"+mm+"/"+yy   
     @tipodocumento='01'
    
    files_to_clean =  Dir.glob("./app/txt_output/*.txt")
        files_to_clean.each do |file|
          File.delete(file)
        end 

    @facturas_all_txt = @company.get_facturas_year_month_day(@f)

    if @facturas_all_txt
      out_file = File.new("#{Dir.pwd}/app/txt_output/20424092941-RF-#{dd}#{mm}#{yy}-01.txt", "w")      
        for factura in @facturas_all_txt 
            parts = factura.code.split("-")
            @serie     =parts[0]
            @nrodocumento=parts[1]

            out_file.puts("7|#{@fechadoc}|#{@tipodocumento}|#{@serie}|#{@nrodocumento}||6|#{factura.customer.ruc}|#{factura.customer.name}|#{factura.subtotal}|0.00|0.00|0.00|#{factura.tax}|0.00|#{factura.total}||||\n")
                    
        end 
    out_file.close
    end 
    
    
  end

  def generar3
        
    @company = Company.find(params[:company_id])
    @users = @company.get_users()
    @users_cats = []
    
    @pagetitle = "Generar archivo"
    
    @f =(params[:fecha1])
    @f2 =(params[:fecha1])

        parts = @f.split("-")
        yy = parts[0]
        mm = parts[1]
        dd = parts[2]

     @fechadoc=dd+"/"+mm+"/"+yy   
     @tipodocumento='01'
    
    files_to_clean =  Dir.glob("./app/txt_output/*.txt")
        files_to_clean.each do |file|
          File.delete(file)
        end 

    @facturas_all_txt = @company.get_facturas_year_month_day2(@f,@f2)

    if @facturas_all_txt
        out_file = File.new("#{Dir.pwd}/app/txt_output/20424092941-RF-#{dd}#{mm}#{yy}-01.txt", "w")      
        for factura in @facturas_all_txt 
            parts = factura.code.split("-")
            @serie     =parts[0]
            @nrodocumento=parts[1]

            out_file.puts("7|#{@fechadoc}|#{@tipodocumento}|#{@serie}|#{@nrodocumento}||6|#{factura.customer.ruc}|#{factura.customer.name}|#{factura.subtotal}|0.00|0.00|0.00|#{factura.tax}|0.00|#{factura.total}||||\n")
                    
        end 
    out_file.close
    end 
    
    
  end
    

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    @invoice = Factura.find(params[:id])
    @customer = @invoice.customer
    @tipodocumento = @invoice.document 
    
   
    
    $lcruc = "20555691263" 
    
    $lcTipoDocumento = @invoice.document.descripshort
    parts1 = @invoice.code.split("-")
    $lcSerie  = parts1[0]
    $lcNumero = parts1[1]
    
    $lcIgv = @invoice.tax.to_s
    $lcTotal = @invoice.total.to_s 
    $lcFecha       = @invoice.fecha
    $lcFecha1      = $lcFecha.to_s

          parts = $lcFecha1.split("-")
          $aa = parts[0]
          $mm = parts[1]        
          $dd = parts[2]       

    
    $lcFecha0 = $aa << "-" << $mm <<"-"<< $dd 
    
    if @invoice.document_id == 1 
      $lcTipoDocCli =  "1"
    else
      $lcTipoDocCli =  "6"
    end 
      $lcNroDocCli  = @invoice.customer.ruc 

      
      
      $lcCodigoBarra = $lcruc << "|" << $lcTipoDocumento << "|" << $lcSerie << "|" << $lcNumero << "|" <<$lcIgv<< "|" << $lcTotal << "|" << $lcFecha0 << "|" << $lcTipoDocCli << "|" << $lcNroDocCli
      

  end

  # GET /invoices/new
  # GET /invoices/new.xml
  
  def new
    @pagetitle = "Nueva factura"
    @action_txt = "Create"
    $lcAction="Boleta"
    $Action= "create"
    
    @invoice = Factura.new
    
    @invoice[:code] = "#{generate_guid3()}"
    
    @invoice[:processed] = false
    
    
    
    
    @company = Company.find(params[:company_id])
    @invoice.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @payments = @company.get_payments()
    @services = @company.get_services()
    @products = @company.get_products()
    
    @deliveryships = @invoice.my_deliverys 
    @tipofacturas = @company.get_tipofacturas() 
    @monedas = @company.get_monedas()
    @tipodocumento = @company.get_documents()

    @ac_user = getUsername()
    @invoice[:user_id] = getUserId()
    @invoice[:moneda_id] = 2
    @invoice[:document_id] = 3
    
  end
  def new2
    @pagetitle = "Nueva factura"
    @action_txt = "Create"
    $lcAction="Factura"
    
    @invoice = Factura.new
    @invoice[:code] = "#{generate_guid3()}"
    @invoice[:processed] = false
    
    
    @company = Company.find(params[:company_id])
    @invoice.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @payments = @company.get_payments()
    @services = @company.get_services()
    @deliveryships = @invoice.my_deliverys 
    @tipofacturas = @company.get_tipofacturas() 
    @monedas = @company.get_monedas()
    @tipodocumento = @company.get_documents()
    @tipoventas = Tipoventum.all 
    @ac_user = getUsername()
    @invoice[:user_id] = getUserId()
  end
  
def newfactura2
    
    @company = Company.find(1)
    @factura = Factura.find(params[:factura_id])
    @customer = Customer.find(@factura.customer_id) 
    
    
    $lcContratoId = @customer.id
    $lcCode  = @customer.account
    $lcNameCode = @customer.name 
  
    $lcFacturaId= @factura.id 
    
  
    @detalleitems =  Sellvale.where(processed:"0",cod_cli: @customer.account)
    @factura_detail = Factura.new

  
  end 


  # GET /invoices/1/edit
  def edit
    @pagetitle = "Edit invoice"
    @action_txt = "Update"
    
    @invoice = Factura.find(params[:id])
    @company = @invoice.company
    @ac_customer = @invoice.customer.name
    @ac_user = @invoice.user.username
    @payments = @company.get_payments()    
    @services = @company.get_services()
    @deliveryships = @invoice.my_deliverys 
    @tipofacturas = @company.get_tipofacturas() 
    @products_lines = @invoice.products_lines
    @tipoventas = Tipoventum.all 
    @tipodocumento = @company.get_documents()
    @monedas = @company.get_monedas()
    @products = @company.get_products()
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    @pagetitle = "Nueva factura "
    @action_txt = "Create"
    
    items = params[:items].split(",")

    items2 = params[:items2].split(",")

    @invoice = Factura.new(factura_params)
    
    @company = Company.find(params[:factura][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @payments = @company.get_payments()    
    @services = @company.get_services()

    if @invoice[:document_id] == 2
      @invoice[:subtotal] = @invoice.get_subtotal(items) * -1
  
        begin
          @invoice[:tax] = @invoice.get_tax(items, @invoice[:customer_id]) * -1
        rescue
          @invoice[:tax] = 0
        end
        
        @invoice[:total] = @invoice[:subtotal] + @invoice[:tax]
        
        @invoice[:balance] = @invoice[:total]
      
    else
      
        @invoice[:subtotal] = @invoice.get_subtotal(items)
        
        begin
          @invoice[:tax] = @invoice.get_tax(items, @invoice[:customer_id])
        rescue
          @invoice[:tax] = 0
        end
        
        @invoice[:total] = @invoice[:subtotal] + @invoice[:tax]
        @invoice[:balance] = @invoice[:total]
        
        
     end
      

  
    
    @invoice[:pago] = 0
    @invoice[:charge] = 0
    
    
     parts = (@invoice[:code]).split("-")
     id = parts[0]
     numero2 = parts[1]
     
    if(params[:factura][:user_id] and params[:factura][:user_id] != "")
      curr_seller = User.find(params[:factura][:user_id])
      @ac_user = curr_seller.username
    end
    @invoice[:numero2] = numero2
  
    respond_to do |format|
      if @invoice.save
        # Create products for kit
        @invoice.add_products(items)
        @invoice.add_guias(items2)
        
        @invoice.correlativo
               # Check if we gotta process the invoice
        @invoice.process()

        
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully created.') }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    @pagetitle = "Edit invoice"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @invoice = Factura.find(params[:id])
    @company = @invoice.company
    @payments = @company.get_payments()    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @invoice.customer.name
    end
    
    @products_lines = @invoice.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @tipoventas = Tipoventum.all 
    
    @invoice[:subtotal] = @invoice.get_subtotal(items)
    @invoice[:tax] = @invoice.get_tax(items, @invoice[:customer_id])
    @invoice[:total] = @invoice[:subtotal] + @invoice[:tax]

    respond_to do |format|
      if @invoice.update_attributes(factura_params)
        # Create products for kit
        @invoice.delete_products()
        @invoice.add_products(items)
        @invoice.correlativo
        # Check if we gotta process the invoice
        @invoice.process()
        
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = Factura.find(params[:id])
    company_id = @invoice[:company_id]
    if @invoice.destroy
      @invoice.delete_guias()
    end   


    respond_to do |format|
      format.html { redirect_to("/companies/facturas/" + company_id.to_s) }
    end

  end
  
  def rpt_ccobrar3
  
    $lcxCliente ="1"
    @company=Company.find(1)      
    
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    @cliente = params[:customer_id]      
    lcmonedadolares ="1"
    lcmonedasoles ="2"
    @facturas_rpt = @company.get_pendientes_cliente(@fecha1,@fecha2,@cliente)    
    
    @total_cliente_dolares   = @company.get_pendientes_day_customer(@fecha1,@fecha2, @cliente, lcmonedadolares)
    @total_cliente_soles = @company.get_pendientes_day_customer(@fecha1,@fecha2, @cliente,lcmonedasoles)
    @total_cliente_detraccion = @company.get_pendientes_day_customer_detraccion(@fecha1,@fecha2, @cliente)
    
    
    case params[:print]
      when "To PDF" then 
          redirect_to :action => "rpt_ccobrar3_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2], :customer_id => params[:customer_id] 
          
      when "To Excel" then render xlsx: 'rpt_ccobrar3_xls'
        
      else render action: "index"
    end
  end
  
# reporte completo
  def build_pdf_header_rpt(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers_rpt.length, invoice_headers_rpt.length, 0].max
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

  def build_pdf_body_rpt(pdf)
    
    pdf.text "Facturas Moneda" +" Emitidas : desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 


    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Factura::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcDoc='FT'
      lcsubtotal =  0
      lctax = 0
      lctotal = 0

       for  product in @facturas_rpt

            row = []          
            row << product.document.descripshort
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")            
            
            row << product.customer.ruc  
            
            
            row << product.customer.name  
            
            if product.moneda_id == 1
              row << "USD"
            else
              row << "S/."
            end 
            if product.document_id == 2
              lcsubtotal = product.subtotal * -1
              lctax = product.tax * -1
              lctotal = product.total* -1
              row << lcsubtotal
              row << lctax
              row << lctotal 
            else
             
              
              row << product.subtotal.to_s
              row << product.tax.to_s
              row << product.total.to_s
            end 
            row << ""
            table_content << row

            nroitem=nroitem + 1
       
        end



      subtotals = []
      taxes = []
      totals = []
      services_subtotal = 0
      services_tax = 0
      services_total = 0

    if $lcFacturasall == '1'    
      subtotal = @company.get_facturas_day_value(@fecha1,@fecha2, "subtotal",@moneda)
      subtotals.push(subtotal)
      services_subtotal += subtotal          
      #pdf.text subtotal.to_s
    
    
      tax = @company.get_facturas_day_value(@fecha1,@fecha2, "tax",@moneda)
      taxes.push(tax)
      services_tax += tax
    
      #pdf.text tax.to_s
      
      total = @company.get_facturas_day_value(@fecha1,@fecha2, "total",@moneda)
      totals.push(total)
      services_total += total
      #pdf.text total.to_s

    else
        #total x cliente 
      subtotal = @company.get_facturas_day_value_cliente(@fecha1,@fecha2,@cliente, "subtotal",@moneda)
      subtotals.push(subtotal)
      services_subtotal += subtotal          
      #pdf.text subtotal.to_s
    
    
      tax = @company.get_facturas_day_value_cliente(@fecha1,@fecha2,@cliente, "tax",@moneda,)
      taxes.push(tax)
      services_tax += tax
    
      #pdf.text tax.to_s
      
      total = @company.get_facturas_day_value_cliente(@fecha1,@fecha2,@cliente,"total",@moneda,)
      totals.push(total)
      services_total += total
    
    end

      row =[]
      row << ""
      row << ""
      row << ""
      
      row << "TOTALES => "
      row << ""
      row << subtotal.round(2).to_s
      row << tax.round(2).to_s
      row << total.round(2).to_s
      row << ""
      table_content << row
      
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

    def build_pdf_footer_rpt(pdf)
      
                  
      pdf.text "" 
      pdf.bounding_box([0, 20], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end

##### reporte de pendientes de pago..

  def build_pdf_header_rpt2(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers_rpt.length, invoice_headers_rpt.length, 0].max
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

  def build_pdf_body_rpt2(pdf)
    
    pdf.text "Cuentas por cobrar  : desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
    pdf.text ""
    pdf.font "Helvetica" , :size => 7

      headers = []
      table_content = []

      Factura::TABLE_HEADERS3.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem = 1
      lcmonedasoles   = 2
      lcmonedadolares = 1
  
      lcDoc='FT'    
      lcCliente = @facturas_rpt.first.customer_id 
      @totalvencido_soles = 0
      @totalvencido_dolar = 0
      
       for  product in @facturas_rpt
       
        if product.document_id == 2
            balance_importe = product.balance.round(2) * -1
        else
            balance_importe = product.balance.round(2) 
        end 
         
       
         if balance_importe > 0.00
           
          if lcCliente == product.customer_id

            fechas2 = product.fecha2 

            row = []          
            if product.document 
              row << product.document.descripshort 
            else
              row <<  lcDoc 
            end 
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
            dias = (product.fecha2.to_date - product.fecha.to_date).to_i 
            
            row << dias 
            row << product.customer.name
            row << product.moneda.symbol  

            if product.moneda_id == 1 
                if product.document_id   == 2
                  row << "0.00 "
                  row << sprintf("%.2f",(product.balance*-1).to_s)
                    if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance*-1
                    end  
                else  
                  row << "0.00 "
                  row << sprintf("%.2f",product.balance.to_s)
                  if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance
                  end  
                end   
            else
                if product.document_id == 2
                  row << sprintf("%.2f",(product.balance*-1).to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance*-1
                  end  
                else                
                  row << sprintf("%.2f",product.balance.to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance
                  end  
                    
                end 
            end
            
            
            if product.detraccion == nil
              row <<  "0.00"
            else  
              row << sprintf("%.2f",product.detraccion.to_s)
            end
            row << product.get_vencido 
            
             
            
            table_content << row

            nroitem = nroitem + 1

          else
            totals = []            
            total_cliente_soles   = 0
            total_cliente_soles   = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedadolares)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedasoles)
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""  
            row << ""  
            row << "TOTALES POR CLIENTE=> "            
            row << ""
            row << sprintf("%.2f",total_cliente_dolares.to_s)
            row << sprintf("%.2f",total_cliente_soles.to_s)
            row << " "
            row << " "
            
            table_content << row

            lcCliente = product.customer_id


            row = []          
            row << lcDoc
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
              dias = (product.fecha2.to_date - product.fecha.to_date).to_i 
            
            row << dias 
            row << product.customer.name
            row << product.moneda.symbol  

            if product.moneda_id == 1 
                row << "0.00 "
                row << sprintf("%.2f",product.balance.to_s)
            else
                row << sprintf("%.2f",product.balance.to_s)
                row << "0.00 "
            end 
            row << sprintf("%.2f",product.detraccion.to_s)
            row << product.observ

            
            table_content << row

          end 
          
        end 
          
          
       
        end

            lcCliente = @facturas_rpt.last.customer_id 
            totals = []            
            total_cliente = 0

            total_cliente_soles   = 0
            total_cliente_soles   = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedadolares)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedasoles)
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""  
            row << ""          
            row << "TOTALES POR CLIENTE=> "            
            row << ""
            row << sprintf("%.2f",total_cliente_dolares.to_s)
            row << sprintf("%.2f",total_cliente_soles.to_s)                      
            row << " "
            row << " "
            table_content << row
              
          total_soles   = @company.get_pendientes_day_value(@fecha1,@fecha2, "total",lcmonedasoles)
          total_dolares = @company.get_pendientes_day_value(@fecha1,@fecha2, "total",lcmonedadolares)
      
           if $lcxCliente == "0" 

          row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          row << ""  
          row << "TOTALES => "
          row << ""
          row << sprintf("%.2f",total_soles.to_s)
          row << sprintf("%.2f",total_dolares.to_s)                    
          row << " "
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
                                          columns([5]).align=:left   
                                          columns([5]).width = 100 
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                          columns([10]).align=:right
                                        end                                          
                                        
      pdf.move_down 10    
      
      
      
      if $lcxCliente == "1" 
      
      totalxvencer_soles  = total_cliente_dolares   - @totalvencido_soles
      totalxvencer_dolar  = total_cliente_soles - @totalvencido_dolar
      
      pdf.table([  ["Resumen    "," Soles  ", "Dólares "],
              ["Total Vencido    ",sprintf("%.2f",@totalvencido_soles.to_s), sprintf("%.2f",@totalvencido_dolar.to_s)],
              ["Total por Vencer ",sprintf("%.2f",totalxvencer_soles.to_s),sprintf("%.2f",totalxvencer_dolar.to_s)],
              ["Totales          ",sprintf("%.2f",total_cliente_dolares.to_s),sprintf("%.2f",total_cliente_soles.to_s)]])
              
      end 
      #totales 
      
      pdf 

    end

    def build_pdf_footer_rpt2(pdf)      
                  
      pdf.text "" 
      pdf.bounding_box([0, 20], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

    end

    pdf
      
  end


  # Export serviceorder to PDF
  def rpt_facturas_all_pdf

    $lcFacturasall = '1'

    @company=Company.find(params[:company_id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_facturas_day(@fecha1,@fecha2,@moneda)      

#    respond_to do |format|
#      format.html    
#      format.xls # { send_data @products.to_csv(col_sep: "\t") }
#    end 

    Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt(pdf)
        pdf = build_pdf_body_rpt(pdf)
        build_pdf_footer_rpt(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura_all.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')

  end
# Export serviceorder to PDF
  def rpt_facturas_all2_pdf

    $lcFacturasall = '0'
    @company=Company.find(params[:company_id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @cliente = params[:customer_id]     
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_facturas_day_cliente(@fecha1,@fecha2,@cliente)  


    Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt(pdf)
        pdf = build_pdf_body_rpt(pdf)
        build_pdf_footer_rpt(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')
  end

  ###pendientes de pago 
  def rpt_ccobrar2_pdf
    $lcxCliente ="0"
    @company=Company.find(params[:company_id])      
    
      @fecha1 = params[:fecha1]  
      @fecha2 = params[:fecha2]

    @company.actualizar_fecha2
    @company.actualizar_detraccion 

    @facturas_rpt = @company.get_pendientes_day(@fecha1,@fecha2)  

      
    Prawn::Document.generate("app/pdf_output/rpt_pendientes.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt2(pdf)
        pdf = build_pdf_body_rpt2(pdf)
        build_pdf_footer_rpt2(pdf)

        $lcFileName =  "app/pdf_output/rpt_pendientes.pdf"              
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_pendientes.pdf", :type => 'application/pdf', :disposition => 'inline')
  

  end
  
  ###pendientes de pago 
  def rpt_ccobrar3_pdf

    $lcxCliente ="1"
    @company=Company.find(1)      
    @company.actualizar_fecha2
    @company.actualizar_detraccion 
    
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    @cliente = params[:customer_id]      
   
    @facturas_rpt = @company.get_pendientes_cliente(@fecha1,@fecha2,@cliente)  
    @dolares = 0
    @soles = 0 

    if @facturas_rpt.size > 0 

        Prawn::Document.generate("app/pdf_output/rpt_pendientes.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt2(pdf)
        pdf = build_pdf_body_rpt2(pdf)
        build_pdf_footer_rpt2(pdf)

        $lcFileName =  "app/pdf_output/rpt_pendientes.pdf"              
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_pendientes.pdf", :type => 'application/pdf', :disposition => 'inline')

    end 

  end
  
  ###pendientes de pago detalle

  def rpt_ccobrar4_pdf
      $lcxCliente ="0"
      @company=Company.find(params[:company_id])          
      @fecha1 = params[:fecha1]  
      @fecha2 = params[:fecha2]  
      @facturas_rpt = @company.get_pendientes_day(@fecha1,@fecha2)  
      
      Prawn::Document.generate("app/pdf_output/rpt_pendientes4.pdf") do |pdf|
          pdf.font "Helvetica"
          pdf = build_pdf_header_rpt4(pdf)
          pdf = build_pdf_body_rpt4(pdf)
          build_pdf_footer_rpt4(pdf)
          $lcFileName =  "app/pdf_output/rpt_pendientes4.pdf"              
      end     
      $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
      send_file("app/pdf_output/rpt_pendientes4.pdf", :type => 'application/pdf', :disposition => 'inline')
  
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
 def discontinue
    
    @facturasselect = Sellvale.find(params[:products_ids])

    for item in @facturasselect
        begin
          a = item.id
          b = Product.find_by(code: item.cod_prod)             
          descuento =  item.implista - item.importe.to_f
          preciolista = item.precio.to_f + descuento
          
          new_invoice_detail = FacturaDetail.new(factura_id: $lcFacturaId  ,sellvale_id: item.id , product_id: b.id ,price:preciolista, price_discount: item.precio, quantity: item.cantidad,total: item.importe)
          new_invoice_detail.save
          a= Sellvale.find(item.id)
          a.processed ='1'
          a.save
          
        end              
    end
    
    @invoice = Factura.find($lcFacturaId)
    
    @invoice[:total] = @invoice.get_subtotal2.round(2)
    
    lcTotal = @invoice[:total]  / 1.18
    @invoice[:subtotal] = lcTotal.round(2)
    
    lcTax =@invoice[:total] - @invoice[:subtotal]
    @invoice[:tax] = lcTax.round(2)
    
    @invoice[:balance] = @invoice[:total]
    @invoice[:pago] = 0
    @invoice[:charge] = 0
    @invoice[:descuento] = "1"
    
    respond_to do |format|
      if @invoice.save
        # Create products for kit
        
                # Check if we gotta process the invoice
        
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully created.') }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
    
    
    
     
  end   

def print
          lib = File.expand_path('../../../lib', __FILE__)
        $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
        puts "ruta******"
        puts lib 
        
        
        
        require 'sunat'
        require './config/config'
        require './app/generators/invoice_generator'
        require './app/generators/credit_note_generator'
        require './app/generators/debit_note_generator'
        require './app/generators/receipt_generator'
        require './app/generators/daily_receipt_summary_generator'
        require './app/generators/voided_documents_generator'

        SUNAT.environment = :test 

        files_to_clean = Dir.glob("*.xml") + Dir.glob("./app/pdf_output/*.pdf") + Dir.glob("*.zip")
        files_to_clean.each do |file|
          File.delete(file)
        end         
    
       if $lcMoneda == "D"  
            $lcFileName=""
            case_49 = InvoiceGenerator.new(1,3,1,$lg_serie_factura).with_different_currency2
          #  puts $lcFileName 
       else
            case_3  = InvoiceGenerator.new(1,3,1,$lg_serie_factura).with_igv2(true)
       end 
    
        
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
        send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')

        
        @@document_serial_id =""
        $aviso=""
    end 
def reportep01 
    
      @company=Company.find(1)          
      @fecha1 = params[:fecha1]    
      @fecha2 = params[:fecha2]    
      @proveedor = params[:supplier]    
      
      @facturas_rpt = @company.get_purchases_5(@fecha1,@fecha2,@proveedor)
      
      case params[:print]
        when "To PDF" then 
          begin 
           render  pdf: "FacturaProveedor ",template: "purchases/purchase5_rpt.pdf.erb",locals: {:purchases => @facturas_rpt}
          
          end   
        when "To Excel" then render xlsx: 'purchase5_xls'
        else render action: "index"
      end
      
  end
  
  
def rpt_cobranzas_pdf
    
    @company=Company.find(1)      
   
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    
    @tipomoneda = params[:moneda_id]

    @company.actualizar_fecha2
    @company.actualiza_monthyear
    
    @customerpayment_rpt = @company.get_customer_payments2(@tipomoneda,@fecha1,@fecha2)
  
    if @customerpayment_rpt != nil 
    
      case params[:print]
        when "To PDF" then 
            redirect_to :action => "rpt_ccobrar5_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2], :moneda_id=> params[:moneda_id],:id=>"1"
        when "To Excel" then render xlsx: 'rpt_ccobrar5_xls'
          
          
        else render action: "index"
      end
    end 
  end



def rpt_ccobrar5_pdf
    @company=Company.find(params[:id])      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @tipomoneda = params[:moneda_id]

    @company.actualizar_fecha2
    @company.actualiza_monthyear
    @customerpayment_rpt = @company.get_customer_payments2(@tipomoneda,@fecha1,@fecha2)
  
    if @customerpayment_rpt != nil 
      
    Prawn::Document.generate "app/pdf_output/rpt_customerpayment2.pdf" , :page_layout => :landscape do |pdf|        
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt20(pdf)
        pdf = build_pdf_body_rpt20(pdf)
        build_pdf_footer_rpt20(pdf)
        $lcFileName =  "app/pdf_output/rpt_customerpayment2.pdf"      
    end     
  
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  end 
end 

##-------------------------------------------------------------------------------------
## REPORTE DE ESTADISTICA DE VENTAS
##-------------------------------------------------------------------------------------
  
  def build_pdf_header_rpt20(pdf)
     pdf.font "Helvetica" , :size => 6
      
     $lcCli  = @company.name 
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

  def build_pdf_body_rpt20(pdf)
    
    if @tipomoneda == "1"
       @tipomoneda_name ="DOLARES"  
    else
       @tipomoneda_name ="SOLES "  
    end 
    pdf.text "Resumen Clientes  Moneda : "+@tipomoneda_name  + " Fecha "+@fecha1.to_s+ " Mes : "+@fecha2.to_s , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []
      total_general = 0
      total_factory = 0

      CustomerPayment::TABLE_HEADERS9.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end
      table_content << headers
      nroitem = 1

      # tabla pivoteadas
      # hash of hashes
        # pad columns with spaces and bars from max_lengths

      @total_general = 0
      @total_anterior = 0
      @total_cliente = 0 
      @total_mes01 = 0
      @total_mes02 = 0
      @total_mes03 = 0
      @total_mes04 = 0
      @total_mes05 = 0
      @total_mes06 = 0
      @total_mes07 = 0
      @total_mes08 = 0
      @total_mes09 = 0
      @total_mes10 = 0
      @total_mes11 = 0
      @total_mes12 = 0
      @total_anterior_column = 0
      @total_mes01_column = 0
      @total_mes02_column = 0
      @total_mes03_column = 0
      @total_mes04_column = 0
      @total_mes05_column = 0
      @total_mes06_column = 0
      @total_mes07_column = 0
      @total_mes08_column = 0
      @total_mes09_column = 0
      @total_mes10_column = 0
      @total_mes11_column = 0
      @total_mes12_column = 0
      
      lcCli = @customerpayment_rpt.first.customer_id
      $lcCliName = ""
    

     for  customerpayment_rpt in @customerpayment_rpt

        if lcCli == customerpayment_rpt.customer_id 

          $lcCliName = customerpayment_rpt.customer.name  
          
          if customerpayment_rpt.balance.round(2) > 0.00
      
          if customerpayment_rpt.year_month.to_f <= 201712
            @total_anterior = @total_anterior + customerpayment_rpt.balance
          end             
          
          if customerpayment_rpt.year_month.to_f >= 201801 and customerpayment_rpt.year_month.to_f <= 201806
            @total_mes01 = @total_mes01 + customerpayment_rpt.balance
          end   

          if customerpayment_rpt.year_month == '201807'
            @total_mes02 = @total_mes02 + customerpayment_rpt.balance
          end 
            
          if customerpayment_rpt.year_month == '201808'   
            @total_mes03 = @total_mes03 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201809'     
            @total_mes04 = @total_mes04 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201810'       
            @total_mes05 = @total_mes05 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201811'
            @total_mes06 = @total_mes06 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201812' 
            @total_mes07 = @total_mes07 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201901'   
            @total_mes08 = @total_mes08 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201902'     
            @total_mes09 = @total_mes09 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201903'       
            @total_mes10 = @total_mes10 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201904'   
            @total_mes11 = @total_mes11 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201905'     
            @total_mes12 = @total_mes12 + customerpayment_rpt.balance
          end   
            @total_general = @total_general + customerpayment_rpt.balance
            
        end 
          
        else
          
            @total_cliente = @total_anterior+
            @total_mes01+
            @total_mes02+
            @total_mes03+
            @total_mes04+
            @total_mes05+
            @total_mes06+
            @total_mes07+
            @total_mes08+
            @total_mes09+
            @total_mes10+
            @total_mes11+
            @total_mes12
            
            row = []
            row << nroitem.to_s        
            row << $lcCliName
            row << sprintf("%.2f",@total_anterior.to_s)
            row << sprintf("%.2f",@total_mes01.to_s)
            row << sprintf("%.2f",@total_mes02.to_s)
            row << sprintf("%.2f",@total_mes03.to_s)
            row << sprintf("%.2f",@total_mes04.to_s)
            row << sprintf("%.2f",@total_mes05.to_s)
            row << sprintf("%.2f",@total_mes06.to_s)
            row << sprintf("%.2f",@total_mes07.to_s)
            row << sprintf("%.2f",@total_mes08.to_s)
            row << sprintf("%.2f",@total_mes09.to_s)
            row << sprintf("%.2f",@total_mes10.to_s)
            row << sprintf("%.2f",@total_mes11.to_s)
            row << sprintf("%.2f",@total_mes12.to_s)
            row << sprintf("%.2f",@total_cliente.to_s)

            table_content << row            
            ## TOTAL XMES GENERAL
            @total_anterior_column = @total_anterior_column + @total_anterior
            @total_mes01_column = @total_mes01_column +@total_mes01
            @total_mes02_column = @total_mes02_column +@total_mes02
            @total_mes03_column = @total_mes03_column +@total_mes03
            @total_mes04_column = @total_mes04_column +@total_mes04
            @total_mes05_column = @total_mes05_column +@total_mes05
            @total_mes06_column = @total_mes06_column +@total_mes06
            @total_mes07_column = @total_mes07_column +@total_mes07
            @total_mes08_column = @total_mes08_column +@total_mes08
            @total_mes09_column = @total_mes09_column +@total_mes09
            @total_mes10_column = @total_mes10_column +@total_mes10
            @total_mes11_column = @total_mes11_column +@total_mes11
            @total_mes12_column = @total_mes12_column +@total_mes12
            @total_cliente = 0 
            ## TOTAL XMES GENERAL

            $lcCliName =customerpayment_rpt.customer.name
            lcCli = customerpayment_rpt.customer_id

            @total_anterior = 0
            @total_mes01 = 0
            @total_mes02 = 0
            @total_mes03 = 0
            @total_mes04 = 0
            @total_mes05 = 0
            @total_mes06 = 0
            @total_mes07 = 0
            @total_mes08 = 0
            @total_mes09 = 0
            @total_mes10 = 0
            @total_mes11 = 0
            @total_mes12 = 0
            @total_cliente = 0 
            
          if customerpayment_rpt.balance.round(2) > 0.00
          
          if customerpayment_rpt.year_month.to_f <= 201712
            @total_anterior = @total_anterior + customerpayment_rpt.balance
          end             
          
          if customerpayment_rpt.year_month.to_f >= 201801 and customerpayment_rpt.year_month.to_f <= 201806
            @total_mes01 = @total_mes01 + customerpayment_rpt.balance
          end   

          if customerpayment_rpt.year_month == '201807'
            @total_mes02 = @total_mes02 + customerpayment_rpt.balance
          end 
            
          if customerpayment_rpt.year_month == '201808'   
            @total_mes03 = @total_mes03 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201809'     
            @total_mes04 = @total_mes04 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201810'       
            @total_mes05 = @total_mes05 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201811'
            @total_mes06 = @total_mes06 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201812' 
            @total_mes07 = @total_mes07 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201901'   
            @total_mes08 = @total_mes08 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201902'     
            @total_mes09 = @total_mes09 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201903'       
            @total_mes10 = @total_mes10 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201904'   
            @total_mes11 = @total_mes11 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '201905'     
            @total_mes12 = @total_mes12 + customerpayment_rpt.balance
          end   
          
          nroitem = nroitem + 1 
      
          @total_general = @total_general + customerpayment_rpt.balance
        end 
       end 
       end   
       

      #fin for
          #ultimo cliente 

          @total_cliente = @total_anterior+
          @total_mes01+
          @total_mes02+
          @total_mes03+
          @total_mes04+
          @total_mes05+
          @total_mes06+
          @total_mes07+
          @total_mes08+
          @total_mes09+
          @total_mes10+
          @total_mes11+
          @total_mes12
            @total_anterior_column = @total_anterior_column + @total_anterior
            @total_mes01_column = @total_mes01_column +@total_mes01
            @total_mes02_column = @total_mes02_column +@total_mes02
            @total_mes03_column = @total_mes03_column +@total_mes03
            @total_mes04_column = @total_mes04_column +@total_mes04
            @total_mes05_column = @total_mes05_column +@total_mes05
            @total_mes06_column = @total_mes06_column +@total_mes06
            @total_mes07_column = @total_mes07_column +@total_mes07
            @total_mes08_column = @total_mes08_column +@total_mes08
            @total_mes09_column = @total_mes09_column +@total_mes09
            @total_mes10_column = @total_mes10_column +@total_mes10
            @total_mes11_column = @total_mes11_column +@total_mes11
            @total_mes12_column = @total_mes12_column +@total_mes12
          
            row = []
            row << nroitem.to_s        
            row << customerpayment_rpt.customer.name  
            row << sprintf("%.2f",@total_anterior.to_s)
            row << sprintf("%.2f",@total_mes01.to_s)
            row << sprintf("%.2f",@total_mes02.to_s)
            row << sprintf("%.2f",@total_mes03.to_s)
            row << sprintf("%.2f",@total_mes04.to_s)
            row << sprintf("%.2f",@total_mes05.to_s)
            row << sprintf("%.2f",@total_mes06.to_s)
            row << sprintf("%.2f",@total_mes07.to_s)
            row << sprintf("%.2f",@total_mes08.to_s)
            row << sprintf("%.2f",@total_mes09.to_s)
            row << sprintf("%.2f",@total_mes10.to_s)
            row << sprintf("%.2f",@total_mes11.to_s)
            row << sprintf("%.2f",@total_mes12.to_s)
            row << sprintf("%.2f",@total_cliente.to_s)

            table_content << row            
            


        row = []
         row << ""       
         row << " TOTAL GENERAL => "
         row << sprintf("%.2f",@total_anterior_column.to_s)
         row << sprintf("%.2f",@total_mes01_column.to_s)
         row << sprintf("%.2f",@total_mes02_column.to_s)
         row << sprintf("%.2f",@total_mes03_column.to_s)
         row << sprintf("%.2f",@total_mes04_column.to_s)
         row << sprintf("%.2f",@total_mes05_column.to_s)
         row << sprintf("%.2f",@total_mes06_column.to_s)
         row << sprintf("%.2f",@total_mes07_column.to_s)
         row << sprintf("%.2f",@total_mes08_column.to_s)
         row << sprintf("%.2f",@total_mes09_column.to_s)
         row << sprintf("%.2f",@total_mes10_column.to_s)
         row << sprintf("%.2f",@total_mes11_column.to_s)
         row << sprintf("%.2f",@total_mes12_column.to_s)
         row << sprintf("%.2f",@total_general.to_s)
         
         table_content << row


      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:right
                                          columns([3]).align=:right 
                                          columns([4]).align=:right
                                          columns([5]).align=:right 
                                          columns([6]).align=:right
                                          columns([7]).align=:right 
                                          columns([8]).align=:right
                                          columns([9]).align=:right 
                                          columns([10]).align=:right
                                          columns([11]).align=:right 
                                          columns([12]).align=:right
                                          columns([13]).align=:right 
                                          columns([14]).align=:right 
                                          columns([15]).align=:right
                                          
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer_rpt20(pdf)

        subtotals = []
        taxes = []
        totals = []
        services_subtotal = 0
        services_tax = 0
        services_total = 0

        
        
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
           pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]
        end

      pdf
      
  end

def client_data_headers

    #{@customerpayment.description}
      client_headers  = [["Proveedor :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]      
      client_headers
  end

  def invoice_headers            
      invoice_headers  = [["Fecha Compro. : ",$lcFecha1]]
      invoice_headers <<  ["Tipo de moneda : ", $lcMon]    
      invoice_headers
  end

  def invoice_summary
      invoice_summary = []
      invoice_summary << ["RECIBI CONFORME ",""]
      invoice_summary << ["Fecha  :",""]
      invoice_summary << ["D.N.I. :","Firma"]
      invoice_summary << ["Nombre y Apellidos :",""]
      invoice_summary
  end



  
  private
  def factura_params
    params.require(:factura).permit(:company_id,:location_id,:division_id,:customer_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:payment_id,:fecha,:preciocigv,:tipo,:observ,:moneda_id,:detraccion,:factura2,:description,:document_id,:tipoventa_id)
  end

end


