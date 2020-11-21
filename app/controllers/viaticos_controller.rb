
include UsersHelper
include CustomersHelper
include ProductsHelper
require "open-uri"

class ViaticosController < ApplicationController
before_filter :authenticate_user!

  def reportxls
    @company=Company.find(1)      
   
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    $caja_id = params[:caja_id]
    @viaticos_rpt = @company.get_viaticos0(@fecha1,@fecha2,$caja_id)    
    
    
      case params[:print]
        when "To PDF" then 
            redirect_to :action => "rpt_viatico_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2] 
        when "To Excel" then render xlsx: 'exportxls'
        else render action: "index"
      end
  end
  
     
  def build_pdf_header(pdf)

      pdf.font "Helvetica"  , :size => 8
     image_path = "#{Dir.pwd}/public/images/tpereda2.png"


     
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD EN EL TRABAJO ",:rowspan => 2},"CODIGO ","TP-FZ-F-018"], 
          ["VERSION: ","9"], 
          ["LIQUIDACION DE CAJA ","Pagina: ","1 de 1 "] 
         
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
         table_content2 = ([["Fecha : ",Date.today.strftime("%d/%m/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

         pdf.move_down 2

         table_content3 = ([["LIQ N°: ",@viatico.code ]])

         pdf.table(table_content3,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

         pdf.move_down 2
      
         pdf 
  end   

  def build_pdf_body(pdf)
  
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 8
    pdf.text "FECHA :" << @viatico.fecha1.strftime("%d/%m/%Y")  <<    "           CAJA :" << @viatico.caja.descrip  ,:style => :bold;  
    pdf.text "SALDO ANTERIOR :" << sprintf("%.2f",@viatico.inicial) ,:style => :bold;
    pdf.font "Helvetica" , :size => 6      
      headers = []
      table_content = []

      Viatico::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

      
       for  product in @viatico.get_viaticos_cheque() 
            row = []
            row << nroitem.to_s        
            row << product.fecha.strftime("%d/%m/%Y") 
            row << ""
            row << product.employee.full_name

            lccompro =  product.document.descripshort << "-" << product.numero  
            row << lccompro 
            if product.tm.to_i != 6
                row << " "
                row << sprintf("%.2f",product.importe)
            else
              row << sprintf("%.2f",product.importe)
            end
            if product.tm.to_i != 6
              lcDato = product.tranportorder.code << " - " << product.tranportorder.truck.placa<<" - " << product.tranportorder.get_placa(product.tranportorder.truck2_id)
              row << lcDato 
              row << product.detalle
              row << product.tranportorder.get_punto(product.tranportorder.ubication_id)
            else
              row << " "
              row << " "
              row << " "
              row << " "
            end 
            table_content << row
            nroitem=nroitem + 1      
       end 
       
            row = []
            row << ""
            row << ""
            row << ""
            row << "LIMA"
            
            table_content << row
    
       for  product in @viatico.get_viaticos_lima() 
            row = []
            row << nroitem.to_s        
            row << product.fecha.strftime("%d/%m/%Y") 
            row << product.tranportorder.employee.full_name   
            if product.supplier 
              row << product.supplier.name 
            else
              row << product.employee.full_name
            end 
            
            lccompro =  product.document.descripshort << "-" << product.numero  
            
            row << lccompro 
            
            if product.tm.to_i != 6
                row << " "
                row << sprintf("%.2f",product.importe)
    
            else
              row << sprintf("%.2f",product.importe)
              
            
            end
            
            if product.tm.to_i != 6
              lcDato = product.tranportorder.code << " - " << product.tranportorder.truck.placa<<" - " << product.tranportorder.get_placa(product.tranportorder.truck2_id)
              row << lcDato 
              row << product.detalle
              
              row << product.tranportorder.get_punto(product.tranportorder.ubication_id)
            else
              row << " "
              row << " "
              row << " "
              row << " "
                
            end 
            table_content << row
            nroitem=nroitem + 1      
        end
            row = []
            row << ""
            row << ""
            row << ""
            row << "PROVINCIA"
            
            table_content << row
    
       for  product in @viatico.get_viaticos_provincia() 
            row = []
            row << nroitem.to_s        
            row << product.fecha.strftime("%d/%m/%Y") 
            row << product.tranportorder.employee.full_name   
            if product.supplier 
              row << product.supplier.name 
            else
              row << product.employee.full_name
            end 
            
            lccompro =  product.document.descripshort << "-" << product.numero  
            
            row << lccompro  
            
            if product.tm.to_i != 6
                row << " "
                row << sprintf("%.2f",product.importe)
    
            else
              row << sprintf("%.2f",product.importe)
              
            
            end
            
            if product.tm.to_i != 6
              lcDato = product.tranportorder.code << " - " << product.tranportorder.truck.placa<<" - " << product.tranportorder.get_placa(product.tranportorder.truck2_id)
              row << lcDato 
              row << product.detalle
              
              row << product.tranportorder.get_punto(product.tranportorder.ubication_id)
            else
              row << " "
              row << " "
              row << " "
              row << " "
                
            end 
            table_content << row
            nroitem=nroitem + 1      
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
                                          columns([6]).align=:left  
                                          columns([7]).align=:left 
                                          columns([8]).align=:left 
                                          columns([9]).align=:left 
                                        end

      pdf.move_down 10  
      pdf

    end

  def build_pdf_body_2(pdf)
  
    pdf.text " ", :size => 13, :spacing => 4
    
      pdf.font "Helvetica" , :size => 5      
      headers = []
      table_content = []
      table_content0 = []
      table_content2 = []
      table_content3 = []

      headers_ing = []
      table_content_ing = []



      Viatico::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers_ing  << cell
      end

      table_content_ing << headers_ing 

  
       nroitem = 1
       @total_importe = 0


        for  egresos  in @viatico.get_ingresos() 

           puts egresos.name 

         @detalle_ing= egresos.get_detalle_egreso(@viatico.id,egresos.id)


            table_content = ([ [egresos.name  ]   ])
            

             pdf.table(table_content  ,{
                 :position => :center,
                 :width => pdf.bounds.width
               })do
                 columns([0]).font_style = :bold
                
                 columns([0]).align = :center
                
               end

              


          #SALDO INICIAL 

          row = []
          total_content_ing = []

          row << ""    
          row << ""
          row << "SALDO ANTERIOR AL " +@viatico.fecha1.to_date.to_s 
          row << ""
           row << ""
           row << sprintf("%.2f",@viatico.inicial)
           row << ""

        
         
          table_content_ing << row

            @total_importe   +=  @viatico.inicial 
              
          for product in @detalle_ing 

            row = []
            row << nroitem.to_s        
            row << product.fecha.strftime("%d/%m/%Y") 

            if product.supplier_id !=  2570 
              row <<  product.supplier.name
            else

              if  product.employee != 64
              row <<   product.employee.full_name
              end 
            end 

            row << product.document.descripshort 
            
            row << product.numero.to_s
         
            row << sprintf("%.2f",product.importe)

            @total_importe   +=  product.importe 

          
            row << product.detalle 
      
        
            table_content_ing << row


            nroitem=nroitem + 1     

          end 


      result = pdf.table table_content_ing , {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          
                                          columns([1]).align=:left 
                                         
                                          columns([2]).align=:left   
                                                                            
                                          columns([3]).align=:left 
                                          
                                          columns([4]).align=:left
                                         
                                          columns([5]).align=:right 
                                          
                                          columns([6]).align=:left  
                                          columns([6]).width = 180 
                                         
                                         
                                        end 
         

         pdf.move_down 1
         row =[]
         table_content_ing = []


         row << "TOTAL INGRESO S/."
         row << sprintf("%.2f",@total_importe)
         table_content_ing << row 

      result = pdf.table table_content_ing , {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width/3
                                        } do 
                                          columns([0]).align=:center
                                      
                                          columns([0]).align = :left
                                          columns([1]).align = :right

                                         
                                         
                                        end 



      end 


  
      


   pdf.move_down 10  
      ###EGRESOS 
       for  egresos  in @viatico.get_egresos() 


         @detalle = egresos.get_detalle_egreso(@viatico.id,egresos.id)

        
           if @detalle.count()>0 

            table_content = ([ [egresos.name  ]   ])
            

             pdf.table(table_content  ,{
                 :position => :center,
                 :width => pdf.bounds.width
               })do
                 columns([0]).font_style = :bold
                
                 columns([0]).align = :center
                
               end

              
                  table_content2 = []
                  headers = []

              Viatico::TABLE_HEADERS.each do |header|
                cell = pdf.make_cell(:content => header)
                cell.background_color = "FFFFCC"
                headers << cell
              end

              table_content2 << headers



             
                total_importe = 0

              
          for product in @detalle 

            puts 
            row = []
            row << nroitem.to_s        
            row << product.fecha.strftime("%d/%m/%Y") 

                if product.supplier_id !=  2570 
                  row <<  product.supplier.name
                else

                  if  product.employee != 64
                  row <<   product.employee.full_name
                  end 
                end 

            row << product.document.descripshort 
            
            row << product.numero 
         
            row << sprintf("%.2f",product.importe)

            total_importe   += product.importe.round(2)

            row << product.detalle 
      
        
            table_content2 << row

            nroitem=nroitem + 1     


          end 


          result = pdf.table table_content2, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                        
                                          columns([1]).align=:left 
                                          columns([2]).align=:left                                          
                                          columns([3]).align=:left 
                                          columns([4]).align=:left
                                          columns([5]).align=:right 
                                          columns([6]).align=:left  
                                            columns([6]).width = 180 
                                        
                                         
                                        end 

         row =[]
         table_content3 = []


         row << "TOTAL EGRESO S/."
         row << sprintf("%.2f",total_importe)
         table_content3 << row 

      result = pdf.table table_content3, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width/3
                                        } do 
                                        
                                                                             
                                         columns([0]).width = 100 
                 
                                          columns([0]).align = :left
                                          columns([1]).align = :right
                  
                                        end 


       end 

       #resumen 

       end 
       
       

      pdf.move_down 10  
      pdf

    end

    def build_pdf_footer(pdf)
      total_egresos = 0

      table_content_footer = []
    for  egresos  in @viatico.get_egresos_suma() 

       total_egresos += egresos.total.round(2) 


       row =[]
       row << egresos.egreso.name 
       row << egresos.total.round(2)
       table_content_footer << row 

    end 

      row = []
      row << "TOTAL EGRESOS S/.:"
      row << sprintf("%.2f",total_egresos.round(2))

        table_content_footer << row 
         pdf.table(table_content_footer  ,{
                 :position => :center,
                 :width => pdf.bounds.width/3
               })do
                 columns([0]).font_style = :bold
                
                 columns([0]).align = :center
                 columns([0]).width = 100 
                  columns([0]).align = :left
                   columns([1]).align = :right
                  

               end




         row = []
         table_content_footer2=[]
      row << "SALDO EN CAJA  S/.:"
      row << sprintf("%.2f",@total_importe - total_egresos)
        pdf.move_down 2

 table_content_footer2 << row 

             pdf.table(table_content_footer2  ,{
                 :position => :center,
                 :width => pdf.bounds.width/3
               })do
                 columns([0]).font_style = :bold
                
                 columns([0]).align = :center
                 columns([0]).width = 100 
                  columns([0]).align = :left
                   columns([1]).align = :right
                  

               end





 pdf.move_down 30
        
       data =[["----------------------------------------------------------","----------------------------------------------------------","----------------------------------------------------------"],
            ["Elaborado por ","V.B.","V.B."],
               
               ["Soledad Silvestre","Asistente de Gerencia","Gerente Administrativo"]
                ]

           
            pdf.text " "
            pdf.table(data  ,{
                 :position => :center,
                 :width => pdf.bounds.width,
                  :cell_style => {:border_width => 0},
               })do
                 columns([0,1,2]).font_style = :bold
                
                 columns([0]).align = :center
          
                  columns([1]).align = :center
                   columns([2]).align = :center
                  

               end

            pdf.move_down 10          
                  
        pdf.bounding_box([0, 20], :width => 538, :height => 50) do        
        pdf.draw_text "Company: #{@viatico.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom ]

      end

      pdf
      
  end   
     
  # Export viatico to PDF

  def pdf
    @viatico = Viatico.find(params[:id])
    company =@viatico.company_id
    @company =Company.find(company)
  
    
     $lcFecha1= @viatico.fecha1.strftime("%d/%m/%Y") 
     $lcMon   = @viatico.get_moneda(1)
     $lcPay= ""
     $lcSubtotal=0
     $lcIgv=0
     $lcTotal=sprintf("%.2f",@viatico.inicial)

     $lcDetracion=0
     $lcAprobado= @viatico.get_processed 


    $lcEntrega5 =  "FECHA :"
    $lcEntrega6 =  $lcFecha1

    Prawn::Document.generate("app/pdf_output/#{@viatico.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body_2(pdf)
        build_pdf_footer(pdf)
         $lcFileName =  "app/pdf_output/#{@viatico.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end
  
  
  # Process an viatico
  def do_process
    @viatico = Viatico.find(params[:id])
    @viatico[:processed] = "1"
    
    @viatico.process
    
    flash[:notice] = "The viatico order has been processed."
    redirect_to @viatico
  end
  
  # Do send viatico via email
  def do_email
    @viatico = Viatico.find(params[:id])
    @email = params[:email]
    
    Notifier.viatico(@email, @viatico).deliver
    
    flash[:notice] = "The viatico has been sent successfully."
    redirect_to "/viaticos/#{@viatico.id}"
  end

  
  # Send viatico via email
  def email
    @viatico = Viatico.find(params[:id])
    @company = @viatico.company
  end
  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    @total_pago1= 0
    i = 0
    total = 0 
    
    for item in items
      if item != ""
        parts = item.split("|BRK|")
     
        id = parts[0]
        quantity = parts[1]
        detalle  = parts[2]
        tm       = parts[3]
        inicial  = parts[4].to_f
        compro   = parts[5]
        fecha    = parts[6]
       
        product = Tranportorder.find(id.to_i)
        product[:i] = i
        product[:importe] = quantity.to_f
        product[:detalle] = detalle
        product[:tm] = tm
        product[:comprobante] = compro
        product[:fecha] = fecha 
        
        if tm.to_i == 6
          total += product[:importe]
        else
          total -= product[:importe]
        end
        product[:CurrTotal] = total
        
        @total_pago1  = total     
        
        if inicial != nil
          @diferencia =  inicial + total 
        else
          @diferencia =  total 
        end
        
        @products.push(product)
        
      end
      
      i += 1
   end
    
    render :layout => false
  end
  
  # Autocomplete for documento
  def ac_documentos
    @products = Compro.where(["company_id = ? AND code LIKE ? ", params[:company_id], "%" + params[:q] + "%"])
    
    render :layout => false
  end
  # Autocomplete for documento
  def ac_osts
    @ost = Tranportorder.where(["company_id = ? AND code LIKE ? ", params[:company_id], "%" + params[:q] + "%"])
  
    render :layout => false
  end
  
  def ac_cajas
    @cajas = Caja.where(["descrip iLIKE ? ",  "%" + params[:q] + "%"])
  
    render :layout => false
  end
  
  # Autocomplete for employees
  def ac_employees
    @employees= Employee.where(["active= '1' and company_id = ? AND full_name ilike ? or idnumber LIKE ? ", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
  
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
    @suppliers =  Supplier.where(["company_id = ? AND (ruc LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  
  # Autocomplete for customers
  def ac_customers
    @customers = Customer.where(["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show viaticos for a company
  def list_viaticos
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Viaticos"
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
         @viaticos = Viatico.all.order('id DESC').paginate(:page => params[:page])
        if params[:search]
          @viaticos = Viatico.search(params[:search]).order('id DESC').paginate(:page => params[:page])
        else
          @viaticos = Viatico.all.order('id DESC').paginate(:page => params[:page]) 
        end
    
    else
      errPerms()
    end
  end
  
  # GET /viaticos
  # GET /viaticos.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'viaticos'
    @pagetitle = "viaticos"
  end

  # GET /viaticos/1
  # GET /viaticos/1.xml
  def show
    
    
    @viatico = Viatico.find(params[:id])
    
    @viatico_detail = @viatico.viatico_details
    
    
     respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @viatico   }
    end
    
  end


  def new
    @pagetitle = "New viatico"
    @action_txt = "Create"
    
    @viatico = Viatico.new
    @viatico[:code] = ""
    
    @viatico[:processed] = "0"
    
    @company = Company.find(params[:company_id])
    @viatico.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @documents = @company.get_documents()
    @cajas = Caja.all 
    
    @gastos = Gasto.order(:descrip)
    
    @ac_user = getUsername()
    @viatico[:fecha1] = Date.today 
    @viatico[:user_id] = getUserId()
    
    
  end

  def new2
    @pagetitle = "Nuevo Viatico"
    @action_txt = "Create"
    
    @viatico = Viatico.new
    @cajas = Caja.all 
    @company = Company.find(params[:company_id])
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @company = Company.find(params[:company_id])

    @viatico.company_id = @company.id    
   
  end


  def update_inicial
    # updates songs based on artist selected
     @viaticos = Viatico.find(params[:viatico_caja_id])
     
  end
  
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
    
    pdf.text "Listado: desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
    a=@viaticos_rpt.first
    pdf.text a.caja.descrip   
    pdf.font "Helvetica" , :size => 7

      headers = []
      table_content = []

      Viatico::TABLE_HEADERS4.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem = 1
      lcmonedasoles   = 2
      lcmonedadolares = 1



       for  product1 in @viaticos_rpt
       
            row = []
            row << " "
            row << "CODIGO :"
            row << "SALDO INICIAL"
            row << " "
            row << "TOTAL 
            INGRESOS"
            row << "TOTAL 
            EGRESOS"
            row << "SALDO"
            row << " "
            row << " "
            
            table_content << row
            
            row = []
            row << " "
            row << product1.code 
            row << product1.inicial
            row << " "
            row << product1.total_ing
            row << product1.total_egreso
            row << product1.saldo
              row << " "
              row << " "
            table_content << row
            
            
              for  product in product1.get_viaticos_cheque() 
                    row = []
                    row << nroitem.to_s        
                    row << product.fecha.strftime("%d/%m/%Y") 
                    
                    row << product.employee.full_name
                    lccompro =  product.document.descripshort << "-" << product.numero  
                    
                    row << lccompro 
                    if product.tm.to_i != 6
                        row << " "
                        row << sprintf("%.2f",product.importe)
                      else
                      row << sprintf("%.2f",product.importe)
                    end
                    if product.tm.to_i != 6
                      lcDato = product.tranportorder.code << " - " << product.tranportorder.truck.placa<<" - " << product.tranportorder.get_placa(product.tranportorder.truck2_id)
                      row << lcDato 
                      row << product.detalle
                      row << product.tranportorder.get_punto(product.tranportorder.ubication_id)
                      else
                      row << " "
                      row << " "
                      row << " "
                      row << " "
                    end 
                    table_content << row
                    nroitem=nroitem + 1      
        end 
       
            row = []
            row << ""
            row << ""
            row << ""
            row << "LIMA"
            row << ""
            row << ""
            row << ""
            row << ""
            row << ""
            table_content << row
    
       for  product in product1.get_viaticos_lima() 
            row = []
            row << nroitem.to_s        
            row << product.fecha.strftime("%d/%m/%Y") 
            
            if product.supplier 
              row << product.supplier.name 
            else
              row << product.tranportorder.employee.full_name   
            end             
            lccompro =  product.document.descripshort << "-" << product.numero              
            row << lccompro             
            if product.tm.to_i != 6
                row << " "
                row << sprintf("%.2f",product.importe)  
            else
              row << sprintf("%.2f",product.importe)
            end
            
            if product.tm.to_i != 6
              lcDato = product.tranportorder.code << " - " << product.tranportorder.truck.placa<<" - " << product.tranportorder.get_placa(product.tranportorder.truck2_id)
              row << lcDato 
              row << product.detalle              
              row << product.tranportorder.get_punto(product.tranportorder.ubication_id)
            else
              row << " "
              row << " "
              row << " "
              row << " "                
            end 
            table_content << row
            nroitem=nroitem + 1      
        end
            row = []
            row << ""
            row << ""
            row << ""
            row << "PROVINCIA"
            row << ""
            row << ""
            row << ""
            row << ""
            row << ""
            table_content << row
    
        for  product in product1.get_viaticos_provincia() 
            row = []
            row << nroitem.to_s        
            row << product.fecha.strftime("%d/%m/%Y") 
            
            if product.supplier 
              row << product.supplier.name 
            else
              row << product.tranportorder.employee.full_name   
            end             
            lccompro =  product.document.descripshort << "-" << product.numero            
            row << lccompro             
            if product.tm.to_i != 6
                row << " "
                row << sprintf("%.2f",product.importe)    
            else
              row << sprintf("%.2f",product.importe)
            end
            
            if product.tm.to_i != 6
              lcDato = product.tranportorder.code << " - " << product.tranportorder.truck.placa<<" - " << product.tranportorder.get_placa(product.tranportorder.truck2_id)
              row << lcDato 
              row << product.detalle
              
              row << product.tranportorder.get_punto(product.tranportorder.ubication_id)
            else
              row << " "
              row << " "
              row << " "
              row << " "
                
            end 
            table_content << row
            nroitem=nroitem + 1      
        end
            row = []
            row << " "
            row << " "
            row << " "
            row << " "
            row << " "
            row << " "
            row << " "
            row << " "
            row << " "
            
            table_content << row
    
        
          
      end
      
       result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([0]).width= 20
                                          columns([1]).align=:left
                                          columns([1]).width= 50
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left
                                          columns([4]).width= 60
                                          columns([5]).align=:left   
                                          columns([5]).width= 60
                                          columns([6]).align=:left
                                          columns([7]).align=:left
                                          columns([7]).width= 100
                                          columns([8]).align=:left
                                          columns([8]).width= 60
                                        end                                          
                                        
      pdf.move_down 10    
      pdf 

    end

    def build_pdf_footer_rpt2(pdf)      
                  
      pdf.text "" 
      pdf.bounding_box([0, 20], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

    end

    pdf
      
  end
  
  def rpt_viatico_pdf

    @company=Company.find(1)      
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    
    @viaticos_rpt = @company.get_viaticos0(@fecha1,@fecha2,$caja_id)    
    
     if @viaticos_rpt.size > 0 
    
      Prawn::Document.generate("app/pdf_output/rpt_pendientes.pdf") do |pdf|
      pdf.font "Helvetica"
      pdf = build_pdf_header_rpt2(pdf)
      pdf = build_pdf_body_rpt2(pdf)
      build_pdf_footer_rpt2(pdf)
  
      $lcFileName =  "app/pdf_output/rpt_pendientes.pdf"              
  
      $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
      send_file("app/pdf_output/rpt_pendientes.pdf", :type => 'application/pdf', :disposition => 'inline')
      end 
    
    end 

  end
  
 
  
  # GET /viaticos/1/edit
  def edit
    @pagetitle = "Edit viatico"
    @action_txt = "Update"
    
    @viatico = Viatico.find(params[:id])
    
    @company = @viatico.company
    @ac_caja = @viatico.caja.descrip  
    @ac_user = @viatico.user.username
    
    @documents = @company.get_documents()
    @cajas = Caja.all 
    @gastos = Gasto.order(:descrip)
    @viaticos_lines = @viatico.viaticos_lines
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /viaticos
  # POST /viaticos.xml
  def create
    @pagetitle = "Nuevo viatico"
    @action_txt = "Create"
    @cajas = Caja.all      
    @gastos = Gasto.order(:descrip)
    @company= Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @viatico = Viatico.new(viatico_params)
    @company = Company.find(params[:viatico][:company_id])
    
    
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
    
    if(params[:viatico][:user_id] and params[:viatico][:user_id] != "")
      curr_seller = User.find(params[:viatico][:user_id])
      @ac_user = curr_seller.username
    end
    

    respond_to do |format|
      if @viatico.save
        # Create products for kit
        # Check if we gotta process the viatico
 
        
        if @viatico.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viatico[:saldo]
          a.numero = @viatico.correlativo2(@viatico[:code])
          a.save
        end 
        if @viatico.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viatico[:saldo]
          a.numero = @viatico.correlativo2(@viatico[:code])
          a.save
        end 
        if @viatico.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viatico[:saldo]
          a.numero = @viatico.correlativo2(@viatico[:code])
          a.save
        end 
        if @viatico.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viatico[:saldo]
          a.numero = @viatico.correlativo2(@viatico[:code])
          a.save
        end 
        
        @viatico.process()
        @viatico.correlativo
        
        format.html { redirect_to(@viatico, :notice => 'viatico was successfully created.') }
        format.xml  { render :xml => @viatico, :status => :created, :location => @viatico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @viatico.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /viaticos/1
  # PUT /viaticos/1.xml
  def update
    @pagetitle = "Edit viatico"
    @action_txt = "Update"
    
    @viatico = Viatico.find(params[:id])
    @company = @viatico.company
    
    @company = Company.find(params[:viatico][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @gastos = Gasto.order(:descrip)
    
    
    @viatico[:inicial] = @viatico.get_total_inicial 
    @viatico[:total_ing] = @viatico.get_total_ing
        begin 
      @viatico[:total_egreso]=  @viatico.get_total_sal
    rescue 
      @viatico[:total_egreso]= 0 
    end 
    @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]
    
    if(params[:viatico][:user_id] and params[:viatico][:user_id] != "")
      curr_seller = User.find(params[:viatico][:user_id])
      @ac_user = curr_seller.username
    end
     respond_to do |format|
      if @viatico.update_attributes(viatico_params)
        # Create products for kit
        
        # Check if we gotta process the viatico
        @viatico.process()
         
        if @viatico.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viatico[:saldo]
          a.numero = @viatico.correlativo2(@viatico[:code])
          a.save
        end 
        if @viatico.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viatico[:saldo]
          a.numero = @viatico.correlativo2(@viatico[:code])
          a.save
        end 
        if @viatico.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viatico[:saldo]
          a.numero = @viatico.correlativo2(@viatico[:code])
          a.save
        end 
        if @viatico.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viatico[:saldo]
          a.numero = @viatico.correlativo2(@viatico[:code])
          a.save
        end 
        
        format.html { redirect_to(@viatico, :notice => 'viatico was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @viatico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /viaticos/1
  # DELETE /viaticos/1.xml
  def destroy
    @viatico = Viatico.find(params[:id])
    company_id = @viatico[:company_id]
    @viatico.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/viaticos/" + company_id.to_s) }
    end
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
 
  
  private
  def viatico_params
    params.require(:viatico).permit(:code, :fecha1, :inicial, :total_ing, :total_egreso, :saldo, :comments, :user_id, :company_id, :processed,:caja_id)
  end

end

