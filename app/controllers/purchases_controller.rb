
include UsersHelper 
include SuppliersHelper
include ProductsHelper
include PurchasesHelper



class PurchasesController < ApplicationController
$: << Dir.pwd  + '/lib'
    before_action :authenticate_user!
    
    require "open-uri"

 

  def show
    @purchase = Purchase.find(params[:id])
    @supplier = @purchase.supplier
     @cierre = Cierre.last 
    parts0 = @cierre.fecha.strftime("%Y-%m-%d") 
    parts = parts0.split("-")
    
    $yy = parts[0].to_i
    $mm = parts[1].to_i
    $dd = parts[2].to_i 
  end

  def import
      Purchase.import(params[:file])
       redirect_to root_url, notice: "Facturas  importadas."
  end 


  def ingresos
        @company = Company.find(params[:id])
        @purchases  = PurchaseDetail.all.paginate(:page => params[:page])
  end 
  
  def list_ingresos
        @company = Company.find(1)

        @purchases  = Purchase.find_by_sql(['Select purchases.* from purchase_details   
INNER JOIN purchases ON purchase_details.purchase_id = purchases.id
WHERE purchase_details.product_id = ? ',params[:id] ])
        

  end 
  
  def generar1
    
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

## Reporte de factura detallado

 def build_pdf_header9(pdf)
    pdf.font "Helvetica" , :size => 6    
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.zone.now.to_s

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

  def build_pdf_body9(build_pdf_body10)
    
    pdf.text "Facturas  de compra Emitidas : Fecha "+@fecha1.to_s+ " Mes : "+@fecha2.to_s , :size => 11 
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

      for ordencompra in @rpt_detalle_purchase

           $lcNumero    = ordencompra.documento     
           $lcFecha     = ordencompra.date1
           $lcProveedor = ordencompra.supplier.name 
           
           $lcBalance    = ordencompra.balance.round(2).to_s 

        @orden_compra1  = @company.get_purchase_detalle(ordencompra.id)


       for  orden in @orden_compra1
            row = []
            row << nroitem.to_s
            row << $lcProveedor 
            row << $lcNumero 
            row << $lcFecha.strftime("%d/%m/%Y")        
            row << orden.quantity.to_s

            if orden.product 
              row << orden.product.code
              row << orden.product.name
            else
              a = orden.get_service(orden.product_id)
              row << a.code 
              row << a.name 
            end 

            if orden.price_without_tax != nil
            row << orden.price_without_tax.round(4).to_s
            else 
            row << "0.00"
            end  
            row << " "
            row << orden.total.round(2).to_s
            row << $lcPercepcion
            row << $lcBalance
            table_content << row
        
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
                                          columns([10]).align=:right
                                          columns([11]).align=:right
                                        end

      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer9(pdf)

        pdf.text ""
        pdf.text "" 
        
     end
    
  # Export purchaseorder to PDF
  def rpt_purchase2_all

    @company =Company.find(1)
    @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]
    @tiporeporte =params[:tiporeporte]

    @rpt_detalle_purchase = @company.get_purchases_day_tipo(@fecha1,@fecha2,@tiporeporte)

    Prawn::Document.generate("app/pdf_output/orden_1.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header9(pdf)
        pdf = build_pdf_body9(pdf)
        build_pdf_footer9(pdf)
        $lcFileName =  "app/pdf_output/orden_1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end

## end reporte de factura detallado


### RESUMEN FACTURAS X CATEGORIA.


  def build_pdf_body10(pdf)
    
    pdf.text "Resumen por Categoria", :size => 11 
    pdf.text "Documentos de compra Desde :"+@fecha1.to_s+ " Hasta : "+@fecha2.to_s , :size => 10 
    pdf.text "Moneda " + $lcMoneda , :size => 10 
    pdf.text "*Solo documentos procesados *",:size => 6 
    pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6
  

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS7.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      total = 0
      for compras in @rpt_detalle_purchase

            row = []
            row << nroitem.to_s
            if @tipo =='0'
              row << compras.products_category_id
              row << compras.get_categoria_name(compras.products_category_id)
            else
              row << "SERVICIOS"
              row << compras.get_servicebuy_name(compras.code)
            end 
            calculo = 0
            if @tipo =='0'
              if compras.products_category_id == 2
                calculo = compras.total / 1.18
                row   << calculo.round(2).to_s
                total += calculo.round(2)
                
              else
                row << compras.total.round(2).to_s
                total += compras.total.round(2)
              end 
            else
                row << compras.total.round(2).to_s
                total += compras.total.round(2)
              
            end 
            
            table_content << row
            nroitem=nroitem + 1
      end
            row = []
            row << ""
            row << "" 
            row << "TOTAL : "
            row << total.round(2) 
            table_content << row
      


      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width/2
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:center
                                          columns([3]).align=:center
                                          columns([4]).align=:left
                                          columns([5]).align=:left
                                          
                                        end

      pdf.move_down 10      
         
        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        
        pdf.text "_________________               _____________________         ____________________      ", :size => 13, :spacing => 4
        pdf.text ""
        pdf.text "                  Realizado por                                         V.B.Jefe Compras                                      V.B.Gerencia           ", :size => 10, :spacing => 4
        pdf 
       end 
      
      pdf

    end


    def build_pdf_footer10(pdf)
      
        pdf.text " " 
        pdf.text " "
        
     end
    
  # Export purchaseorder to PDF
  def rpt_purchase3_all
        
    @company =Company.find(1)
    @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]
    @moneda1 = params[:moneda]


    if @moneda1== "2"
      $lcMoneda ="SOLES"
    else
      $lcMoneda ="DOLARES"
    end 
    
    @tipo =params[:tiporeporte]
    puts "monedaaaaaaaaaaaaaaa"
    puts @moneda1 


    @rpt_detalle_purchase = @company.get_purchases_day_categoria(@fecha1,@fecha2,@moneda1,@tipo)
    Prawn::Document.generate("app/pdf_output/orden_1.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header9(pdf)
        pdf = build_pdf_body10(pdf)
        build_pdf_footer10(pdf)
        $lcFileName =  "app/pdf_output/orden_1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end

## end reporte de factura detallado
## FIN RESUMEN FACTURAS X CATEGORIA


### DETALLE FACTURAS X CATEGORIA. 


  def build_pdf_body11(pdf)
    
    pdf.text "Detalle por Categoria", :size => 11 
    pdf.text "Documentos de compra Desde :"+@fecha1.to_s+ " Hasta : "+@fecha2.to_s , :size => 10 
    pdf.text "Moneda " + $lcMoneda , :size => 10 
    pdf.text "*Solo documentos procesados *",:size => 6 
    pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6
  

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS8.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      total = 0
      for compras in @rpt_detalle_purchase

            row = []
            row << nroitem.to_s
            
            row << compras.get_categoria_name(compras.products_category_id)
            
            row << compras.supplier.name 
            row << compras.date1.strftime("%d/%m/%Y")
            row << compras.document.descripshort 
            row << compras.documento
            
            
            if compras.product 
              row << compras.product.name
            else
              a = compras.get_service(compras.product_id)
              
              row << a.name 
            end 
            
           
            row << compras.quantity.round(2)
            calculo = 0
            calculototal = 0 
            if compras.products_category_id == 2
              
              calculo = compras.price_without_tax / 1.18
              calculototal = compras.total / 1.18
              
              row << calculo.round(2)
              row << calculototal.round(2).to_s
              total += calculototal.round(2)
              
            else  
              row << compras.price_without_tax.round(2)
              row << compras.total.round(2).to_s
              
              total += compras.total.round(2)
            end 
            table_content << row
            nroitem=nroitem + 1
      end
            row = []
            row << ""
            row << ""
            row << ""
            row << "" 
            row << "" 
            row << ""
            row << " "
            row << "TOTAL : "
            row << " "
            row << total.round(2) 
            
            table_content << row
      
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([2]).width= 120    
                                          columns([3]).align=:center
                                          columns([4]).align=:left
                                          columns([5]).align=:left
                                          columns([6]).align=:left
                                          columns([7]).align=:left 
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                          columns([10]).align=:right 
                                        end

      pdf.move_down 10      
        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        
        pdf.text "_________________               _____________________         ____________________      ", :size => 13, :spacing => 4
        pdf.text ""
        pdf.text "                  Realizado por                                         V.B.Jefe Compras                                      V.B.Gerencia           ", :size => 10, :spacing => 4
        pdf 
       end 
      
      pdf

    end


    def build_pdf_footer11(pdf)

        pdf.text ""
        pdf.text "" 
        
        
    
    end 

  # Export purchaseorder to PDF
  
  def rpt_purchase4_all
        
    @company =Company.find(1)
    @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]
    @moneda1 = params[:moneda]
    
    if @moneda1== "2"
      $lcMoneda ="SOLES"
    else
      $lcMoneda ="DOLARES"
    end 
    
    
    @tipo =params[:tiporeporte]

    @rpt_detalle_purchase = @company.get_purchases_day_categoria2(@fecha1,@fecha2,@moneda1,@tipo)
    Prawn::Document.generate("app/pdf_output/orden_1.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header9(pdf)
        pdf = build_pdf_body11(pdf)
        build_pdf_footer11(pdf)
        $lcFileName =  "app/pdf_output/orden_1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end

## end reporte de factura detallado
## FIN RESUMEN FACTURAS X CATEGORIA



##### reporte de factura emitidas

  def build_pdf_header_rpt8(pdf)
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

  def build_pdf_body_rpt8(pdf)
    
    pdf.text "Facturas de compra : desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS3.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcmonedasoles   = 2
      lcmonedadolares = 1
      @total1=0
      @total2=0

      lcDoc='FT'      

       lcCliente = @facturas_rpt.first.supplier_id

       for  product in @facturas_rpt
        
          if lcCliente == product.supplier_id

             
            fechas2 = product.date2 
             
            row = []          
            row << lcDoc
            row << product.documento 
            row << product.date1.strftime("%d/%m/%Y")
            row << product.date2.strftime("%d/%m/%Y")
            row << product.supplier.name
            row << product.moneda.symbol  
            row << ""


            if product.moneda_id == 1 
                row << "0.00 "
                row << sprintf("%.2f",product.total_amount.to_s)
            else
                row << sprintf("%.2f",product.total_amount.to_s)
                row << "0.00 "
            end 
            row << " "
            
            table_content << row

            nroitem = nroitem + 1

          else
            totals = []            
            total_cliente_soles = 0
            total_cliente_soles   = @company.get_purchases_by_day_value_supplier2(@fecha1,@fecha2,lcmonedasoles,"total_amount",lcCliente,@tiporeporte)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_purchases_by_day_value_supplier2(@fecha1,@fecha2, lcmonedadolares,"total_amount",lcCliente,@tiporeporte)
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""          
            row << "TOTALES POR PROVEEDOR=> "            
            row << ""
            row << ""
            row << sprintf("%.2f",total_cliente_soles.to_s)
            row << sprintf("%.2f",total_cliente_dolares.to_s)
            row << " "
            
            table_content << row
            @total1 +=total_cliente_soles
            @total2 +=total_cliente_dolares
            lcCliente = product.supplier_id

            row = []          
            row << lcDoc
            row << product.documento 
            row << product.date1.strftime("%d/%m/%Y")
            row << product.date2.strftime("%d/%m/%Y")
            if product.supplier != nil 
            row << product.supplier.name
            else
            row << " "
            end 
            row << product.moneda.symbol  
            row << " "
            

            if product.moneda_id == 1
                row << "0.00 "
                row << sprintf("%.2f",product.total_amount.to_s)
            else
                row << sprintf("%.2f",product.total_amount.to_s)
                row << "0.00 "
            end 
            row << " "          
            table_content << row
          end                   
        end

        lcProveedor = @facturas_rpt.last.supplier_id 

            totals = []            
            total_cliente = 0
  
            total_cliente_soles = 0
            total_cliente_soles =  @company.get_purchases_by_day_value_supplier2(@fecha1,@fecha2,lcmonedasoles,"total_amount",lcCliente,@tiporeporte)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_purchases_by_day_value_supplier2(@fecha1,@fecha2,lcmonedadolares,"total_amount",lcCliente,@tiporeporte)
    
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""          
            row << "TOTALES POR PROVEEDOR => "            
            row << ""
            row << ""
            row << sprintf("%.2f",total_cliente_soles.to_s)
            row << sprintf("%.2f",total_cliente_dolares.to_s)                      
            row << " "
            
            @total1 +=total_cliente_soles
            @total2 +=total_cliente_dolares 
            
            table_content << row
              
          total_soles   = @company.get_purchases_by_day_value2(@fecha1,@fecha2, lcmonedasoles,"total_amount","2")
          total_dolares = @company.get_purchases_by_day_value2(@fecha1,@fecha2, lcmonedadolares,"total_amount","1")
      
           if $lcxCliente == "0" 

          row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          row << "TOTALES => "
          row << ""
          row << ""
          row << sprintf("%.2f",total_soles.to_s)
          row << sprintf("%.2f",total_dolares.to_s)                    
          row << " "
          table_content << row
          else
            row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          row << "TOTALES => "
          row << ""
          row << ""
          row << sprintf("%.2f",@total1.to_s)
          row << sprintf("%.2f",@total2.to_s)                    
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
                                          columns([9]).align=:right
                                        end                                          
                                        
      pdf.move_down 10      

      #totales 

      pdf 

    end

    def build_pdf_footer_rpt8(pdf)      
                  
      pdf.text "" 
      pdf.bounding_box([0, 20], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]
    end
    pdf      
  end


  # Export serviceorder to PDF
  def rpt_purchase_all

    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @tiporeporte =params[:tiporeporte]
    
    @facturas_rpt = @company.get_purchases_day_tipo(@fecha1,@fecha2,@tiporeporte)

        Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
            pdf.font "Helvetica"
            pdf = build_pdf_header_rpt8(pdf)
            pdf = build_pdf_body_rpt8(pdf)
            build_pdf_footer_rpt8(pdf)
            $lcFileName =  "app/pdf_output/rpt_factura_all.pdf"              
        end     
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
        send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')    
 
  end

 
# reporte de ingresos x producto x familia 

# reporte completo
  def build_pdf_header_rpt7(pdf)
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

  def build_pdf_body_rpt7(pdf)
    
    pdf.text "Listado de Ordenes pendientes desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 11

    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

      @totales = 0
      @cantidad = 0
      nroitem = 1

       for  ordencompra  in @facturas_rpt 

         $lcNumero = ordencompra.code    
         $lcFecha  = ordencompra.fecha1

         if ordencompra.supplier != nil
            $lcProveedor = ordencompra.supplier.name 
         end

         @orden_compra1  = Purchase.where(:purchaseorder_id => ordencompra.id)

         if @orden_compra1.count()>0 

         else
           @orden_compra2  = PurchaseorderDetail.where(:purchaseorder_id=>ordencompra.id)

            for  orden in @orden_compra2
            row = []  
            row << nroitem.to_s
            row << $lcProveedor 
            row << $lcNumero 
            row << $lcFecha.strftime("%d/%m/%Y")        
            row << orden.quantity.to_s
            row << orden.product.code
            row << orden.product.name
            row << orden.price.round(2).to_s
            row << orden.total.round(2).to_s
            table_content << row
            
            nroitem=nroitem + 1
         end
         end 
                
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
                                          columns([5]).align=:center  
                                          columns([6]).align=:left 
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                        end                                          
      pdf.move_down 10      
      #totales 
      pdf 

    end

    def build_pdf_footer_rpt7(pdf)
            data =[ ["Procesado por Almacen ","V.B.Almacen","V.B.Compras ","V.B. Gerente ."],
               [":",":",":",":"],
               [":",":",":",":"],
               ["Fecha:","Fecha:","Fecha:","Fecha:"] ]

           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1} , :width => pdf.bounds.width)
            pdf.move_down 10          

                        
      pdf.text "" 
      pdf.bounding_box([0, 30], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end

  def rpt_ingresos3_all_pdf
  
    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    
    @facturas_rpt = @company.get_ingresos_day3(@fecha1,@fecha2)

    Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt7(pdf)
        pdf = build_pdf_body_rpt7(pdf)
        build_pdf_footer_rpt7(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')
  end

#fin reporte de ingresos x producto 

#-----------------------------------------

# reporte de ingresos x producto x familia 

# reporte completo
def build_pdf_header_rpt48(pdf)
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


  def build_pdf_body_rpt48(pdf)
    
    pdf.text "Listado de Ingresos desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 11
   
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

      @totales1 = 0
      @totales2 = 0
      @totaldolares = 0
      @totaldolares2 = 0
      @cantidad = 0
      @cantidad2 = 0
      
      total_qty = 0
      total_soles = 0
      total_dolares = 0
      nroitem = 1
      @tipocambio = 1
      valorcambio = 0
      valortotal = 0
      lcCategoria = @facturas_rpt.first.products_category_id 
      
       for  product in @facturas_rpt
       
         if lcCategoria == product.products_category_id
            row = []         
            row << nroitem.to_s
            row << product.get_categoria_name(product.products_category_id)
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.codigo
            row << product.nameproducto
            row << product.unidad 
            row << sprintf("%.2f",product.quantity.to_s)
           
            if product.price != nil 
              if product.moneda_id == 1
                if product.fecha 
                   puts product.fecha 
                  @tipocambio = product.get_tipocambio(product.fecha)
                else
                  @tipocambio = 1
                end 
                valorcambio =product.price * @tipocambio
                row << sprintf("%.2f",product.price.to_s)
                row << sprintf("%.2f",valorcambio.to_s)
                
                valortotal = product.total*@tipocambio
              else
                row << "0.00 "
                
                row << sprintf("%.2f",product.price.to_s)
                
                valortotal = product.total*@tipocambio
                
              end 
            else
              row << "0.00 "
              row << "0.00 "
              
            end 
            if product.moneda_id == 1
              row << sprintf("%.2f",product.quantity * product.price )
                @totaldolares2 += product.quantity * product.price     
            else
              row << "0.00"  
            end 
            
            
            if product.products_category_id == 2
              
              valortotal_sigv=valortotal / 1.18
              row << sprintf("%.2f",valortotal_sigv.to_s)
              
              @totales2  += valortotal / 1.18   
            else  
              row << sprintf("%.2f",valortotal.to_s)
              
              @totales2  += valortotal   
            end 
            
            
            @cantidad2 += product.quantity
            
            
            table_content << row          
            nroitem=nroitem + 1
            valorcambio = 0
            valortotal = 0 
            @tipocambio = 1
            
          else
            total_qty    += @cantidad2   
            total_soles  += @totales2
            total_dolares += @totaldolares2
            
            @totales1 += @totales2 
            @cantidad += @cantidad2 
            @cantidad2 = 0
            @totales2  =0
            @totaldolares2  =0
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""
            row << ""
            row << "TOTALES  => "
            row << ""
            row << sprintf("%.2f",total_qty.to_s)
            row << " "
            row << " "
            row << sprintf("%.2f",total_dolares.to_s)
            row << sprintf("%.2f",total_soles.to_s)
            
            
            total_qty   = 0
            total_soles = 0
            total_dolares = 0
            
            table_content << row
            lcCategoria = product.products_category_id

            row = []         
            row << nroitem.to_s
            row << product.get_categoria_name(product.products_category_id)
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.codigo
            row << product.nameproducto
            row << product.unidad 
            
            row << sprintf("%.2f",product.quantity.to_s)
       
           
            if product.price != nil 
              if product.moneda_id == 1
                 if product.fecha 
                  @tipocambio = product.get_tipocambio(product.fecha)
                else
                  @tipocambio = 1
                end 
                valorcambio =product.price * @tipocambio
                row << sprintf("%.2f",product.price.to_s)
                row << sprintf("%.2f",valorcambio.to_s)
              
                valortotal = product.total*@tipocambio
              else
                row << "0.00 "
                row << sprintf("%.2f",product.price.to_s)
              
                valortotal = product.total*@tipocambio
              end 
            else
              row << "0.00 "
              row << "0.00 "
              
              
            end 
            
            if product.moneda_id == 1
              row << sprintf("%.2f",product.quantity * product.price )
                @totaldolares2 += product.quantity * product.price     
            else
              row << "0.00"  
            end 
            
             
            if product.products_category_id == 2
              valortotal_sigv=valortotal / 1.18
              row << sprintf("%.2f",valortotal_sigv.to_s)
              @totales2  += valortotal / 1.18   
            else  
              row << sprintf("%.2f",valortotal.to_s)
              @totales2  += valortotal   
            end 
            
            
            @cantidad2 += product.quantity
            
            
            table_content << row          
            

          end 
        end
        
      
      total_qty    += @cantidad2   
      total_soles  += @totales2
      total_dolares += @totaldolares2
      
      @totales1 += @totales2 
      @cantidad += @cantidad2 
      
      @cantidad2 = 0
      @totales2  =0
      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << "TOTALES  => "
      row << ""
      row << sprintf("%.2f",total_qty.to_s)
      row << " "
      row << " "
      row << sprintf("%.2f",total_dolares.to_s)
      row << sprintf("%.2f",total_soles.to_s)
      
      
        table_content << row
      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << "TOTAL GENERAL  => "
      row << ""
      row << sprintf("%.2f",@cantidad.to_s)
      row << " "
      row << " "
      row << sprintf("%.2f",@totaldolares2.to_s)
      row << sprintf("%.2f",@totales1.to_s)
      

      table_content << row
      
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([1]).width = 50
                                          columns([2]).align=:left
                                          columns([2]).width = 50
                                          columns([3]).align=:left
                                          columns([3]).width = 40
                                          columns([4]).align=:right
                                          columns([4]).width = 35
                                          columns([5]).align=:left
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                          columns([7]).width = 40
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                          columns([10]).align=:right
                                          columns([10]).width = 40
                                          columns([11]).align=:right
                                          columns([11]).width = 40
                                        end                                          
      pdf.move_down 10      
      #totales 
      pdf 

    end

    def build_pdf_footer_rpt48(pdf)
            data =[ ["Procesado por Almacen ","V.B.Almacen","V.B.Compras ","V.B. Gerente ."],
               [":",":",":",":"],
               [":",":",":",":"],
               ["Fecha:","Fecha:","Fecha:","Fecha:"] ]

           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1} , :width => pdf.bounds.width)
            pdf.move_down 10          
            pdf.text "" 
            pdf.bounding_box([0, 30], :width => 535, :height => 40) do
            pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end

  def rpt_ingresos4_all_pdf
  
    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @almacen = params[:almacen_id]
    
    @facturas_rpt = @company.get_ingresos_day4(@fecha1,@fecha2,@almacen )
    
   
      Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
          pdf.font "Helvetica"
          pdf = build_pdf_header_rpt48(pdf)
          pdf = build_pdf_body_rpt48(pdf)
          build_pdf_footer_rpt48(pdf)
          $lcFileName =  "app/pdf_output/rpt_factura.pdf"              
      end     
      $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')
    end

#fin reporte de ingresos x producto 
#----------------------------------------------------------------------------

# reporte de ingresos x producto 

# reporte completo
  def build_pdf_header_rpt9(pdf)
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

  def build_pdf_body_rpt9(pdf)
    
    pdf.text "Listado de Ingresos desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
  
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS4.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      @totales1 = 0
      @totales2 = 0
      @cantidad = 0
      nroitem = 1
      @tipocambio = 1
      valorcambio = 0
      valortotal = 0


       for  product in @facturas_rpt
 
            row = []         
            row << nroitem.to_s
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.codigo
            row << product.nameproducto
            row << product.unidad 
            row << product.supplier.name  
             
            row << sprintf("%.2f",product.quantity.to_s)
       
           
            if product.price != nil 

             

              if product.moneda_id == 1
                 if product.fecha 
                @tipocambio = product.get_tipocambio(product.fecha)
                else
                  @tipocambio = 1
                  end 
                   valorcambio =product.price * @tipocambio
                row << sprintf("%.2f",product.price.to_s)
                row << sprintf("%.2f",valorcambio.to_s)
                valortotal = product.total*@tipocambio
               
              else
                
                row << sprintf("%.2f",product.price.to_s)
                row << sprintf("%.2f",valorcambio.to_s)
               
                 valortotal = product.total*@tipocambio
              end 

            else
              row << "0.00 "
              row << "0.00 "
            end 
             
            row << sprintf("%.2f",valortotal.to_s)
            @totales1 += valortotal   
            table_content << row          
            @cantidad += product.quantity

            nroitem=nroitem + 1
            valorcambio = 0
            valortotal = 0 
            @tipocambio = 1
        end
      
      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
     
      row << "TOTALES => "
      row << sprintf("%.2f",@cantidad.to_s)
      row << " "
      row << " "
      row << sprintf("%.2f",@totales1.to_s)


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
                                          columns([5]).align=:center  
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                        end                                          
      pdf.move_down 10      
      #totales 
      pdf 

    end

    def build_pdf_footer_rpt9(pdf)
            data =[ ["Procesado por Almacen ","V.B.Almacen","V.B.Compras ","V.B. Gerente ."],
               [":",":",":",":"],
               [":",":",":",":"],
               ["Fecha:","Fecha:","Fecha:","Fecha:"] ]

           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1} , :width => pdf.bounds.width)
            pdf.move_down 10          

                        
      pdf.text "" 
      pdf.bounding_box([0, 30], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end

#fin reporte de ingresos x producto 


# reporte de ingresos x producto x familia 

# reporte completo
  def build_pdf_header_rpt6(pdf)
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

  def build_pdf_body_rpt6(pdf)
    
    pdf.text "Listado de Ingresos desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 11
    pdf.text "Categoria  : "+@namecategoria  , :size => 11
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS4.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

      @totales1 = 0
      @totales2 = 0
      @cantidad = 0
      nroitem = 1
      @tipocambio = 1
      valorcambio = 0
      valortotal = 0

       for  product in @facturas_rpt
 
            row = []         
            row << nroitem.to_s
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.codigo
            row << product.nameproducto
            row << product.unidad 
            row << product.supplier.name  
             
            row << sprintf("%.2f",product.quantity.to_s)
       
           
            if product.price != nil 
            
              if product.moneda_id == 1
                 if product.fecha 
                @tipocambio = product.get_tipocambio(product.fecha)
                else
                  @tipocambio = 1
                end 
                   valorcambio =product.price * @tipocambio
                row << sprintf("%.2f",product.price.to_s)
                row << sprintf("%.2f",valorcambio.to_s)
                if product.products_category_id == 2
                valortotal = product.total*@tipocambio / 1.18
               else
                 valortotal = product.total*@tipocambio 
               end 
              else
                
                row << product.price 
                row << sprintf("%.2f",valorcambio.to_s)
               if product.products_category_id == 2
                 valortotal = product.total*@tipocambio / 1.18
                else
                  valortotal = product.total*@tipocambio 
                end 
              end 

            else
              row << "0.00 "
              row << "0.00 "
            end 
             
            row << sprintf("%.2f",valortotal.to_s)
            @totales1 += valortotal   
            table_content << row          
            @cantidad += product.quantity

            nroitem=nroitem + 1
            valorcambio = 0
            valortotal = 0 
            @tipocambio = 1
        end
      
      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
     
      row << "TOTALES => "
      row << sprintf("%.2f",@cantidad.to_s)
      row << " "
      row << " "
      row << sprintf("%.2f",@totales1.to_s)


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
                                          columns([5]).align=:center  
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                        end                                          
      pdf.move_down 10      
      #totales 
      pdf 

    end

    def build_pdf_footer_rpt6(pdf)
            data =[ ["Procesado por Almacen ","V.B.Almacen","V.B.Compras ","V.B. Gerente ."],
               [":",":",":",":"],
               [":",":",":",":"],
               ["Fecha:","Fecha:","Fecha:","Fecha:"] ]

           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1} , :width => pdf.bounds.width)
            pdf.move_down 10          

                        
      pdf.text "" 
      pdf.bounding_box([0, 30], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end

  def rpt_ingresos2_all_pdf
  
    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @categoria = params[:products_category_id]    
    @namecategoria = @company.get_categoria_name(@categoria)      

    @facturas_rpt = @company.get_ingresos_day2(@fecha1,@fecha2,@categoria)


    Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt6(pdf)
        pdf = build_pdf_body_rpt6(pdf)
        build_pdf_footer_rpt6(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')

  end


#fin reporte de ingresos x producto 


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
    
    pdf.text "Facturas  Emitidas : desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
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
      lcMon='S/.'

       for  product in @facturas_rpt

            row = []          
            row << lcDoc
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")            
            row << product.supplier.name  
            row << lcMon
            row << product.subtotal.to_s
            row << product.tax.to_s
            row << product.total.to_s
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
      subtotal = @company.get_facturas_day_value(@fecha1,@fecha2, "subtotal")
      subtotals.push(subtotal)
      services_subtotal += subtotal          
      #pdf.text subtotal.to_s
    
    
      tax = @company.get_facturas_day_value(@fecha1,@fecha2, "tax")
      taxes.push(tax)
      services_tax += tax
    
      #pdf.text tax.to_s
      
      total = @company.get_facturas_day_value(@fecha1,@fecha2, "total")
      totals.push(total)
      services_total += total
      #pdf.text total.to_s

    else
        #total x cliente 
      subtotal = @company.get_facturas_day_value_cliente(@fecha1,@fecha2,@cliente, "subtotal")
      subtotals.push(subtotal)
      services_subtotal += subtotal          
      #pdf.text subtotal.to_s
    
    
      tax = @company.get_facturas_day_value_cliente(@fecha1,@fecha2,@cliente, "tax")
      taxes.push(tax)
      services_tax += tax
    
      #pdf.text tax.to_s
      
      total = @company.get_facturas_day_value_cliente(@fecha1,@fecha2,@cliente, "total")
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
    
    pdf.text "Cuentas por Pagar  : desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS3.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcmonedasoles   = 2
      lcmonedadolares = 1
    

      lcDoc='FT'      

       lcCliente = @facturas_rpt.first.supplier_id

       for  product in @facturas_rpt

         if product.balance.round(2)  != 0.00
        
          if lcCliente == product.supplier_id

            
              fechas2 = product.date2 

            row = []          
            row << product.document.descripshort
            row << product.documento 
            row << product.date1.strftime("%d/%m/%Y")
            row << product.date2.strftime("%d/%m/%Y")
            row << product.supplier.name
            row << product.moneda.symbol  
            row << ""

            if product.moneda_id == 1 
                row << "0.00 "
                row << sprintf("%.2f",product.balance.to_s)
            else
                row << sprintf("%.2f",product.balance.to_s)
                row << "0.00 "
            end 
            row << product.get_vencido 

            
            table_content << row

            nroitem = nroitem + 1

          else
            totals = []            
            total_cliente_soles = 0
            total_cliente_soles = @company.get_purchases_pendientes_day_value(@fecha1,@fecha2, lcCliente, lcmonedadolares)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_purchases_pendientes_day_value(@fecha1,@fecha2, lcCliente, lcmonedasoles)
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""          
            row << "TOTALES POR PROVEEDOR=> "            
            row << ""
            row << ""
            row << sprintf("%.2f",total_cliente_dolares.to_s)
            row << sprintf("%.2f",total_cliente_soles.to_s)
            row << " "
            
            table_content << row

            lcCliente = product.supplier_id

            row = []          
            row << product.document.descripshort
            row << product.documento 
            row << product.date1.strftime("%d/%m/%Y")
            row << product.date2.strftime("%d/%m/%Y")
            if product.supplier != nil
            row << product.supplier.name
            else
            row << "Proveedor no existe "
            end 
            row << product.moneda.symbol  

            if product.moneda_id == 1 
                row << "0.00 "
                row << sprintf("%.2f",product.balance.to_s)
            else
                row << sprintf("%.2f",product.balance.to_s)
                row << "0.00 "
            end 
            row << product.get_vencido 

            table_content << row


          end 
          end 
          
         
        end

        lcProveedor = @facturas_rpt.last.supplier_id 

            totals = []            
            total_cliente = 0

            total_cliente_soles = 0
            total_cliente_soles = @company.get_purchases_pendientes_day_value(@fecha1,@fecha2, lcProveedor, lcmonedadolares)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_purchases_pendientes_day_value(@fecha1,@fecha2, lcProveedor, lcmonedasoles)
    
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""          
            row << "TOTALES POR PROVEEDOR=> "            
            row << ""
            row << ""
            row << sprintf("%.2f",total_cliente_dolares.to_s)
            row << sprintf("%.2f",total_cliente_soles.to_s)                      
            row << " "
            table_content << row
              
          total_soles = @company.get_pendientes_day_value(@fecha1,@fecha2, "total",lcmonedasoles)
          total_dolares = @company.get_pendientes_day_value(@fecha1,@fecha2, "total",lcmonedadolares)
      
           if $lcxCliente == "0" 

          row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          row << "TOTALES => "
          row << ""
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


    @facturas_rpt = @company.get_purchases_day(@fecha1,@fecha2)      

    respond_to do |format|
      format.html    
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end 

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
# pendiente x proveedor 

  def rpt_facturas_all2_pdf

    $lcFacturasall = '0'
    @company=Company.find(params[:company_id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @cliente = params[:supplier_id]     

    @facturas_rpt = @company.get_purchase_day_cliente(@fecha1,@fecha2,@cliente)  


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



  
  ###pendientes de pago 
  def rpt_cpagar3_pdf

    $lcxCliente ="1"
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @proveedor = params[:supplier_id]    
    @moneda = params[:moneda_id]    
    
    #@namecategoria = @company.get_categoria_name(@categoria)      

    @facturas_rpt = @company.get_ingresos_day3b(@fecha1,@fecha2,@proveedor,@moneda )

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
  def rpt_cpagar4_pdf
    
      $lcxCliente ="0"
      @company=Company.find(params[:company_id])          
      @fecha1 = params[:fecha1]  
      @fecha2 = params[:fecha2]  

      
      @facturas_rpt = @company.get_purchases_pendientes_day(@fecha1,@fecha2)  
      
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
  
#####
###inicio cpagar5 

##-------------------------------------------------------------------------------------
## REPORTE DE ESTADISTICA DE VENTAS
##-------------------------------------------------------------------------------------
  
  def build_pdf_header_rpt5(pdf)

  @fecha4= @fecha3.to_date  - 7.days
    if @tipomoneda == "1"
       @tipomoneda_name ="DOLARES"  
    else
       @tipomoneda_name ="SOLES "  
    end 
     
     
      pdf.font "Helvetica"  , :size => 8

     image_path = "#{Dir.pwd}/public/images/tpereda2.png"


       table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD OCUPACIONAL",:rowspan => 2},"CODIGO ","TP-FZ-F-029 "], 
          ["VERSION: ","2"], 
          ["CUENTAS POR PAGAR "+ @tipomoneda_name +" SEMANAL " ,"PAGINA:","1 de 1 "] 
          
          ])

       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 800
            columns([1]).align = :center
            
            columns([2]).width = 100
          
            columns([3]).width = 100
      
         end
        
         table_content2 = ([["Fecha : ",Date.today.strftime("%d/%M/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

         pdf.text "(1) "+@fecha2
         pdf.text "(2) del "+@fecha4.strftime("%d/%m/%Y")+" al "+@fecha3
         pdf.text "(3) "+@fecha3


#table_content = ([ [{:image=> image_path, :width => 100 },{:content => two_dimensional_array0,:width=>320,},two_dimensional_array1,two_dimensional_array2 ]
 #               ]) 
   

      # pdf.table(table_content, {
      #     :position => :center,
      #     :cell_style => {:border_width => 1},
      #     :width => pdf.bounds.width
      #   }) do
      #     columns([0, 2]).font_style = :bold

      
      #   end


      pdf.move_down 2
      pdf 
  end   

  def build_pdf_body_rpt5(pdf)



   

    
      headers = []
      table_content = []
      total_general = 0
      total_factory = 0





      Purchase::TABLE_HEADERS6.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end
      table_content << headers
      nroitem = 1

      a = Purchase.first

      tot_gral10 = 0
      tot_gral20 = 0

      tg1 = 0
      tg2 = 0
      tg3 = 0
      tg4 = 0
      tg5 = 0
      tg6 = 0
      tg7 = 0
      tg8 = 0
      tg9 = 0
      tg10 = 0
      tg11 = 0
      tg12 = 0
      tg13 = 0
      tg14 = 0
      tg15 = 0



      for  product in @customerpayment_rpt

          row =[]
          row << nroitem 
          row << product.supplier.ruc
          row << product.supplier.name 
          row << sprintf("%.2f",product.anio00.to_s)
          row << sprintf("%.2f",product.anio01.to_s)
          row << sprintf("%.2f",product.anio02.to_s)
          row << sprintf("%.2f",product.anio03.to_s)
          row << sprintf("%.2f",product.anio04.to_s)
          row << sprintf("%.2f",product.anio05.to_s)
          row << sprintf("%.2f",product.anio06.to_s)
          row << sprintf("%.2f",product.anio07.to_s)

          
           tot_gral3 =product.total_gral
           tot_gral4 =a.get_general_contar(@fecha1,@fecha2,product.supplier_id,@tipomoneda)
               
           tot_gral1 =     a.get_general_compras(@fecha4,@fecha3,product.supplier_id,@tipomoneda)
           tot_gral2 =    a.get_general_contar_compras(@fecha4,@fecha3,product.supplier_id,@tipomoneda)
          
          row << sprintf("%.2f",tot_gral3.to_s)
          row << sprintf("%.2f",tot_gral4.to_s)
 
          row << sprintf("%.2f",tot_gral1.to_s)
          row << sprintf("%.2f",tot_gral2.to_s)

          tot_gral10 = tot_gral3 -tot_gral1 
          tot_gral20 = tot_gral4 - tot_gral2 


          row << sprintf("%.2f",tot_gral10.to_s)
         
          row << sprintf("%.2f",tot_gral20.to_s)
          
          tot_gral30 =a.get_general(@fecha1,@fecha3,product.supplier_id,@tipomoneda)
          row << sprintf("%.2f",tot_gral30.to_s)
          row << sprintf("%.2f",product.xpagar.to_s)
          row << sprintf("%.2f",product.detraccion.to_s)
          row << sprintf("%.2f",product.saldo.to_s)


         

          tg1 += product.anio00
          tg2 += product.anio01
          tg3 += product.anio02
          tg4 += product.anio03
          tg5 += product.anio04
          tg6 += product.anio05
          tg7 += product.anio06
          tg8 += product.anio07
          tg9  += tot_gral3
          tg10 += tot_gral4
          tg11 += tot_gral1
          tg12 += tot_gral2
          tg13 += tot_gral10
          tg14 += tot_gral20
          tg15 += tot_gral30

          tot_gral10 = 0
          tot_gral20 = 0
          tot_gral30 = 0
          tot_gral40 = 0
          nroitem += 1

          table_content << row


      end 


      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([2]).width = 15  
                                          
                                          columns([1]).align=:left
                                          columns([2]).width = 20  
                                          
                                          columns([2]).align=:left 
                                          columns([2]).width = 130  
                                          
                                          columns([3]).align=:right 
                                          columns([3]).width = 50  
                                          
                                          columns([4]).align=:right
                                          columns([4]).width = 50  
                                          
                                          columns([5]).align=:right 
                                          columns([5]).width = 50  
                                          
                                          columns([6]).align=:right
                                          columns([6]).width = 50  
                                          
                                          columns([7]).align=:right 
                                          columns([7]).width = 50  
                                          
                                          columns([8]).align=:right
                                          columns([8]).width = 50  
                                          
                                          columns([9]).align=:right 
                                          columns([9]).width = 50  
                                          
                                          columns([10]).align=:right
                                          columns([10]).width = 50  
                                          
                                          columns([11]).align=:right 
                                          columns([11]).width = 50  
                                          
                                          columns([12]).align=:right
                                          columns([12]).width = 50  
                                          
                                          columns([13]).align=:right 
                                          columns([13]).width = 50  
                                          
                                          columns([14]).align=:right 
                                          columns([14]).width = 50  
                                          
                                          columns([15]).align=:right
                                          columns([15]).width = 50  
                                          
                                          columns([16]).align=:right 
                                          columns([16]).width = 50  

                                          columns([17]).align=:right
                                          columns([17]).width = 50  
                                          
                                          columns([18]).align=:right 
                                          columns([18]).width = 50  
                                                                                    
                                          columns([19]).align=:right 
                                          columns([19]).width = 50  
                                          
                                          columns([20]).align=:right
                                          columns([20]).width = 50  
                                          
                                        end                                          
      pdf.move_down 10    

      table_content3 =[] 

       row =[]
       row << ""
       row << ""
       row << "TOTAL GENERAL :"
       row << sprintf("%.2f",tg1.to_s)
       row << sprintf("%.2f",tg2.to_s)
       row << sprintf("%.2f",tg3.to_s)
       row << sprintf("%.2f",tg4.to_s)
       row << sprintf("%.2f",tg5.to_s)
       row << sprintf("%.2f",tg6.to_s)
       row << sprintf("%.2f",tg7.to_s)
       row << sprintf("%.2f",tg8.to_s)
       row << sprintf("%.2f",tg9.to_s)
       row << sprintf("%.2f",tg10.to_s)
       row << sprintf("%.2f",tg11.to_s)
       row << sprintf("%.2f",tg12.to_s)
       row << sprintf("%.2f",tg13.to_s)
       row << sprintf("%.2f",tg14.to_s)
       row << sprintf("%.2f",tg15.to_s)
       row << ""
       row << ""
       row << ""
       
        table_content3 << row

result = pdf.table table_content3, {:position => :center,
                                        :header => false,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([2]).width = 15  
                                          
                                          columns([1]).align=:left
                                          columns([2]).width = 20  
                                          
                                          columns([2]).align=:left 
                                          columns([2]).width = 130  
                                          
                                          columns([3]).align=:right 
                                          columns([3]).width = 50  
                                          
                                          columns([4]).align=:right
                                          columns([4]).width = 50  
                                          
                                          columns([5]).align=:right 
                                          columns([5]).width = 50  
                                          
                                          columns([6]).align=:right
                                          columns([6]).width = 50  
                                          
                                          columns([7]).align=:right 
                                          columns([7]).width = 50  
                                          
                                          columns([8]).align=:right
                                          columns([8]).width = 50  
                                          
                                          columns([9]).align=:right 
                                          columns([9]).width = 50  
                                          
                                          columns([10]).align=:right
                                          columns([10]).width = 50  
                                          
                                          columns([11]).align=:right 
                                          columns([11]).width = 50  
                                          
                                          columns([12]).align=:right
                                          columns([12]).width = 50  
                                          
                                          columns([13]).align=:right 
                                          columns([13]).width = 50  
                                          
                                          columns([14]).align=:right 
                                          columns([14]).width = 50  
                                          
                                          columns([15]).align=:right
                                          columns([15]).width = 50  
                                          
                                          columns([16]).align=:right 
                                          columns([16]).width = 50  

                                          columns([17]).align=:right
                                          columns([17]).width = 50  
                                          
                                          columns([18]).align=:right 
                                          columns([18]).width = 50  
                                                                                    
                                          columns([19]).align=:right 
                                          columns([19]).width = 50  
                                          
                                          columns([20]).align=:right
                                          columns([20]).width = 50  
                                          
                                        end                                          
      pdf.move_down 10     


      pdf

    end


    def build_pdf_footer_rpt5(pdf)

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


  def rpt_cpagar5_pdf
    
            
    @company=Company.find(params[:id])      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @fecha3 = params[:fecha3]
    
    @tipomoneda = params[:moneda_id]

    @company.actualizar_purchase_fecha2
    @company.actualizar_purchase_monthyear

    Freepagar.delete_all 

    @customerpayment_rpt = @company.get_supplier_payments2(@tipomoneda,@fecha1,@fecha2)

    

    Prawn::Document.generate "app/pdf_output/rpt_customerpayment2.pdf", :page_layout => :landscape ,:page_size=>"A3"  do |pdf|        

        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt5(pdf)
        pdf = build_pdf_body_rpt5(pdf)
        build_pdf_footer_rpt5(pdf)
        $lcFileName =  "app/pdf_output/rpt_customerpayment2.pdf"      
        

    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')

  end




#### fin cpagar5


  def client_data_headers_rpt
      client_headers  = [["Empresa  :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]
      client_headers
  end

  def invoice_headers_rpt            
      invoice_headers  = [["Fecha : ",$lcHora]]    
      invoice_headers
  end



  def newfactura  
    @company = Company.find(1)
    @purchaseorder = Purchaseorder.find(params[:id])  

  
  

    @detalleitems =  @company.get_orden_detalle(@purchaseorder.id)

    @purchase = Purchase.new 

    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()
    @suppliers = @company.get_suppliers()      
    @almacens = @company.get_almacens()


  end 
def newfactura2
    @company = Company.find(1)
    @purchaseorder = Serviceorder.find(params[:id])      

    # $lcPurchaseOrderId = @purchaseorder.id
    # $lcProveedorId  = @purchaseorder.supplier_id
    # $lcProveedorName =@purchaseorder.supplier.name 
    # $lcFechaEmision = @purchaseorder.fecha1
    # $lcFormaPagoId  = @purchaseorder.payment_id
    # $lcFormaPago    = @purchaseorder.payment.descrip
    # $lcFormaPagoDias =@purchaseorder.payment.day
    # $lcMonedaId   = @purchaseorder.moneda_id
    # $lcMoneda  = @purchaseorder.moneda.description
    # $lcLocationId = @purchaseorder.location_id
    # $lcDivisionId = @purchaseorder.division_id
    

    #$lcTipoFacturaCompra= "1"

    @detalleitems =  @company.get_orden_detalle2(@purchaseorder.id)

    @purchase = Purchase.new 

    @almacens = @company.get_almacens()
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()
    @suppliers = @company.get_suppliers()    
    @almacens = @company.get_almacens()  
    @purchase.date1 = Date.today

     @purchase.date2 = Date.today
  end 

  def do_crear

    @action_txt = "do_crear" 
    @purchaseorder = Purchaseorder.find(params[:id] ) 
    @lcDocumentId    =  params[:document_id]
    @lcDocumento     =  params[:documento]

    @lcFechaEmision  =  params[:date1]
    @lcFechaEntrega  =  params[:date2]
    @suma_stock      =  params[:suma_stock]

   

     days = @purchaseorder.payment.day  
     fechas2 = @lcFechaEntrega.to_date + days.days                           

    @lcFechaVmto     =  fechas2
    @lcDocumento     =  params[:documento]
    
    @purchase = Purchase.new(:company_id=>1,:supplier_id=>@purchaseorder.supplier_id,:date1=>@lcFechaEmision,:date2=>@lcFechaEntrega,:payment_id=>@purchaseorder.payment_id,
      :document_id=>@lcDocumentId,:documento=>@lcDocumento,
      :date3 => @lcFechaVmto,:moneda_id => @purchaseorder.moneda_id,:user_id =>@current_user.id,
      :purchaseorder_id=> params[:id],:almacen_id => params[:almacen_id] ,:suma_stock=> @suma_stock)
    
    @company = Company.find(1)
    puts "sadas"
    puts @lcFechaEntrega

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
      
    @documents    = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas      = @company.get_monedas()
    @payments     = @company.get_payments()
    @tipodocumento = @purchase[:document_id]  


    @purchase[:tipo] = "0"

    @almacens = @company.get_almacens()
    

    
      @detalleitems =  @company.get_orden_detalle(@purchaseorder.id)


  
    if @tipodocumento == 2
      @purchase[:payable_amount] = @purchase.get_subtotal2(@detalleitems)*-1
    else
      @purchase[:payable_amount] = @purchase.get_subtotal2(@detalleitems)
    end    
    
    
    
        begin
           if @tipodocumento == 2
            @purchase[:tax_amount] = @purchase.get_tax2(@detalleitems, @purchase[:supplier_id])*-1

           else
            @purchase[:tax_amount] = @purchase.get_tax2(@detalleitems, @purchase[:supplier_id])
           end 
        rescue
          @purchase[:tax_amount] = 0
          
        end
    
      @purchase[:total_amount] = @purchase[:payable_amount] + @purchase[:tax_amount]
      @purchase[:charge]  = 0
      @purchase[:pago] = 0

      
      if @purchase[:payment_id]  == 1 
        @purchase[:pago] = @purchase[:total_amount]
        @purchase[:balance] =  0.00 
      
      else 
        @purchase[:pago] = 0
        @purchase[:balance] =   @purchase[:total_amount]
      end 

    

      curr_seller = User.find(@current_user.id)
      @ac_user = curr_seller.username
    

      respond_to do |format|
       if    @purchase.save  || @purchase[:documento] != ""
          # Create products for kit
          @purchase.add_products_compras(@detalleitems,"0")
          # Check if we gotta process the invoice

          @purchase[:suma_stock] = @suma_stock

          @purchase.process()

          
            order_process = Purchaseorder.find(@purchaseorder.id)
            if order_process
              order_process.processed ='3'
              order_process.save
            end 
        
          format.html { redirect_to("/companies/purchases/1", :notice => 'Factura fue grabada con exito .') }
          format.xml  { render :xml => @purchase, :status => :created, :location => @purchase}
        else
          format.html { render :action => "newfactura" }
          format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
        end 
        
      end
  end 

 def do_crear2

    @action_txt = "do_crear2" 
    @purchaseorder =  Serviceorder.find(params[:id]) 

    @lcDocumentId    =  params[:document_id]
    @lcDocumento     =  params[:documento]

    @lcFechaEmision  =  params[:date1]
    @lcFechaEntrega  =  params[:date2]
    @suma_stock      =  params[:suma_stock]

    puts "purchase order id "
    puts @purchaseorder_id 

     days = @purchaseorder.payment.day  
     fechas2 = @lcFechaEntrega.to_date + days.days                           

    @lcFechaVmto     =  fechas2
    @lcDocumento     =  params[:documento]
    
    @purchase = Purchase.new(:company_id=>1,:supplier_id=>@purchaseorder.supplier_id,:date1=>@lcFechaEmision,:date2=>@lcFechaEntrega,:payment_id=>@purchaseorder.payment_id,
      :document_id=>@lcDocumentId,:documento=>@lcDocumento,
      :date3 => @lcFechaVmto,:moneda_id => @purchaseorder.moneda_id,:user_id =>@current_user.id,
      :purchaseorder_id=> params[:id],:almacen_id => params[:almacen_id] ,:suma_stock=> @suma_stock)
    
    @company = Company.find(1)
    puts "sadas"
    puts @lcFechaEntrega

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
      
    @documents    = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas      = @company.get_monedas()
    @payments     = @company.get_payments()
    @tipodocumento = @purchase[:document_id]  


    @purchase[:tipo] = "1"

    @almacens = @company.get_almacens()
    
    @detalleitems =  @company.get_orden_detalle2(@purchaseorder.id)
   

  
    if @tipodocumento == 2
      @purchase[:payable_amount] = @purchase.get_subtotal2(@detalleitems)*-1
    else
      @purchase[:payable_amount] = @purchase.get_subtotal2(@detalleitems)
    end    
    
  
      begin
           if @tipodocumento == 2
            @purchase[:tax_amount] = @purchase.get_tax3(@detalleitems, @purchase[:supplier_id])*-1

           else
            @purchase[:tax_amount] = @purchase.get_tax3(@detalleitems, @purchase[:supplier_id])
           end 
           x = @purchase[:tax_amount]
              

      rescue
          @purchase[:tax_amount] = 0        
      end
  

          
          @purchase[:total_amount] = @purchase[:payable_amount] + @purchase[:tax_amount]
          @purchase[:charge]  = 0
          @purchase[:pago] = 0

          
          if @purchase[:payment_id]  == 1 
            @purchase[:pago] = @purchase[:total_amount]
            @purchase[:balance] =  0.00 
          
          else 
            @purchase[:pago] = 0
            @purchase[:balance] =   @purchase[:total_amount]
          end 

        

          curr_seller = User.find(@current_user.id)
          @ac_user = curr_seller.username
    

      respond_to do |format|
       if    @purchase.save  || @purchase[:documento] != ""
          # Create products for kit
          @purchase.add_products_compras(@detalleitems,"1")
          # Check if we gotta process the invoice

          @purchase[:suma_stock] = @suma_stock

          @purchase.process()

         
            order_process = Serviceorder.find(@purchaseorder.id)
            if order_process
              order_process.processed ='3'
              order_process.save
            end 
        

          format.html { redirect_to("/companies/purchases/1", :notice => 'Factura fue grabada con exito .') }
          format.xml  { render :xml => @purchase, :status => :created, :location => @purchase}
        else
          format.html { render :action => "newfactura2" }
          format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
        end 
        
      end
  end 


  
  

  def cargar
    lcProcesado='1'
    @company = Company.find(1)
    @purchaseorders = Purchaseorder.where(["processed =  ? ",lcProcesado])
    return @purchaseorders

  end   
  def cargar2
    lcProcesado='1'
    @company = Company.find(1)
    @purchaseorders = Serviceorder.where(["processed =  ? ",lcProcesado])
    return @purchaseorders

  end   


  def datos
    nrodocumento =params[:documento]    
  end 

  # Export purchase to PDF
  def pdf
    @purchase = Purchase.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/purchases/pdf/#{@purchase.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end

  def search_serviceorders    
    @serviceorders = Serviceorder.search(params[:search_param])
  end

  def buscar_ingresos    
    @company = Company.find(params[:company_id])
    @facturas = Purchase.search(params[:search_param])

  end


  def add_oservice

    @oservice = Serviceorder.find(params[:oservice])
    purchases.build(oservice_id: @oservice.id)
    if purchases.save
      redirect_to my_purchases_path, notice: "Orden service was successfully added."
    else
      redirect_to my_purchases_path, flash[:error] = "There was an error with adding user as oservice."

    end

  end


  # Process an purchase
  def do_process
    @purchase = Purchase.find(params[:id])
    @purchase[:processed] = "1"

    if @purchase.tipo == "0"  
      
        if @purchase.document_id != 2
          @purchase.process
        else 
          @purchase.process2
        end 
        
    else 
        @purchase.process2
    end 

    @user_id = @current_user.id 
    flash[:notice] = "The purchase order has been processed."
    redirect_to @purchase
  end
  
  # Do send purchase via email
  def do_email
    @purchase = Purchase.find(params[:id])
    @email = params[:email]
    
    Notifier.purchase(@email, @purchase).deliver 
    
    flash[:notice] = "The purchase has been sent successfully."
    redirect_to "/purchases/#{@purchase.id}"
  end
  
  # Send purchase via email
  def email
    @purchase = Purchase.find(params[:id])
    @company = @purchase.company
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
        price2 = price.to_f/1.18
              
        product = Product.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_f
        product[:price]    = price.to_f
        product[:discount] = discount.to_f
        product[:price2]   = price2.round(2)

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
    @products = Product.where(["company_id = ? AND (code LIKE ? OR name iLIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])  
    render :layout => false
  end
  
  # Autocomplete for users
  def ac_user
    company_users = CompanyUser.where(company_id: params[:company_id])
    user_ids = []
    
    for cu in company_users
      user_ids.push(cu.user_id)
    end
    
    @users = User.where(["id IN (#{user_ids.join(",")}) AND (email iLIKE ? OR username iLIKE ?)", "%" + params[:q] + "%", "%" + params[:q] + "%"])
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
    @suppliers =  Supplier.where(["company_id = ? AND (ruc LIKE ? OR name iLIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show purchases for a company
  def list_purchases

    @company = Company.find(params[:company_id])
    @status = params[:status_id]
    
    @pagetitle = "#{@company.name} - Facturas"
    @filters_display = "block"
    
    @locations = Location.where(company_id: @company.id).order("name ASC")
    @divisions = Division.where(company_id: @company.id).order("name ASC")
    puts "status "
    puts @status 

    if(@company.can_view(current_user))

      if @status == "1" 
         if current_user.level != "almacen" 

             @purchases = Purchase.all.order('date1 DESC',"documento  DESC").where(status: @status).paginate(:page => params[:page])

            if params[:search]
              @purchases = Purchase.search(params[:search]).order("date1 DESC","documento DESC").paginate(:page => params[:page])
            else
              @purchases = Purchase.order('date1 DESC',"documento DESC").where(status: @status).paginate(:page => params[:page]) 
            end
          else
             @purchases = Purchase.all.order('date1 DESC',"documento  DESC").where(status: @status,user_id: 9).paginate(:page => params[:page])

            if params[:search]
              @purchases = Purchase.search(params[:search]).where(user_id:9).order("date1 DESC","documento DESC").paginate(:page => params[:page])
            else
              @purchases = Purchase.order('date1 DESC',"documento DESC").where(status: @status,user_id: 9).paginate(:page => params[:page]) 
            end
          
          end  


      else
        if current_user.level != "almacen" 

        @purchases = Purchase.all.order('date1 DESC',"documento  DESC").where(status: nil).paginate(:page => params[:page])
        
        if  params[:search] != ""

           @purchases = Purchase.where("documento ilike ? ",  "%#{params[:search]}%").order("date1 DESC","documento DESC").paginate(:page => params[:page])
           puts "else 2 "

        else
          @purchases = Purchase.order('date1 DESC',"documento DESC").where(status: nil).paginate(:page => params[:page]) 
        end
        else 

          @purchases = Purchase.all.order('date1 DESC',"documento  DESC").where(status: nil,user_id: 9).paginate(:page => params[:page])
        
        if  params[:search] != ""

           @purchases = Purchase.where("documento ilike ?  and user_id = 9",  "%#{params[:search]}%").order("date1 DESC","documento DESC").paginate(:page => params[:page])
           puts "else 2 "

        else
          @purchases = Purchase.order('date1 DESC',"documento DESC").where(status: nil,user_id: 9).paginate(:page => params[:page]) 
        end
          
        end

      end
    
    else
      errPerms()
    end


  end
  
  # GET /purchases
  # GET /purchases.xml
  def index
    console 

    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'purchases'
    @pagetitle = "Purchases"
  end
  
  # GET /purchases/1
  # GET /purchases/11.xml
 
  # GET /purchases/new
  # GET /purchases/new.xml
 

  def new
    @pagetitle = "New purchase"
    @action_txt = "Create"
    @cierre = Cierre.last 
    parts0 = @cierre.fecha.strftime("%Y-%m-%d") 
    parts = parts0.split("-")
    
    $yy = parts[0].to_i
    $mm = parts[1].to_i
    $dd = parts[2].to_i 
    
    
    @purchase = Purchase.new
    
    @purchase[:processed] = false
    
    @company = Company.find(params[:company_id])
    @purchase.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()
   @almacens = @company.get_almacens()
    
    @ac_user = getUsername()
    @purchase[:user_id] = getUserId()
    @purchase[:almacen_id] = 1

    @purchase[:date1] = DateTime.now
      @purchase[:date2] = DateTime.now
        @purchase[:date3] = DateTime.now

  end

 def new2

    @pagetitle = "New purchase"
    @action_txt = "Create"
     @cierre = Cierre.last 
    parts0 = @cierre.fecha.strftime("%Y-%m-%d") 
    parts = parts0.split("-")
    
    $yy = parts[0].to_i
    $mm = parts[1].to_i
    $dd = parts[2].to_i 
    
    
    @purchase = Purchase.new
    
    @purchase[:processed] = false
    @purchase[:inafecto] = 0
    @purchase[:payable_amount] = 0
    
    @purchase[:date1] = Date.today
    @purchase[:date2] = Date.today 
    @purchase[:document_id] = 7  
  
    
    @company = Company.find(params[:company_id])
    @purchase.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()
    @almacens = @company.get_almacens()
    
    @ac_user = getUsername()
    @purchase[:user_id] = getUserId()
    
  end


  # GET /purchases/1/Edit
  def edit
    @pagetitle = "Editar factura"
    @action_txt = "Actualizacion"
    
    @purchase = Purchase.find(params[:id])
    @company = @purchase.company
    @ac_supplier = @purchase.supplier.name

    @ac_user = "admin"

    
    
    @purchase_details = @purchase.purchase_details
     


     
      @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()  

    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  @almacens = @company.get_almacens()
  end

  # POST /purchases
  # POST /purchases.xml
  def create

      @pagetitle = "Nueva Compra"
    @action_txt = "Crear"
  
    @purchase = Purchase.new(purchase_params)
    
    if  params[:purchase][:status] == "1"
          @company = Company.find(params[:purchase][:company_id])
          
          @locations = @company.get_locations()
          @divisions = @company.get_divisions()
            
          @documents = @company.get_documents()    
          @servicebuys  = @company.get_servicebuys()
          @monedas  = @company.get_monedas()
          @payments  = @company.get_payments()  
          @almacens = @company.get_almacens()
    

          @purchase[:total_amount] = @purchase[:payable_amount] * 1.18
          @purchase[:tax_amount] =@purchase[:total_amount] - @purchase[:payable_amount]  
          
          @tipodocumento = @purchase[:document_id]
          
          begin 
          if @tipodocumento == 2
            @purchase[:payable_amount] = @purchase[:payable_amount]*-1
          else
            @purchase[:payable_amount] = @purchase[:payable_amount]
          end   
          rescue
            @purchase[:payable_amount] = 0
          end  

          begin 

          if @tipodocumento == 2
            @purchase[:inafecto] = @purchase[:inafecto] *-1
          else
            @purchase[:inafecto] = @purchase[:inafecto]
          end    
          rescue
            @purchase[:inafecto] = 0

          end 

      begin
         if @tipodocumento == 2
          @purchase[:tax_amount] = @purchase[:tax_amount]*-1
         else
          @purchase[:tax_amount] = @purchase[:tax_amount]
         end 
      rescue
          @purchase[:tax_amount] = 0
      end

        @purchase[:location_id] = 1
        @purchase[:division_id] = 1    
        @purchase[:date3]  =   @purchase[:date2] + @purchase.get_dias_vmto(@purchase[:payment_id]).days  
        
        @purchase[:total_amount] = @purchase[:payable_amount] + @purchase[:tax_amount]  + @purchase[:inafecto]
        @purchase[:charge]  = 0


    if @purchase[:payment_id]  == 1 
      @purchase[:pago] = @purchase[:total_amount]
      @purchase[:balance] =  0.00 
    
    else 
      @purchase[:pago] = 0
      @purchase[:balance] =   @purchase[:total_amount]
    end 

    
    
    if(params[:purchase][:user_id] and params[:purchase][:user_id] != "")
      curr_seller = User.find(params[:purchase][:user_id])

      @ac_user = curr_seller.username
    end    
    
      respond_to do |format|
        if @purchase.save    

          product = Product.find(8992)
          afecto  =  @purchase[:payable_amount] / 1.18
          total1  =  @purchase[:payable_amount]
          inafecto = @purchase[:inafect]
          quantity = 1.0
          discount = 0.0
          total =   @purchase[:total_amount]
          impuesto = 18.00
          tax  =   @purchase[:tax_amount]
          
          new_pur_product = PurchaseDetail.new(:purchase_id => @purchase.id, :product_id => product.id,
          :price_without_tax => afecto.to_f,:price_with_tax=>total1, :inafecto =>inafecto.to_f,
          :quantity => quantity.to_i, :discount => discount.to_f,
          :total => total ,:impuesto=> impuesto.to_f,:totaltax=>tax)
          new_pur_product.save

          @purchase.process()
          puts @purchase[:total_amount]
    
          format.html { redirect_to(@purchase, :notice => 'Factura fue grabada con exito .') }
          format.xml  { render :xml => @purchase, :status => :created, :location => @purchase}
        else
          format.html { render :action => "new2" }
          format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
        end
      end

    else  

    @pagetitle = "Nueva Compra"
    @action_txt = "Crear"
     @cierre = Cierre.last 
    parts0 = @cierre.fecha.strftime("%Y-%m-%d") 
    parts = parts0.split("-")
    
    $yy = parts[0].to_i
    $mm = parts[1].to_i
    $dd = parts[2].to_i 
    
    items = params[:items].split(",")
    
    @purchase = Purchase.new(purchase_params)
    
    @company = Company.find(params[:purchase][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
      
    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()
    @almacens = @company.get_almacens()
    
      @purchase[:date3]  =   @purchase[:date2] + @purchase.get_dias_vmto(@purchase[:payment_id]).days  
  

    @tipodocumento = @purchase[:document_id]
    
    if @tipodocumento == 2
      @purchase[:payable_amount] = @purchase.get_subtotal(items) 
    else
      @purchase[:payable_amount] = @purchase.get_subtotal(items)
    end    
    

    begin
       if @tipodocumento == 2
        @purchase[:tax_amount] = @purchase.get_tax(items, @purchase[:supplier_id])  
        else
        @purchase[:tax_amount] = @purchase.get_tax(items, @purchase[:supplier_id])
       end 
    rescue
      @purchase[:tax_amount] = 0
      
    end
    
    @purchase[:total_amount] = @purchase[:payable_amount] + @purchase[:tax_amount]
    @purchase[:charge]  = 0


    
    if @purchase[:payment_id]  == 1 
      @purchase[:pago] = @purchase[:total_amount]
      @purchase[:balance] =  0.00 
         @purchase[:tipo]    = 0
    
    else 
      @purchase[:pago] = 0
      @purchase[:balance] =   @purchase[:total_amount]
       @purchase[:tipo]    = 1
    end 

 
    
    
    if(params[:purchase][:user_id] and params[:purchase][:user_id] != "")
      curr_seller = User.find(params[:purchase][:user_id])

      @ac_user = curr_seller.username
    end    
    

      respond_to do |format|

        if @purchase.save     
          if @tipodocumento == 2

            @purchase.add_products_menos(items) 

            @purchase.process_nota_credito
          else

            @purchase.add_products(items)   

            @purchase.process()

          end 


          
          format.html { redirect_to(@purchase , :notice => 'Factura fue grabada con exito .') }
          format.xml  { render :xml => @purchase, :status => :created, :location => @purchase}
        else
          format.html { render :action => "new"  }
          format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
        end
      end 

      end      
  end
  




  # PUT /purchases/1
  # PUT /purchases/1.xml
  def update
    @pagetitle = "Edit purchase"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @purchase = Purchase.find(params[:id])
    @company = @purchase.company
    
    @documents = @company.get_documents()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    @payments  = @company.get_payments()

    @purchase[:total_amount] = @purchase[:payable_amount] * 1.18
    @purchase[:tax_amount] =@purchase[:total_amount] - @purchase[:payable_amount]  
    
    @tipodocumento = @purchase[:document_id]

    puts @purchase[:total_amount]
    puts @purchase[:tax_amount]
    puts @purchase[:payable_amount] 
    if  @purchase[:payable_amount].nil?
      @purchase[:payable_amount] = 0 
    end  
    
    if  @purchase[:inafecto].nil?
      @purchase[:inafecto] = 0 
    end  
    
    begin 
    if @tipodocumento == 2
      @purchase[:payable_amount] = @purchase[:payable_amount] * -1
    else
      @purchase[:payable_amount] = @purchase[:payable_amount]
    end   
    rescue
      @purchase[:payable_amount] = 0
    end  

    begin 

    if @tipodocumento == 2
      @purchase[:inafecto] = @purchase[:inafecto] * -1
    else
      @purchase[:inafecto] = @purchase[:inafecto]
    end    
    rescue
      @purchase[:inafecto] = 0

    end 

    begin
       if @tipodocumento == 2
        @purchase[:tax_amount] =  @purchase[:tax_amount] * -1
       else
        @purchase[:tax_amount] =  @purchase[:tax_amount]
        end 
    rescue
        @purchase[:tax_amount] = 0
    end

    @purchase[:location_id] = 1
    @purchase[:division_id] = 1    
    @purchase[:date3]  =   @purchase[:date2] + @purchase.get_dias_vmto(@purchase[:payment_id]).days  
    
    @purchase[:total_amount] = @purchase[:payable_amount] + @purchase[:tax_amount]  + @purchase[:inafecto]
    @purchase[:charge]  = 0
    @purchase[:pago] = 0
    @purchase[:balance] =   @purchase[:total_amount]


    puts "usuario****"
    puts current_user.id 

    @purchase[:user_id] = current_user.id  
    
    respond_to do |format|
      if @purchase.update_attributes(purchase_params)
        # Create products for kit
        
        # Check if we gotta process the purchase

        format.html { redirect_to(@purchase, :notice => 'purchase was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.xml
  def destroy
    @purchase= Purchase.find(params[:id])
    company_id = @purchase[:company_id]


    
    if @purchase.processed == "1" 
      
      @purchase.process_menos
      
      
    end   
    
    @purchase.process_documentos
    
    @purchase.destroy
    

    respond_to do |format|
      format.html { redirect_to("/companies/purchases/" + company_id.to_s) }
    end
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


  
  
  private

  

  def purchase_params
    params.require(:purchase).permit(:tank_id,:date1,:date2,:date3,:exchange,
      :product_id,:unit_id,:price_with_tax,:price_without_tax,:price_public,:quantity,:other,:money_type,
      :discount,:tax1,:payable_amount,:tax_amount,:total_amount,:status,:pricestatus,:charge,:pago,
      :balance,:tax2,:supplier_id,:order1,:plate_id,:user_id,:company_id,:location_id,:division_id,:comments,
      :processed,:return,:date_processed,:payment_id,:document_id,:documento,:moneda_id,:search,:inafecto,:almacen_id,:participacion,:suma_stock )
  end

end