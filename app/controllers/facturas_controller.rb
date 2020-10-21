include UsersHelper 

include CustomersHelper
include ServicesHelper
require "open-uri"
 

class FacturasController < ApplicationController

    $: << Dir.pwd  + '/lib'
    before_action :authenticate_user!
    
    require "open-uri"

  def rpt_compras1_pdf
    @company=Company.find(1)      
   
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    
    @product = params[:ac_item_id]

    @products = @company.get_products_dato(@product)        

    @facturas_rpt = @company.get_ingresos_day(@fecha1,@fecha2,@product)


    if @facturas_rpt != nil 
    
      case params[:print]
        when "To PDF" then 
            redirect_to :action => "rpt_ingresos_all_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2],:id=>"1", :ac_item_id=> params[:ac_item_id]

        when "Excel" then render xlsx: 'rpt_compras1_xls'
    
          
        else render action: "index"
      end
    end 

    
  end



  def rpt_ingresos_all_pdf
  
    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @product = params[:ac_item_id]    
    
    @products = @company.get_products_dato(@product)        

    @facturas_rpt = @company.get_ingresos_day(@fecha1,@fecha2,@product)


    Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt9(pdf)
        pdf = build_pdf_body_rpt9(pdf)
        build_pdf_footer_rpt9(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')

  end


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

      Purchase::TABLE_HEADERS41.each do |header|
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
            if product.products_category_id.nil? 
              row <<"Categoria eliminada"
            else 
              row << product.get_categoria_name(product.products_category_id) 
            end 

            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.codigo
            row << product.nameproducto
            row << product.unidad 
            row << product.supplier.name  
             
            row << sprintf("%.2f",product.quantity.to_s)
       
           
            if product.price != nil 

              if product.moneda_id == "1"

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
                row << sprintf("%.2f",valorcambio.to_s)  
                row << sprintf("%.2f",product.price.to_s)
               
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

#fin reporte de ingresos x product

## salidas




  def rpt_salidas_pdf

    @company=Company.find(1)      
   
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
  
    @items  = params[:products_ids]

   
    
      case params[:print]
        when "PDF" then 
            redirect_to :action => "rpt_salidas_all_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2],:id=>"1", :ac_item_id=> params[:ac_item_id] ,:items => @items 
        when "Excel" then 
            render xlsx: 'rpt_salidas_xls'
    

        else render action: "index"
      end
  

    
  end


  def rpt_salidas_all_pdf
  
    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @items  = params[:items]

    @facturas_rpt = []

   for item in @items 

      puts item

      @facturas_rpt0 = @company.get_salidas_day0(@fecha1,@fecha2,item)

      if @facturas_rpt0 != nil 
        @facturas_rpt  += @facturas_rpt0 
      end 


    end 

    Prawn::Document.generate "app/pdf_output/rpt_factura.pdf" , :page_layout => :landscape  do |pdf|

        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt91(pdf)
        pdf = build_pdf_body_rpt91(pdf)
        build_pdf_footer_rpt91(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')

  end

  def build_pdf_header_rpt91(pdf)
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

  def build_pdf_body_rpt91(pdf)
    
    pdf.text "Listado de Salidas desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
  
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Output::TABLE_HEADERS4.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcDoc='FT'
      lcMon='S/.'
      @total = 0
      @totales = 0
      @cantidad = 0
      nroitem = 1

       for  product in @facturas_rpt
 
            row = []         
            row << nroitem.to_s
            row << product.get_categoria(product.id)
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.codigo
            row << product.nameproducto
            row << product.unidad 
            row << product.supplier.name
            row << product.employee.full_name2 
           
            if product.truck_id == nil 
                  row << ""
            else
                  row << product.truck.placa
            end    
 
            row << sprintf("%.2f",product.quantity.to_s)
            row << sprintf("%.2f",product.get_stock(product.product_id).to_s)
            row << sprintf("%.2f",product.price.to_s)
            @total = product.quantity * product.price
            row << sprintf("%.2f",@total.to_s)
          
            table_content << row

            @totales += @total  
            @cantidad += product.quantity

            nroitem=nroitem + 1
       
        end
      
      row =[]
      row << ""
      row << ""
      row << ""
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
      row << sprintf("%.2f",@totales.to_s)


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
                                        
                                          columns([5]).align=:left
                                          columns([5]).width= 120
                                          columns([6]).align=:right
                                          columns([7]).align=:left
                                          columns([8]).align=:left
                                          columns([9]).align=:right
                                          columns([9]).width= 50
                                          columns([10]).align=:right
                                          columns([10]).width= 50
                                          columns([11]).align=:right
                                          columns([11]).width= 50
                                          columns([12]).align=:right
                                          columns([12]).width= 50

                                        end                                          
      pdf.move_down 10      
      #totales 
      pdf 

    end

    def build_pdf_footer_rpt91(pdf)
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


#fin reporte de ingresos x product


## salidas 

  def rpt_facturas1_all

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @tiporeporte =params[:tiporeporte]

    @rpt_detalle_purchase_sol = @company.get_purchases_day_tipo_moneda(@fecha1,@fecha2,@tiporeporte,"2")
    @rpt_detalle_purchase_dol = @company.get_purchases_day_tipo_moneda(@fecha1,@fecha2,@tiporeporte,"1")


    if @rpt_detalle_purchase_sol != nil  or @rpt_detalle_purchase_dol != nil 
    
      case params[:print]
        when "PDF" then 
            redirect_to :action => "rpt_purchase2_all", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2], :tiporeporte => params[:tiporeporte]

        when "Excel" then render xlsx: 'rpt_facturascompras1_xls'
    
          
        else render action: "index"
      end
    end 

    
  end


## Reporte de factura detallado
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

  def build_pdf_body9(pdf)
    
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
    



  def rpt_compras2_pdf
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @categoria = params[:products_category_id]    
    @namecategoria = @company.get_categoria_name(@categoria)      

    @facturas_rpt = @company.get_ingresos_day2(@fecha1,@fecha2,@categoria)

    
    if @facturas_rpt != nil 
    
      case params[:print]
        when "To PDF" then 
            redirect_to :action => "rpt_ingresos2_all_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2],:id=>"1", :products_category_id=> params[:products_category_id]

        when "Excel" then render xlsx: 'rpt_compras2_xls'
    
          
        else render action: "index"
      end
    end 

    
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
            
              if product.moneda_id == "1"
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
                row << sprintf("%.2f",valorcambio.to_s)
                
                row << product.price 
                
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



  def rpt_compras3_pdf
    @company=Company.find(1)          
           
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    
    @facturas_rpt = @company.get_ingresos_day4(@fecha1,@fecha2)
    

    
    if @facturas_rpt != nil 
    
      case params[:print]
        when "To PDF" then 
            redirect_to :action => "rpt_ingresos3_all_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2],:id=>"1"

        when "Excel" then render xlsx: 'rpt_compras3_xls'
    
          
        else render action: "index"
      end
    end 

    
  end





  def rpt_ingresos3_all_pdf
  
    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    
    @facturas_rpt = @company.get_ingresos_day4(@fecha1,@fecha2)
    
   
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






  def ac_st 
    procesado = '1'
    @guias = Manifest.where([" (code LIKE ?)   ",  "%" + params[:q] + "%"])   
    render :layout => false
  end

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
   

    @current_user_id = current_user.id 
    
    @facturas_rpt = @company.get_facturas_day_todos(@fecha1,@fecha2)          
   
    
    @total1  = @company.get_facturas_by_day_value(@fecha1,@fecha2,@moneda,"subtotal")  
    @total2  = @company.get_facturas_by_day_value(@fecha1,@fecha2,@moneda,"tax")  
    @total3  = @company.get_facturas_by_day_value(@fecha1,@fecha2,@moneda,"total")  
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas2_rpt.pdf.erb",locals: {:facturas => @facturas_rpt},
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
  

def rpt_monitoreo
    $lcFacturasall = '1'

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
   

    @current_user_id = current_user.id 
    
    @facturas_rpt = @company.get_facturas_day_todos(@fecha1,@fecha2)          
   
    
    @total1  = @company.get_facturas_by_day_value(@fecha1,@fecha2,@moneda,"subtotal")  
    @total2  = @company.get_facturas_by_day_value(@fecha1,@fecha2,@moneda,"tax")  
    @total3  = @company.get_facturas_by_day_value(@fecha1,@fecha2,@moneda,"total")  
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas2_rpt.pdf.erb",locals: {:facturas => @facturas_rpt},
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
  

def reportes_st_1 

    $lcFacturasall = '1'

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
   

    @current_user_id = current_user.id 
    
    @facturas_rpt = @company.get_st_day(@fecha1,@fecha2,"all")          
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rpt_st_1.pdf.erb",locals: {:facturas => @facturas_rpt},
         :orientation      => 'Landscape',
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }

        end   
      when "To Excel" then render xlsx: 'rpt_st_1'
      else render action: "index"
    end
  end

 

def reportes_st_2

    $lcFacturasall = '1'

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
   

    @current_user_id = current_user.id 
    @locations = @company.get_locations

     @formato ="TP-CL-005/VERSION 1"
   

    @local_check = params[:check_local]

    if @local_check == "true"
      @local = ""
      @local_name = ""
      @facturas_rpt = @company.get_st_day(@fecha1,@fecha2,"all") 

    else
      @local = params[:location_id]     
      @local_name =  @company.get_local_name(@local)
      @facturas_rpt = @company.get_st_day(@fecha1,@fecha2,@local) 
    end 
  
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rpt_st_2.pdf.erb",locals: {:facturas => @facturas_rpt},
         :orientation      => 'Landscape',
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header2.html',
                           right: '[page] of [topage]'
                  }                  
               } ,

          :footer => { :html => { template: 'layouts/pdf-footer.html' }       }  ,   
          :margin => {bottom: 25} 

        end   



      when "To Excel" then render xlsx: 'rpt_st_2'
      else render action: "index"
    end
  end  

def reportes_st_3

    $lcFacturasall = '1'

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
   
   @formato ="TP-CL-004/VERSION 1"
   
    @current_user_id = current_user.id 
    
    #@facturas_rpt = @company.get_st_mes(@fecha1,@fecha2)  

    @local_check = params[:check_local]
    
    if @local_check == "true"
      @local = ""
      @local_name = ""
      @facturas_rpt = @company.get_st_mes(@fecha1,@fecha2,"all") 

    else
      @local = params[:location_id]     
      @local_name =  @company.get_local_name(@local)
      @facturas_rpt = @company.get_st_mes(@fecha1,@fecha2,@local) 
    end 
  

    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rpt_st_3.pdf.erb",locals: {:facturas => @facturas_rpt},
         :orientation      => 'Landscape',
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header2.html',
                           right: '[page] of [topage]'
                  }                  
               } ,

          :footer => { :html => { template: 'layouts/pdf-footer.html' }       }  ,   
          :margin => {bottom: 25} 

        end   



      when "To Excel" then render xlsx: 'rpt_st_3'
      else render action: "index"
    end
  end  


  ###pendientes de pago 
  def rpt_cpagar2_pdf


    $lcxCliente ="0"

    @company=Company.find(1)      
    @purchase = Purchase.last 
    
    @fecha1 = params[:fecha1]
    
    @fecha2 = params[:fecha2]

    @moneda_id = params[:moneda_id]

    
    @check_proveedor = params[:check_proveedor]
    @proveedor = params[:supplier_id ]
   # @company.actualizar_fecha2

    

    if @check_proveedor == 'on' 

          @purchase_soles = @company.get_purchases_by_moneda_prov(@fecha1,@fecha2,"1")  
          @purchase_dolar = @company.get_purchases_by_moneda_prov(@fecha1,@fecha2,"2") 
          
    else

 
          @purchase_soles  = @company.get_purchases_by_moneda_provb(@fecha1,@fecha2,"1",@proveedor )
          @purchase_dolar  = @company.get_purchases_by_moneda_provb(@fecha1,@fecha2,"2",@proveedor )

    end 



   case params[:print] 
      when "To PDF" then 
        if @moneda_id == "2"
            begin 
             render  pdf: "Proveedores ",template: "facturas/rpt_cpagar2.pdf.erb",locals: {:facturas => @purchase },
             :orientation      => 'Portrait',
             :header => {
               :spacing => 5,
                               :html => {
                         :template => 'layouts/pdf-header6.html',
                               right: '[page] of [topage]'
                      }                  
                   } ,

              :footer => { :html => { template: 'layouts/pdf-footer3.html' }       }  ,   
              :margin => {bottom: 25} 

            end   
        else
            begin 
             render  pdf: "Proveedores ",template: "facturas/rpt_cpagar2dolar.pdf.erb",locals: {:facturas => @purchase },
             :orientation      => 'Portrait',
             :header => {
               :spacing => 5,
                               :html => {
                         :template => 'layouts/pdf-header6.html',
                               right: '[page] of [topage]'
                      }                  
                   } ,

              :footer => { :html => { template: 'layouts/pdf-footer3.html' }       }  ,   
              :margin => {bottom: 25} 

            end   

        end 


      when "Excel"   then 

        begin 

           if @check_proveedor == 'on' 

              @purchase_soles = @company.get_purchases_by_moneda_prov3(@fecha1,@fecha2,@moneda_id)  
           else 
                @purchase_soles = @company.get_purchases_by_moneda_prov3b(@fecha1,@fecha2,@moneda_id,@proveedor)  
            end 
              
              render xlsx: 'rpt_purchase_pend'


        end 

      else render action: "index"

    end
  

  end







  def reportes5
    $lcFacturasall = '1'

    @company=Company.find(1)          
    @fecha1 = params[:month].to_i    
    @fecha2 = params[:year].to_i    
    
    puts "meses"
    puts @fecha1
    puts @fecha2
    @formato ="TP-CL-004/VERSION 1"
    
    @moneda = params[:moneda_id]    
    
    @current_user_id = current_user.id 
    
    @facturas_rpt = @company.get_facturas_day_month(@moneda,@fecha1,@fecha2)          
    
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas_rpt.pdf.erb",locals: {:facturas => @facturas_rpt},
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


  def list_items3
    
    @company = Company.find(1)
    items = params[:items3]
    items = items.split(",")
    items_arr = []
    @guias = []
    i = 0
    puts "item list items3 "
    puts items 
    for item in items
      if item != ""
        parts = item.split("|BRK|")

        puts parts

        id = parts[0]      
        product = Manifest.find(id.to_i)
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
  def ac_sts
    procesado = '1'
    @sts = Manifest.where(["company_id = ? AND (code LIKE ?)   ", params[:company_id], "%" + params[:q] + "%"])   
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
      
        if current_user.email == 'gestor.comercial.1@tpereda.com.pe' || current_user.email =='gestor.comercial.2@tpereda.com.pe' || current_user.email =='gestor.comercial.3@tpereda.com.pe'
        @current_user_id = current_user.id 
             @invoices = Factura.all.where(user_id: @current_user_id).order('fecha DESC',"code DESC").paginate(:page => params[:page])
            if params[:search]
              @invoices = Factura.where(user_id: @current_user_id).search(params[:search]).order('fecha DESC',"code DESC").paginate(:page => params[:page])
            else
              @invoices = Factura.where(user_id: @current_user_id).order('fecha DESC',"code DESC").paginate(:page => params[:page]) 
            end
        else 
        
           @invoices = Factura.all.order('fecha DESC',"code DESC").paginate(:page => params[:page])
            if params[:search]
              @invoices = Factura.search(params[:search]).order('fecha DESC',"code DESC").paginate(:page => params[:page])
            else
              @invoices = Factura.order('fecha DESC',"code DESC").paginate(:page => params[:page]) 
            end
  
           
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
    
    @facturas  = Factura.where("fecha>=? and fecha<=? and tipo =?","2020-07-01 00:00:00","2025-08-31 23:59:59","1")
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
        lcRazon = f.customer.name 
        
        for productItem in f.get_products2(f.id)

        lcPsigv= productItem.price
        lcPsigv1= lcPsigv*1.18
        lcPcigv = lcPsigv1.round(2)
        lcCantidad= productItem.quantity
        lcDescrip = ""
        lcDescrip << productItem.name + "\n"
        if f.os_customer.nil?
          lcDescrip << lcDes
        else 

        lcDescrip << lcDes << f.os_customer 
      end 
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
        :description => lcDescrip,:comments => lcComments,:descrip =>lcDes1,:moneda =>lcMoneda,:razon=> lcRazon )
        new_invoice_item.save
        
      end  
    end 

    
    @invoice = Invoicesunat.all
    send_data @invoice.to_csv , :filename => 'FT2019.csv'
    
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
    
   
    
    $lcruc = "20424092941" 
    
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
    
    @invoice[:contrato] = ""
    
    
    
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
    @tipodocumento = @company.get_documents_area("OPE")
    @manifests = @company.get_manifests()


    @ac_user = getUsername()
    @invoice[:user_id] = getUserId()
    @invoice[:moneda_id] = 2
    @invoice[:document_id] = 7
    
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
    @tipodocumento = @company.get_documents_area("OPE")
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
    @tipodocumento = @company.get_documents_area("OPE")
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
    items3 = params[:items3].split(",")


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
      @invoice[:detraccion] = 0
    
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
        @invoice.add_sts(items3)
        
        
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

  def guias1
  
    $lcxCliente ="1"
   
   @company=Company.find(1)      
    @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]
    @tiporeporte = params[:tiporeporte]
     if @tiporeporte == "0"  
      @delivery = @company.get_guias_day(@fecha1,@fecha2)  
    end 
    if @tiporeporte == "1"  
      @delivery = @company.get_guias_day1(@fecha1,@fecha2)  
    end 
    if @tiporeporte == "2"
      @delivery = @company.get_guias_day2(@fecha1,@fecha2)  
    end 
    if @tiporeporte == "3"
      @delivery = @company.get_guias_day3(@fecha1,@fecha2)  
    end 

    case params[:print]
      when "To PDF" then 
           redirect_to :action => "guias1_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2] ,:tiporeporte => @tiporeporte, locals: {:suppliers => @delivery }
          
      when "To Excel" then render xlsx: 'rpt_guias1_xls'
        
      else render action: "index"
    end
  end





  # Export serviceorder to PDF
  def guias1_pdf
    
    
      @company=Company.find(1)  
         @tiporeporte = params[:tiporeporte]   
      puts @tiporeporte
 @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]
    
    if @tiporeporte == "0"  
      @delivery = @company.get_guias_day(@fecha1,@fecha2)  
    end 
    if @tiporeporte == "1"  
      @delivery = @company.get_guias_day1(@fecha1,@fecha2)  
    end 
    if @tiporeporte == "2"
      @delivery = @company.get_guias_day2(@fecha1,@fecha2)  
    end 
    if @tiporeporte == "3"
      @delivery = @company.get_guias_day3(@fecha1,@fecha2)  
    end 
      
    Prawn::Document.generate("app/pdf_output/guias1.pdf") do |pdf|      

        pdf.start_new_page(:size => "A4", :layout => :landscape)
        pdf.font_families.update( "Helvetica" => { normal: Rails.root.join('app', 'assets/fonts', 'HelveticaNeueW01-65Medium.ttf').to_s, bold: Rails.root.join('app', 'assets/fonts', 'HelveticaNeueW01-65Medium.ttf').to_s, italic: Rails.root.join('app', 'assets/fonts', 'HelveticaNeueW01-65Medium.ttf').to_s, bold_italic: Rails.root.join('app', 'assets/fonts', 'HelveticaNeueW01-65Medium.ttf').to_s } )
        pdf.font "Helvetica",:size =>6
  
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/guias1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    #send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    send_file("app/pdf_output/guias1.pdf", :type => 'application/pdf', :disposition => 'inline')
  

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
    
    pdf.text "Guias EMITIDAS  : Desde "+@fecha1.to_s  + "Hasta : "+ @fecha2.to_s, :size => 11 
    if @tiporeporte == "0"  
      pdf.text "POR FECHA DE GUIA"
    end 
    if @tiporeporte == "1"  
          pdf.text "POR FECHA DE INGRESO"
        end 
    if @tiporeporte == "2"  
          pdf.text "POR FECHA DE OPERACIONES"
        end 
    if @tiporeporte == "3"  
          pdf.text "POR FECHA DE CONTABILIDAD"
    end 

    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Delivery::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @delivery

            lcOrigen = product.get_origen(product.remite_id)

            row = []
            row << nroitem.to_s

            if product.fecha1 == nil
              row << "-"
            else
            row << product.fecha1.strftime("%d/%m/%Y")
            end 

            row << product.created_at.strftime("%d/%m/%Y")
            if product.fecha3 == nil
              row << "-"
            else 
              row << product.fecha3.strftime("%d/%m/%Y")
            end
            if product.fecha4 == nil
              row << "-"
            else
              row << product.fecha4.strftime("%d/%m/%Y")
            end 


            row << product.get_remision
            row << product.code
            row << lcOrigen
            row << product.customer.name      

            row << product.description


            
            if    product.tranportorder_id != nil 

              if   product.tranportorder == nil  
                row << product.code 
              else
                row << product.tranportorder.code
              end 

              if product.tranportorder != nil  
              @ost= product.get_ost(product.tranportorder.id)

              row << product.get_punto(@ost.ubication_id)
              row << product.get_punto(@ost.ubication2_id)
              else
                row << " "
                row << " "
              end 

            else
              row << "No asignado" 
              row << " "
              row << " "
            end 


            row << product.get_processed


            table_content << row

            nroitem=nroitem + 1
             
        end

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([1]).width= 40    
                                          columns([2]).align=:left
                                          columns([2]).width= 40    
                                          columns([3]).align=:left
                                          columns([3]).width= 40    
                                          columns([4]).align=:left  
                                          columns([5]).align=:right
                                          columns([6]).align=:left 
                                          columns([7]).align=:left
                                          columns([8]).align=:left
                                          columns([9]).align=:left 
                                          columns([9]).width= 100 
                                          columns([10]).align=:left
                                          columns([10]).width= 80
                                          columns([11]).align=:left
                                          columns([12]).align=:left
                                          columns([13]).align=:left
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer(pdf)

      if @tiporeporte == "2" 

       data =[ ["RECEPCION Y DES.","MONITOREO","IRMA LOBO ","VILMA VEGA","ASIS.GERENCIA","RUTH VEGA","PAUL PEREDA"],
               [" "],
               [" "],
               ["Fecha:"] ]
      elsif  @tiporeporte == "3"
        
         data =[ ["RECEPCION Y DES.","IRMA LOBO ","VILMA VEGA","ASIS.GERENCIA","CONTABILIDAD","PAUL PEREDA"],
               [" "],
               [" "],
               ["Fecha:"] ]
        
      else  
          data =[ ["RECEPCION Y DES.","IRMA LOBO ","VILMA VEGA","ASIS.GERENCIA","RUTH VEGA","PAUL PEREDA"],
               [" "],
               [" "],
               ["Fecha:"] ]
      end          
           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>0} , :width => pdf.bounds.width)
            pdf.move_down 10          


        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end



  def rpt_ccobrar2
  
    $lcxCliente ="1"
    @company=Company.find(1)      
    
    lcmonedadolares ="1"
    lcmonedasoles ="2"
    
    @fecha1 = params[:fecha1]  
    @fecha2 = params[:fecha2]

    @company.actualizar_fecha2
    #@company.actualizar_detraccion 

    @facturas_rpt = @company.get_pendientes_day(@fecha1,@fecha2)  

    case params[:print]
      when "To PDF" then 
           redirect_to :action => "rpt_ccobrar2_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2] 
          
      when "To Excel" then render xlsx: 'rpt_ccobrar2_xls'
        
      else render action: "index"
    end
  end
  
  def rpt_ccobrar3
  
    $lcxCliente ="1"
    @company=Company.find(1)      
    
     @company.actualizar_fecha2
     #@company.actualizar_detraccion 


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
            row << product.contrato             
            row << product.moneda.symbol  

            if product.moneda_id == 1 
                  row << "0.00 "
                  row << sprintf("%.2f",product.balance.to_s)
                  if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance
                  end  
                
            else
                  row << sprintf("%.2f",product.balance.to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance
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
            row << product.document.descripshort 
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
              dias = (product.fecha2.to_date - product.fecha.to_date).to_i 
            
            row << dias 
            row << product.customer.name
            row << product.contrato
            
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
    @company=Company.find(1)      
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]

    lcmonedadolares ="1"
    lcmonedasoles ="2"
    

    #@company.actualizar_fecha2
    #@company.actualizar_detraccion 

    @facturas_rpt = @company.get_pendientes_day(@fecha1,@fecha2)  

      
    Prawn::Document.generate("app/pdf_output/rpt_pendientes.pdf")  do |pdf|
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
   
    
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    @cliente = params[:customer_id]      
   
    @facturas_rpt = @company.get_pendientes_cliente(@fecha1,@fecha2,@cliente)  
    
    
    
    @dolares = 0
    @soles = 0 

    if @facturas_rpt.size > 0 

        Prawn::Document.generate("app/pdf_output/rpt_pendientes.pdf")  do |pdf|
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



  
def discontinue2
    @company = Company.find(1)
    
    if params[:products_ids] 
    
    @rqselect = Rqdetail.find(params[:products_ids])


    for item in @rqselect
        begin
    

          new_estado = Rqdetail.find(item.id)     
          new_estado.atento="1"
          new_estado.save 
           
        
         end              
    end

    
   end

  
  
     
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
          
          #customerpayment_rpt.balance.round(2) > 0.00
      
          if customerpayment_rpt.year_month.to_f <= 201812
            @total_anterior = @total_anterior + customerpayment_rpt.balance
          end             
          
          if customerpayment_rpt.year_month.to_f >= 201901  and customerpayment_rpt.year_month.to_f <= 201912
            @total_mes01 = @total_mes01 + customerpayment_rpt.balance
          end   

         if customerpayment_rpt.year_month.to_f >= 202001 and customerpayment_rpt.year_month.to_f <= 202003
        
            @total_mes02 = @total_mes02 + customerpayment_rpt.balance
          end 
            
          if customerpayment_rpt.year_month == '202004'   
            @total_mes03 = @total_mes03 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202005'     
            @total_mes04 = @total_mes04 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202006'       
            @total_mes05 = @total_mes05 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202007'
            @total_mes06 = @total_mes06 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202008' 
            @total_mes07 = @total_mes07 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202009'   
            @total_mes08 = @total_mes08 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202010'     
            @total_mes09 = @total_mes09 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202011'       
            @total_mes10 = @total_mes10 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202012'   
            @total_mes11 = @total_mes11 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202101'     
            @total_mes12 = @total_mes12 + customerpayment_rpt.balance
          end   
            @total_general = @total_general + customerpayment_rpt.balance
            
        #end 
          
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
            
          #if customerpayment_rpt.balance.round(2) > 0.00
          
          if customerpayment_rpt.year_month.to_f <= 201812
            @total_anterior = @total_anterior + customerpayment_rpt.balance
          end             
          
          if customerpayment_rpt.year_month.to_f >= 201901  and customerpayment_rpt.year_month.to_f <= 201912
            @total_mes01 = @total_mes01 + customerpayment_rpt.balance
          end   

          if customerpayment_rpt.year_month.to_f >= 202001  and customerpayment_rpt.year_month.to_f <= 202003
         
            @total_mes02 = @total_mes02 + customerpayment_rpt.balance
          end 
            
          if customerpayment_rpt.year_month == '202004'   
            @total_mes03 = @total_mes03 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202005'     
            @total_mes04 = @total_mes04 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202006'       
            @total_mes05 = @total_mes05 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202007'
            @total_mes06 = @total_mes06 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202008' 
            @total_mes07 = @total_mes07 + customerpayment_rpt.balance
          end
          if customerpayment_rpt.year_month == '202009'   
            @total_mes08 = @total_mes08 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202010'     
            @total_mes09 = @total_mes09 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202011'       
            @total_mes10 = @total_mes10 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202012'   
            @total_mes11 = @total_mes11 + customerpayment_rpt.balance
          end 
          if customerpayment_rpt.year_month == '202101'     
            @total_mes12 = @total_mes12 + customerpayment_rpt.balance
          end   
          
          nroitem = nroitem + 1 
      
          @total_general = @total_general + customerpayment_rpt.balance
        #end 
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


 ## imprimir pdf facturas

    def print
        @invoice = Factura.find(params[:id])
        
        lib = File.expand_path('../../../lib', __FILE__)
        $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
        
        require 'sunat'
        require './config/config'
        require './app/generators/invoice_generator'
        require './app/generators/credit_note_generator'
        require './app/generators/debit_note_generator'
        require './app/generators/receipt_generator'
        require './app/generators/daily_receipt_summary_generator'
        require './app/generators/voided_documents_generator'

        SUNAT.environment = :production 

        files_to_clean = Dir.glob("*.xml") + Dir.glob("./app/pdf_output/*.pdf") + Dir.glob("*.zip")
        files_to_clean.each do |file|
          File.delete(file)
        end         
       ###################################
        @serie_factura =  "FF"+@invoice.code[1..2].rjust(2,"0")
        puts "serie factura : "
        puts @serie_factura
       if @invoice.document_id == 13
           if @invoice.moneda_id == 1
                case_96 = ReceiptGenerator.new(12, 96, 1,@serie_factura,@invoice.id).with_different_currency2(true)
            else        
                case_52 = ReceiptGenerator.new(8, 52, 1,@serie_factura,@invoice.id).with_igv2(true)
            end 
       else        
           if @invoice.moneda_id == 1  
                $lcFileName=""
                case_49 = InvoiceGenerator.new(1,3,1,@serie_factura,@invoice.id).with_different_currency2(true)
              #  puts $lcFileName 
           else
               
                case_3  = InvoiceGenerator.new(1,3,1,@serie_factura,@invoice.id).with_igv2(true)
           end        
        end 
    
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
        send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
        @@document_serial_id =""
        $aviso=""
    end 

        
    def sendmail      
        @invoice = Factura.find(params[:id])
        
        lib = File.expand_path('../../../lib', __FILE__)
        $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

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

          @serie_factura =  "FF"+@invoice.code[2..3]

           lcMail         = @invoice.customer.email
       

        if @invoice.moneda_id == "1"
            case_49 = InvoiceGenerator.new(7,49,5,@serie_factura,@invoice.id).with_different_currency2(true)
        else
            case_3 = InvoiceGenerator.new(1, 3, 1,@serie_factura,@invoice.id).with_igv3(true)
        end 
    
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName        
        $lcFile2    = File.expand_path('../../../',__FILE__)+ $lcFilezip
        
        puts "file zip"        
        puts $lcFilezip
        puts "file 2"        
        
        puts $lcFile2

        ActionCorreo.bienvenido_email(@invoice,$lcFileName1,$lcFileName,$lcFile2,$lcFilezip,lcMail).deliver_now
         $lcGuiaRemision =""
             

    end


    def download
        extension = File.extname(@asset.file_file_name)
        send_data open("#{@asset.file.expiring_url(10000, :original)}").read, filename: "original_#{@asset.id}#{extension}", type: @asset.file_content_type
    end

    def xml
        
        lib = File.expand_path('../../../lib', __FILE__)
        $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

        require 'sunat'
        require './config/config'
        require './app/generators/invoice_generator'
        require './app/generators/credit_note_generator'
        require './app/generators/debit_note_generator'
        require './app/generators/receipt_generator'
        require './app/generators/daily_receipt_summary_generator'
        require './app/generators/voided_documents_generator'

        SUNAT.environment = :production 
        files_to_clean = Dir.glob("*.xml") + Dir.glob("./app/pdf_output/*.pdf") + Dir.glob("*.zip")

        files_to_clean.each do |file|
          File.delete(file)
        end         

        @serie_factura =  "FF"+@invoice.code[2..3]

         if @invoice.moneda_id == "1"
            case_49 = InvoiceGenerator.new(7,49,5,@serie_factura).with_different_currency2
        else
            case_3  = InvoiceGenerator.new(1, 3, 1,@serie_factura).with_igv3(true)
        end 
        $lcFile2 =File.expand_path('../../../', __FILE__)+ "/"+$lcFilezip    
    
        send_file("#{$lcFile2}",:type =>'application/zip', :disposition => 'inline') 
        @@document_serial_id =""
        $aviso=""
    end 



 #Process an invoice
  def reporte_asistencia1
  

    $lcFacturasall = '1'

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
   

    @current_user_id = current_user.id 
    
    @conceptos  = @company.get_inasists2       

    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "assistances/reporte_1.pdf.erb",locals: {:facturas => @conceptos},
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header5.html',
                           right: '[page] of [topage]'
                  }

               },

               :footer => { :html => { template: 'layouts/pdf-footers.html' }       }  ,   
               :margin => {bottom: 35} 

        end   
      when "To Excel" then render xlsx: 'rpt_st_1'
      else render action: "index"
    end
  end

 ##fin imprimir pdf facturas



 #Process an invoice
  def reporte_asistencia2
  

    $lcFacturasall = '1'

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @check_empleado = params[:check_empleado]
   
  @empleado = params[:employee_id]
    @current_user_id = current_user.id 
    
    @conceptos  = @company.get_inasists         
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "assistances/reporte_2.pdf.erb",locals: {:facturas => @conceptos},
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header5.html',
                           right: '[page] of [topage]'
                  }

               },

               :footer => { :html => { template: 'layouts/pdf-footers.html' }       }  ,   
               :margin => {bottom: 35} 

        end   
      when "To Excel" then render xlsx: 'rpt_asistencia_2'
      else render action: "index"
    end
  end



 #Process an invoice
def reporte_asistencia3

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @check_empleado = params[:check_empleado]
   
    @empleado = params[:employee_id]
    @current_user_id = current_user.id 
    
    @conceptos  = @company.get_asistencia_resumen(@fecha1,@fecha2)         
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "assistances/reporte_3.pdf.erb",locals: {:facturas => @conceptos},
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header5.html',
                           right: '[page] of [topage]'
                  }

               },

               :footer => { :html => { template: 'layouts/pdf-footers.html' }       }  ,   
               :margin => {bottom: 35} 

        end   
      when "To Excel" then render xlsx: 'rpt_asistencia_3'
      else render action: "index"
    end
  end



  def rpt_ost_3


    @company=Company.find(1)      
   
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    @tipo =  1
   
     @orden_transporte = @company.get_ordertransporte_day(@fecha1,@fecha2,@tipo)  
      
    if @facturas_rpt != nil 
    
      case params[:print]
        when "To PDF" then 
            redirect_to :action => "rpt_ost_3", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2]
        when "To Excel" then render xlsx: 'rpt_ost_3_xls'
    
          
        else render action: "index"
      end
    end 

    
  end
###################################################################################################
##REPORTE DE COMPRAS FACTURAS CREDITOS
###################################################################################################


  def build_pdf_header_rpt8(pdf)
      pdf.font "Helvetica" , :size => 8
      image_path = "#{Dir.pwd}/public/images/tpereda2.png"

    
      if @tipo == "1"
       table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD OCUPACIONAL",:rowspan => 2},"CODIGO ","TP-CM-F-015 "], 
          ["VERSION: ","3"], 
          ["REPORTE DE FACTURAS CREDITO - LIMA ","Pagina: ","1 de 1 "] 
         
          ])
      else
       table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD OCUPACIONAL",:rowspan => 2},"CODIGO ","TP-CM-F-015 "], 
          ["VERSION: ","3"], 
          ["REPORTE DE FACTURAS CONTADO - LIMA ","Pagina: ","1 de 1 "] 
         
          ])
        
      end 



       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 451.34
            columns([1]).align = :center
            
            columns([2]).width = 100
          
            columns([3]).width = 100
      
         end
        
         table_content2 = ([["Fecha : ",Date.today.strftime("%d/%m/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

     
         pdf.text "(1) del "+@fecha1+" al "+@fecha2
         
         pdf.move_down 2
      
      pdf 
  end   

  def build_pdf_body_rpt8(pdf)

    puts "tipo "
    puts @tipo 
    
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS31.each do |header|
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
      total_soles = 0
      total_dolares =  0
      lcDoc='FT'      

       lcCliente = @facturas_rpt.first.supplier_id
       row = []

       for  product in @facturas_rpt

        
        if product.user_id == 9 || product.user_id == 2 
        case @tipo 
         when "1"

          begin 
         
            if  product.supplier_id != 1731 and (product.payment_id != 12 || product.payment_id != 16  and product.payment_id != 1) and product.document_id != 13
            
                fechas2 = product.date2 
                 
                row = []          
                row << nroitem.to_s 
                row << product.supplier.name 
                row << product.document.descripshort 
              
                
                row << product.documento 
                row << product.get_descrip0[0..50]
                row << product.date1.strftime("%d/%m/%Y")
                row << product.date2.strftime("%d/%m/%Y")
                row << product.date3.strftime("%d/%m/%Y")

                if product.moneda_id == 1 
                    row << "0.00 "
                    row << sprintf("%.2f",product.total_amount.to_s)
                    total_dolares  += product.total_amount 
               
                else
                    row << sprintf("%.2f",product.total_amount.to_s)
                    row << "0.00 "
                    total_soles += product.total_amount  
                end 
                row << product.get_destino 
                row << product.user.username 
                row << product.get_observacion 
                row << product.payment.descrip 
                row << "   "
                
                table_content << row

                nroitem = nroitem + 1

            end 
           end  

          

      when "0" 
        begin 

          if  product.payment_id == 1 and product.supplier_id != 1731  and product.document_id != 13 

            fechas2 = product.date2 
               
              row = []          
              row << nroitem.to_s 
              row << product.supplier.name 
              row << product.document.descripshort
              row << product.documento 
              row << product.get_descrip0 
              
                row << product.date1.strftime("%d/%m/%Y")
                row << product.date2.strftime("%d/%m/%Y")
                row << product.date3.strftime("%d/%m/%Y")

              if product.moneda_id == 1 
                  row << "0.00 "
                  row << sprintf("%.2f",product.total_amount.to_s)
                  total_dolares  += product.total_amount 
             
              else
                  row << sprintf("%.2f",product.total_amount.to_s)
                  row << "0.00 "
                  total_soles += product.total_amount  

              end 
              row << product.get_destino 
              row << product.user.username 
              row << product.comments
              row << product.payment.descrip 
              row << "   "
              
              table_content << row

              nroitem = nroitem + 1
             
          end


      end 
    end 
    end 


      end 

        lcProveedor = @facturas_rpt.last.supplier_id 

            
            
         
        
              
          
          row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          
          row << "TOTALES => "
          row << ""
          
          row << ""
          
          row << ""
          row << sprintf("%.2f",total_soles.to_s)
          row << sprintf("%.2f",total_dolares.to_s)                    
          row << " "
          row << " "
          row << " "
          row << " "
          row << " "





          
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
                                          columns([5]).width = 40                                                                           
         
                                          columns([6]).width = 40                                                                           
         
                                          columns([7]).align=:right
                                          columns([7]).width = 40
                                          
                                          columns([8]).align=:right 
                                          columns([8]).width =40
                                          
                                          columns([9]).align=:right 
                                          columns([9]).width =40
                                          
                                          columns([10]).align=:left
                                          columns([10]).width =80
                                          columns([12]).width =80
                                          
                                          
                                        end                                          
                                        
      pdf.move_down 50





     
      pdf 

    end

    def build_pdf_footer_rpt8(pdf)      

      table_content3 =[]
      row = []
      row << "--------------------------------------------"
      row << "--------------------------------------------"
      row << "--------------------------------------------"
      
      table_content3 << row 
      row = []
      row << "V.B.COMPRAS "
      row << "V.B.GERENCIA"
      row << "V.B.CONTABILIDAD"
      
      table_content3 << row 

      
          result = pdf.table table_content3, {:position => :center,
                                        :header => true,  :cell_style => {:border_width => 0},
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:center
                                          columns([2]).align=:center 
                                          
                                        end                             

      pdf      
  end

  # Export serviceorder to PDF
  def rpt_purchase6

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @tipo   = params[:tiporeporte]   

    @fecha6  = params[:fecha6]   

     @supplier_check = params[:check_supplier] 


    if @supplier_check == "true"
      @proveedor = ""
      @proveedor_name = ""
    else
      @proveedor = params[:proveedor]
      @proveedor_name =  @company.get_supplier_name(@proveedor)
    end

    
    @facturas_rpt = @company.get_purchases_day(@fecha1,@fecha2,@proveedor,@fecha6) 


        Prawn::Document.generate "app/pdf_output/TP_CM_F_015.pdf" , :page_layout => :landscape ,:page_size=>"A4"  do |pdf|
            pdf.font "Helvetica"
            pdf = build_pdf_header_rpt8(pdf)
            pdf = build_pdf_body_rpt8(pdf)
            build_pdf_footer_rpt8(pdf)
            $lcFileName =  "app/pdf_output/TP_CM_F_015.pdf"              
        end     
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
        send_file("app/pdf_output/TP_CM_F_015.pdf", :type => 'application/pdf', :disposition => 'inline')    
 
  end


def rpt_purchase61

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
  
    @fecha6  = params[:fecha6]   
    @usuario = params[:usuario]

     @supplier_check = params[:check_supplier] 


    if @supplier_check == "true"
      @proveedor = ""
      @proveedor_name = ""
    else
      @proveedor = params[:proveedor]
      @proveedor_name =  @company.get_supplier_name(@proveedor)
    end
    
    @facturas_rpt = @company.get_purchases_day_usuario(@fecha1,@fecha2,@proveedor,@fecha6,@usuario) 



        Prawn::Document.generate "app/pdf_output/TP_CM_F_015.pdf" , :page_layout => :landscape ,:page_size=>"A4"  do |pdf|
            pdf.font "Helvetica"
            pdf = build_pdf_header_rpt8a(pdf)
            pdf = build_pdf_body_rpt8a(pdf)
            build_pdf_footer_rpt8a(pdf)
            $lcFileName =  "app/pdf_output/TP_CM_F_015.pdf"              
        end     
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
        send_file("app/pdf_output/TP_CM_F_015.pdf", :type => 'application/pdf', :disposition => 'inline')    
 
  end




###################################################################################################
##REPORTE DE COMPRAS FACTURAS CREDITOS 1
###################################################################################################


  def build_pdf_header_rpt8a(pdf)
      pdf.font "Helvetica" , :size => 8
      image_path = "#{Dir.pwd}/public/images/tpereda2.png"

    
      
       table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD OCUPACIONAL",:rowspan => 2},"CODIGO ","TP-CM-F-015 "], 
          ["VERSION: ","3"], 
          ["REPORTE DE FACTURAS - LIMA ","Pagina: ","1 de 1 "] 
         
          ])
      



       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 451.34
            columns([1]).align = :center
            
            columns([2]).width = 100
          
            columns([3]).width = 100
      
         end
        
         table_content2 = ([["Fecha : ",Date.today.strftime("%d/%m/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

     
         pdf.text "(1) del "+@fecha1+" al "+@fecha2
         
         pdf.move_down 2
      
      pdf 
  end   

  def build_pdf_body_rpt8a(pdf)

    puts "tipo "
    puts @tipo 
    
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS31.each do |header|
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
      total_soles = 0
      total_dolares =  0

      lcDoc='FT'      

      if @facturas_rpt.count > 0 

       lcCliente = @facturas_rpt.first.supplier_id
       row = []

       for  product in @facturas_rpt

        
            if  product.supplier_id != 1731 and (product.payment_id != 12 || product.payment_id != 16 ) and product.document_id != 13
            
                fechas2 = product.date2 
                 
                row = []          
                row << nroitem.to_s 
                row << product.supplier.name 
                row << product.document.descripshort 
              
                
                row << product.documento 
                row << product.get_descrip0[0..50]
                row << product.date1.strftime("%d/%m/%Y")
                row << product.date2.strftime("%d/%m/%Y")
                row << product.date3.strftime("%d/%m/%Y")

                if product.moneda_id == 1 
                    row << "0.00 "
                    row << sprintf("%.2f",product.total_amount.to_s)
                    total_dolares  += product.total_amount 
               
                else
                    row << sprintf("%.2f",product.total_amount.to_s)
                    row << "0.00 "
                    total_soles += product.total_amount  
                end 
                row << product.get_destino 
                row << product.user.username 
                row << product.get_observacion 
                row << product.payment.descrip 
                row << "   "
                
                table_content << row

                nroitem = nroitem + 1

            end 
           

      end 
    end 

        lcProveedor = @facturas_rpt.last.supplier_id 

            
            
         
        
              
          
          row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          
          row << "TOTALES => "
          row << ""
          
          row << ""
          
          row << ""
          row << sprintf("%.2f",total_soles.to_s)
          row << sprintf("%.2f",total_dolares.to_s)                    
          row << " "
          row << " "
          row << " "
          row << " "
          row << " "





          
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
                                          columns([5]).width = 40                                                                           
         
                                          columns([6]).width = 40                                                                           
         
                                          columns([7]).align=:right
                                          columns([7]).width = 40
                                          
                                          columns([8]).align=:right 
                                          columns([8]).width =40
                                          
                                          columns([9]).align=:right 
                                          columns([9]).width =40
                                          
                                          columns([10]).align=:left
                                          columns([10]).width =80
                                          columns([12]).width =80
                                          
                                          
                                        end                                          
                                        
      pdf.move_down 50





     
      pdf 

    end

    def build_pdf_footer_rpt8a(pdf)      

      table_content3 =[]
      row = []
      row << "--------------------------------------------"
      row << "--------------------------------------------"
      row << "--------------------------------------------"
      
      table_content3 << row 
      row = []
      row << "V.B.COMPRAS "
      row << "V.B.GERENCIA"
      row << "V.B.CONTABILIDAD"
      
      table_content3 << row 

      
          result = pdf.table table_content3, {:position => :center,
                                        :header => true,  :cell_style => {:border_width => 0},
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:center
                                          columns([2]).align=:center 
                                          
                                        end                             

      pdf      
  end


def rpt_purchase60

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
  
    @fecha6  = params[:fecha6]   
   
     @supplier_check = params[:check_supplier] 


    if @supplier_check == "true"
      @proveedor = ""
      @proveedor_name = ""
    else
      @proveedor = params[:proveedor]
      @proveedor_name =  @company.get_supplier_name(@proveedor)
    end
    
    @facturas_rpt = @company.get_purchases_day(@fecha1,@fecha2,@proveedor,@fecha6) 



        Prawn::Document.generate "app/pdf_output/TP_CM_F_015.pdf" , :page_layout => :landscape ,:page_size=>"A4"  do |pdf|
            pdf.font "Helvetica"
            pdf = build_pdf_header_rpt8b(pdf)
            pdf = build_pdf_body_rpt8b(pdf)
            build_pdf_footer_rpt8b(pdf)
            $lcFileName =  "app/pdf_output/TP_CM_F_015.pdf"              
        end     
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
        send_file("app/pdf_output/TP_CM_F_015.pdf", :type => 'application/pdf', :disposition => 'inline')    
 
  end




###################################################################################################
##REPORTE DE COMPRAS FACTURAS CREDITOS 1
###################################################################################################


  def build_pdf_header_rpt8b(pdf)
      pdf.font "Helvetica" , :size => 8
      image_path = "#{Dir.pwd}/public/images/tpereda2.png"

    
      
       table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD OCUPACIONAL",:rowspan => 2},"CODIGO ","TP-CM-F-015 "], 
          ["VERSION: ","3"], 
          ["REPORTE DE FACTURAS - LIMA ","Pagina: ","1 de 1 "] 
         
          ])
      



       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 451.34
            columns([1]).align = :center
            
            columns([2]).width = 100
          
            columns([3]).width = 100
      
         end
        
         table_content2 = ([["Fecha : ",Date.today.strftime("%d/%m/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

     
         pdf.text "(1) del "+@fecha1+" al "+@fecha2
         
         pdf.move_down 2
      
      pdf 
  end   

  def build_pdf_body_rpt8b(pdf)

    puts "tipo "
    puts @tipo 
    
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS31.each do |header|
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
      total_soles = 0
      total_dolares =  0

      lcDoc='FT'      

      if @facturas_rpt.count > 0 

       lcCliente = @facturas_rpt.first.supplier_id
       row = []

       for  product in @facturas_rpt

        
            if  product.supplier_id != 1731             
                fechas2 = product.date2 
                 
                row = []          
                row << nroitem.to_s 
                row << product.supplier.name 
                row << product.document.descripshort 
              
                
                row << product.documento 
                row << product.get_descrip0[0..50]
                row << product.date1.strftime("%d/%m/%Y")
                row << product.date2.strftime("%d/%m/%Y")
                row << product.date3.strftime("%d/%m/%Y")

                if product.moneda_id == 1 
                    row << "0.00 "
                    row << sprintf("%.2f",product.total_amount.to_s)
                    total_dolares  += product.total_amount 
               
                else
                    row << sprintf("%.2f",product.total_amount.to_s)
                    row << "0.00 "
                    total_soles += product.total_amount  
                end 
                row << product.get_destino 
                row << product.user.username 
                row << product.get_observacion 
                row << product.payment.descrip 
                row << "   "
                
                table_content << row

                nroitem = nroitem + 1

            end 
           

      end 
    end 

        lcProveedor = @facturas_rpt.last.supplier_id 

            
            
         
        
              
          
          row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          
          row << "TOTALES => "
          row << ""
          
          row << ""
          
          row << ""
          row << sprintf("%.2f",total_soles.to_s)
          row << sprintf("%.2f",total_dolares.to_s)                    
          row << " "
          row << " "
          row << " "
          row << " "
          row << " "





          
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
                                          columns([5]).width = 40                                                                           
         
                                          columns([6]).width = 40                                                                           
         
                                          columns([7]).align=:right
                                          columns([7]).width = 40
                                          
                                          columns([8]).align=:right 
                                          columns([8]).width =40
                                          
                                          columns([9]).align=:right 
                                          columns([9]).width =40
                                          
                                          columns([10]).align=:left
                                          columns([10]).width =80
                                          columns([12]).width =80
                                          
                                          
                                        end                                          
                                        
      pdf.move_down 50





     
      pdf 

    end

    def build_pdf_footer_rpt8b(pdf)      

      table_content3 =[]
      row = []
      row << "--------------------------------------------"
      row << "--------------------------------------------"
      row << "--------------------------------------------"
      
      table_content3 << row 
      row = []
      row << "V.B.COMPRAS "
      row << "V.B.GERENCIA"
      row << "V.B.CONTABILIDAD"
      
      table_content3 << row 

      
          result = pdf.table table_content3, {:position => :center,
                                        :header => true,  :cell_style => {:border_width => 0},
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:center
                                          columns([2]).align=:center 
                                          
                                        end                             

      pdf      
  end


######-----
def rpt_cpagar40 

    @company=Company.find(1)     
        
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @proveedor  = params[:supplier_id]
    @provee_existe = params[:check_prov]
    
  
      case params[:print]
        when "To PDF" then 
            redirect_to :action => "rpt_cpagar4_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2], :supplier_id=> params[:supplier_id],:id=>"1",:check_prov => params[:check_prov],:moneda_id => params[:moneda_id]
        when "To Excel" then render xlsx: 'rpt_cpagar4_xls'
         
        else render action: "index"
      end
 end 
  
  def rpt_cpagar4_pdf

    @company=Company.find(params[:id])      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @proveedor  = params[:supplier_id]
    @provee_existe = params[:check_prov]
    @moneda  = params[:moneda_id]


     if  @provee_existe == "true" || @provee_existe != nil 

       

          if @moneda == 2 
             @customerpayment_rpt = @company.get_supplier_payments0(@fecha1,@fecha2,@moneda)
             

          else 

             @customerpayment_rpt = @company.get_supplier_payments0(@fecha1,@fecha2,@moneda)
             
          end 
       
     else


        if @moneda == 2 

        @customerpayment_rpt = @company.get_supplier_payments01(@fecha1,@fecha2,@proveedor,@moneda )


        
        else

        @customerpayment_rpt = @company.get_supplier_payments01(@fecha1,@fecha2,@proveedor,@moneda )

        
        end 
       
     end 


    Prawn::Document.generate("app/pdf_output/rpt_supplierpayment2.pdf") do |pdf|        

        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt3(pdf)
        pdf = build_pdf_body_rpt3(pdf)
        build_pdf_footer_rpt3(pdf)
        $lcFileName =  "app/pdf_output/rpt_supplierpayment2.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end




  def build_pdf_header_rpt3(pdf)
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

 def build_pdf_body_rpt3(pdf)
    
    pdf.text "Liquidacion de Cancelaciones :    Fecha "+@fecha1.to_s+ " Mes : "+@fecha2.to_s , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []
      total_general = 0
      total_factory = 0
      total_debe  = 0
      total_haber = 0

      SupplierPayment::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end
      table_content << headers
      nroitem = 1


       for  customerpayment_rpt in @customerpayment_rpt

        #@fechacobro = customerpayment_rpt.fecha1
          $lcDocumento = ""   
        row = []
         row << nroitem.to_s
         row << customerpayment_rpt.code
         row << customerpayment_rpt.fecha1.strftime("%d/%m/%Y")         
         row << customerpayment_rpt.get_moneda(customerpayment_rpt.bank_acount.moneda_id)   
         row << customerpayment_rpt.get_document(customerpayment_rpt.document_id)    
         row << customerpayment_rpt.documento 
         row << customerpayment_rpt.supplier.ruc
         row << customerpayment_rpt.supplier.name    
         row << " "
         row << customerpayment_rpt.total    
         table_content << row
         total_debe += customerpayment_rpt.total    
                
        @customerdetails =  customerpayment_rpt.get_payments()

        if @customerdetails

           for  productItem in  @customerdetails
                
                row = []
                row <<  nroitem.to_s
                row << " "
                row << " "
                row << " "
                row <<  productItem.get_document(productItem.document_id)   
                row <<  productItem.documento
                row <<  productItem.get_supplier_ruc(productItem.supplier_id)
                row <<  productItem.get_supplier(productItem.supplier_id)
                row <<  sprintf("%.2f",productItem.total.to_s)
                row << " "
                total_haber += productItem.total  
                table_content << row

                nroitem=nroitem + 1
             
            end
        end 

      

       

       end  
      
      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << "TOTALES => "
      row << sprintf("%.2f",total_debe.to_s)
      row << sprintf("%.2f",total_haber.to_s)                    
      
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
                                          columns([5]).align=:left
                                          columns([6]).align=:left
                                          columns([7]).align=:left 
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                          columns([10]).align=:right
                                        end                                          
      pdf.move_down 10      
      pdf
      
    end 

  


    def build_pdf_footer_rpt3(pdf)      

         table_content2 = []

    
        row =[]  
        row << "   " 
        row << "   " 
        row << "   " 
        row << "   " 
        table_content2 << row

       

      

          row =[]  
        row << "---------------------------------------------------   " 
        row << "---------------------------------------------------   " 
        row << "---------------------------------------------------   " 
        row << "---------------------------------------------------  " 
        table_content2 << row

         row =[] 
    
        row << "Procesado por: "
        row << "V.B.Contador : "
        row << "V.B.Administracion : "
        row << "V.B.Gerencia : "

    
        table_content2 << row


          result = pdf.table table_content2, {:position => :center,
                                        :header => true,  :cell_style => {:border_width => 0},
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([0]).width = 135
                                        
                                          
                                          columns([1]).align=:center
                                           columns([1]).width = 135
                                          columns([2]).align=:center
                                           columns([2]).width = 135
                                          columns([3]).align=:center
                                           columns([3]).width = 135
                                        end                            
          
      
    
        pdf
      
end


#####################################################################################################

 def do_gestion

    @company = Company.find(1)

    @detalle_rq = Requerimiento.find_by_sql(['Select requerimientos.*,rqdetails.id,rqdetails.requerimiento_id, rqdetails.codigo,rqdetails.qty,rqdetails.unidad_id,rqdetails.descrip,rqdetails.placa_destino from rqdetails INNER JOIN requerimientos ON rqdetails.requerimiento_id = requerimientos.id where requerimientos.processed = ? and rqdetails.atento is null  order by code,fecha desc',"1"])



    return @detalle_rq



 end 
#### FACTURAS POR PROVEEDOR ###################


  def rpt01
  
     @company= Company.find(1)   
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @tiporeporte =params[:tiporeporte]
    @proveedor = params[:proveedor]
    
    @facturas_rpt = @company.get_purchases_day_tipo2(@fecha1,@fecha2,@tiporeporte,@proveedor)

    
    case params[:print]
      when "PDF" then 
          redirect_to :action => "rpt_purchase_all2b", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2], :tipo_reporte => params[:tiporeporte] ,:proveedor => params[:proveedor ],:id => 1  
          
      when "Excel" then render xlsx: 'rpt_purchase_all2b'
        
      else render action: "index"
    end
  end


  # Export serviceorder to PDF
  def rpt_purchase_all2b

    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @tiporeporte =params[:tipo_reporte]
    @proveedor = params[:proveedor]
    
    @facturas_rpt = @company.get_purchases_day_tipo2(@fecha1,@fecha2,@tiporeporte,@proveedor)

        Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
            pdf.font "Helvetica"
            pdf = build_pdf_header_rpt82(pdf)
            pdf = build_pdf_body_rpt82(pdf)
            build_pdf_footer_rpt82(pdf)
            $lcFileName =  "app/pdf_output/rpt_factura_all.pdf"              
        end     
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
        send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')    
 
  end
###+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##### reporte de factura emitidas

  def build_pdf_header_rpt82(pdf)
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

  def build_pdf_body_rpt82(pdf)
    
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

      if !@facturas_rpt.first.present? 
        row = []          
            row << ""
            row << ""
            row << ""
            row << ""
            row << "NO HAY REGISTROS PARA CLIENTE SELECCIONADO."
            row << "" 
            row << ""
            row << "" 
            row << ""
            row << ""
            table_content << row
      else 

       lcCliente = @facturas_rpt.first.supplier_id

       for  product in @facturas_rpt
        
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
            row << product.document.descripshort
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
      pdf 

    end

    def build_pdf_footer_rpt82(pdf)      
                  
      pdf.text "..."
      pdf.bounding_box([0, 20], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]
    end
    pdf      
  end

###+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  
  private
  def factura_params
    params.require(:factura).permit(:company_id,:location_id,:division_id,:customer_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:payment_id,:fecha,:preciocigv,:tipo,:observ,:moneda_id,:detraccion,:factura2,:description,:document_id,:tipoventa_id,:contrato,:ost,:manifest_id,:os_customer )
  end

end


