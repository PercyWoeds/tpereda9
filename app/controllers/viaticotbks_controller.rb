
include UsersHelper
include CustomersHelper
include ProductsHelper
require "open-uri"


class ViaticotbksController < ApplicationController
before_filter :authenticate_user!

  def reportxls
    @company=Company.find(1)      
   
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    $caja_id = params[:caja_id]
    @viaticotbks_rpt = @company.get_viaticotbks0(@fecha1,@fecha2,$caja_id)    
    
    
      case params[:print]
        when "To PDF" then 
            redirect_to :action => "rpt_viaticotbk_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2] 
        when "To Excel" then render xlsx: 'rpt_viaticotbk_xls'
        else render action: "index"
      end
  end
  
     
  def build_pdf_header(pdf)

      pdf.font "Helvetica"  , :size => 8
     image_path = "#{Dir.pwd}/public/images/tpereda2.png"


     
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD EN EL TRABAJO ",:rowspan => 2},"CODIGO ","TP-FZ-F-018"], 
          ["VERSION: ","4"], 
          ["LIQUIDACION DE VIATICOS TELEBANKING ","Pagina: ","1 de 1 "] 
         
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
         table_content2 = ([["Fecha : ",@viaticotbk.fecha1.strftime("%d/%m/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

         pdf.move_down 2

         table_content3 = ([["LIQ N°: ",@viaticotbk.code ]])

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
    pdf.text "FECHA :" << @viaticotbk.fecha1.strftime("%d/%m/%Y")  <<    "           CAJA :" << @viaticotbk.caja.descrip  ,:style => :bold;  
    pdf.text "SALDO ANTERIOR :" << sprintf("%.2f",@viaticotbk.inicial) ,:style => :bold;
    pdf.font "Helvetica" , :size => 6      
      headers = []
      table_content = []

      viaticotbk::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

      
       for  product in @viaticotbk.get_viaticotbks_cheque() 
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
    
       for  product in @viaticotbk.get_viaticotbks_lima() 
            row = []
            row << nroitem.to_s        
            row << product.fecha.strftime("%d/%m/%Y") 
            row << product.tranportorder.employee.full_name   
            if product.supplier_id != 2570  
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
    
       for  product in @viaticotbk.get_viaticotbks_provincia() 
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



      Viaticotbk::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers_ing  << cell
      end

      table_content_ing << headers_ing 

  
       nroitem = 1
       @total_importe = 0


        for  egresos  in @viaticotbk.get_ingresos() 

           puts egresos.name 


         @detalle_ing= egresos.get_detalle_ingresotbk(@viaticotbk.id,egresos.id)


            table_content = ([ [egresos.name  ]   ])
            

             pdf.table(table_content  ,{
                 :position => :center,
                 :width => pdf.bounds.width
               })do
                 columns([0]).font_style = :bold
                
                 columns([0]).align = :center
                
               end


          #SALDO INICIAL 
            @viaticotbk_last = Viaticotbk.where("id < ? ", @viaticotbk.id).order("id DESC").first # last - 1

          row = []
          total_content_ing = []

          row << ""    
          row << ""
           if !@viaticotbk_last.nil?
          row << "SALDO ANTERIOR AL " + @viaticotbk_last.fecha1.to_date.to_s 
        else 
            row << "SALDO ANTERIOR  " 
        end 
          row << ""
           row << ""
           row << sprintf("%.2f",@viaticotbk.inicial)
           row << ""

        
         
          table_content_ing << row

            @total_importe   +=  @viaticotbk.inicial 
              
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
       for  egresos  in @viaticotbk.get_egresos_tbk() 


         @detalle = egresos.get_detalle_egresotbk(@viaticotbk.id,egresos.id)

        
         

            table_content = ([ [egresos.name + " " + egresos.extension  ]   ])
            

             pdf.table(table_content  ,{
                 :position => :center,
                 :width => pdf.bounds.width
               })do
                 columns([0]).font_style = :bold
                
                 columns([0]).align = :center
                
               end

              
                  table_content2 = []
                  headers = []

              Viaticotbk::TABLE_HEADERS5.each do |header|
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

          if product.cout_id.nil? 
          
            row << product.detalle

            row << " "
            row << " "

          else 
            
            row <<  product.cout.truck.placa + " /  " + product.cout.get_placa(product.cout.truck2_id) +  product.cout.get_placa(product.cout.truck3_id) 
            row <<  product.cout.get_punto(product.cout.ubication_id) + "  -  "+ product.cout.get_punto(product.cout.ubication2_id) +" EJES:"+ product.cout.tranportorder.get_ejes2(product.cout.tranportorder.id) + "( TBK " + product.cout.tbk_documento + " )"

            row <<   product.cout.tranportorder.code
            end 
      
        
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

                                          
                                        
                                          columns([5]).width = 50
                                          columns([6]).width = 60 
                                          columns([7]).width = 60
                                          columns([8]).width = 60
                                        end 

         row =[]
         table_content3 = []
         puts "tamaniooo"
         puts pdf.bounds.width
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


       

       #resumen 

       end 
       
       

      pdf.move_down 10  
      pdf

    end

    def build_pdf_footer(pdf)
      
      total_egresos = 0
      table_content_footer = []
    for  egresos  in @viaticotbk.get_egresos_suma() 

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
                  columns([6]).width = 60 
                  columns([7]).width = 60
                  columns([8]).width = 60
                  

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


total_resumen = 0


table_content_footer3=[]

@detalle1 = @viaticotbk.get_viaticotbk_suma

for detalle1 in @detalle1
row = []
row << detalle1.descripshort
row << sprintf("%.2f",detalle1.total)
table_content_footer3 << row 

 total_resumen +=  detalle1.total.round(2)
end

row = []

row << "TOTAL : "
row << sprintf("%.2f",total_resumen)
table_content_footer3 << row 

pdf.move_down 2

 

             pdf.table(table_content_footer3  ,{
                 :position => :left,
                 :width => pdf.bounds.width/4
               })do
                 columns([0]).font_style = :bold
                
                columns([0]).align = :center
               
                columns([0]).align = :left
                columns([1]).align = :right
                  
                 columns([1]).width = 100 
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
        pdf.draw_text "Company: #{@viaticotbk.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom ]

      end

      pdf
      
  end   
     
  # Export viaticotbk to PDF

  def pdf
    @viaticotbk =  Viaticotbk.find(params[:id])
    company =@viaticotbk.company_id
    @company =Company.find(company)
  
    
     $lcFecha1= @viaticotbk.fecha1.strftime("%d/%m/%Y") 
     $lcMon   = @viaticotbk.get_moneda(1)
     $lcPay= ""
     $lcSubtotal=0
     $lcIgv=0
     $lcTotal=sprintf("%.2f",@viaticotbk.inicial)

     $lcDetracion=0
     $lcAprobado= @viaticotbk.get_processed 


    $lcEntrega5 =  "FECHA :"
    $lcEntrega6 =  $lcFecha1

    Prawn::Document.generate("app/pdf_output/#{@viaticotbk.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body_2(pdf)
        build_pdf_footer(pdf)
         $lcFileName =  "app/pdf_output/#{@viaticotbk.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end
  
  
  # Process an viaticotbk
  def do_process
    @viaticotbk = viaticotbk.find(params[:id])
    @viaticotbk[:processed] = "1"
    
    @viaticotbk.process
    
    flash[:notice] = "The viaticotbk order has been processed."
    redirect_to @viaticotbk
  end
  
  # Do send viaticotbk via email
  def do_email
    @viaticotbk = viaticotbk.find(params[:id])
    @email = params[:email]
    
    Notifier.viaticotbk(@email, @viaticotbk).deliver
    
    flash[:notice] = "The viaticotbk has been sent successfully."
    redirect_to "/viaticotbks/#{@viaticotbk.id}"
  end

  
  # Send viaticotbk via email
  def email
    @viaticotbk = viaticotbk.find(params[:id])
    @company = @viaticotbk.company
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
  
  # Show viaticotbks for a company
  def list_viaticos
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - viaticotbks"
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
         @viaticotbks = Viaticotbk.all.order('id DESC').paginate(:page => params[:page])
        if params[:search]
          @viaticotbks = Viaticotbk.search(params[:search]).order('id DESC').paginate(:page => params[:page])
        else
          @viaticotbks = Viaticotbk.all.order('id DESC').paginate(:page => params[:page]) 
        end
    
    else
      errPerms()
    end
  end
  
  # GET /viaticotbks
  # GET /viaticotbks.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'viaticotbks'
    @pagetitle = "viaticotbks"
  @search = ViaticotbkSearch.new(params[:search])
  @search.scope 

  end

  # GET /viaticotbks/1
  # GET /viaticotbks/1.xml
  def show
    
    
    @viaticotbk = Viaticotbk.find(params[:id])
    
    @viaticotbk_detail = @viaticotbk.viaticotbk_details
     
     

   @search = ViaticotbkSearch.new(params[:search])
  
     respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @viaticotbk   }
    end
    
  end




  def new
    @pagetitle = "New viaticotbk"
    @action_txt = "Create"
    
    @viaticotbk = Viaticotbk.new
    @viaticotbk[:code] = ""
    
    @viaticotbk[:processed] = "0"
    
    @company = Company.find(params[:company_id])
    @viaticotbk.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @documents = @company.get_documents()
    @cajas = Caja.all 
    
    @gastos = Gasto.order(:descrip)
    
    @ac_user = getUsername()
    @viaticotbk[:fecha1] = Date.today 
    @viaticotbk[:user_id] = getUserId()

    
    
  end

  def new2
    @pagetitle = "Nuevo viaticotbk"
    @action_txt = "Create"
    
    @viaticotbk = Viaticotbk.new
    @cajas = Caja.all 
    @company = Company.find(params[:company_id])
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @company = Company.find(params[:company_id])

    @viaticotbk.company_id = @company.id    
   
  end


  def update_inicial
    # updates songs based on artist selected
     @viaticotbks = Viaticotbk.find(params[:viaticotbk_caja_id])
     
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
    a=@viaticotbks_rpt.first
    pdf.text a.caja.descrip   
    pdf.font "Helvetica" , :size => 7

      headers = []
      table_content = []

      Viaticotbk::TABLE_HEADERS4.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem = 1
      lcmonedasoles   = 2
      lcmonedadolares = 1



       for  product1 in @viaticotbks_rpt
       
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
            
            
              for  product in product1.get_viaticotbks_cheque() 
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
    
       for  product in product1.get_viaticotbks_lima() 
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
    
        for  product in product1.get_viaticotbks_provincia() 
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
  
  def rpt_viaticotbk_pdf

    @company=Company.find(1)      
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    
    @viaticotbks_rpt = @company.get_viaticotbks0(@fecha1,@fecha2,$caja_id)    
    
     if @viaticotbks_rpt.size > 0 
    

      Prawn::Document.generate("app/pdf_output/rpt_caja.pdf") do |pdf|
      pdf.font "Helvetica"

      for viaticotbk in @viaticotbks_rpt do 

        @viaticotbk =  viaticotbk.find(viaticotbk.id) 
      
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body_2(pdf)
        build_pdf_footer(pdf)
        
       end 
  
    
        
     
      end 

        $lcFileName =  "app/pdf_output/rpt_caja.pdf"    

       $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
      send_file("app/pdf_output/rpt_caja.pdf", :type => 'application/pdf', :disposition => 'inline')
    
    end 

  end
  
 
  
  # GET /viaticotbks/1/edit
  def edit
    @pagetitle = "Edit viaticotbk"
    @action_txt = "Update"
    
    @viaticotbk = Viaticotbk.find(params[:id])
    
    @company = @viaticotbk.company
    @ac_caja = @viaticotbk.caja.descrip  
    @ac_user = @viaticotbk.user.username
    
    @documents = @company.get_documents()
    @cajas = Caja.all 
    @gastos = Gasto.order(:descrip)
  
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /viaticotbks
  # POST /viaticotbks.xml
  def create
    @pagetitle = "Nuevo viaticotbk"
    @action_txt = "Create"
    @cajas = Caja.all      
    @gastos = Gasto.order(:descrip)
    @company= Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @viaticotbk = Viaticotbk.new(viaticotbk_params)
    @company = Company.find(params[:viaticotbk][:company_id])
    
 

    begin
      @viaticotbk[:inicial] = @viaticotbk.get_total_inicial
    rescue
      @viaticotbk[:inicial] = 0
    end 
    
    begin
      @viaticotbk[:total_ing] = @viaticotbk.get_total_ing
    rescue 
      @viaticotbk[:total_ing] = 0
    end 
    begin 
      @viaticotbk[:total_egreso]=  @viaticotbk.get_total_sal
    rescue 
      @viaticotbk[:total_egreso]= 0 
    end 
    
    @viaticotbk[:saldo] = @viaticotbk[:inicial] +  @viaticotbk[:total_ing] - @viaticotbk[:total_egreso]
    
    if(params[:viaticotbk][:user_id] and params[:viaticotbk][:user_id] != "")
      curr_seller = User.find(params[:viaticotbk][:user_id])
      @ac_user = curr_seller.username
    end


      
    @viaticotbk[:code] = @viaticotbk.generate_viaticotbk_number( @viaticotbk[:caja_id]) 

 

    respond_to do |format|
      if @viaticotbk.save
        # Create products for kit
        # Check if we gotta process the viaticotbk

     
        @viaticotbk.process()
       
        
        format.html { redirect_to(@viaticotbk, :notice => 'viaticotbk was successfully created.') }
        format.xml  { render :xml => @viaticotbk, :status => :created, :location => @viaticotbk }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @viaticotbk.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /viaticotbks/1
  # PUT /viaticotbks/1.xml
  def update
    @pagetitle = "Edit viaticotbk"
    @action_txt = "Update"
    
    @viaticotbk = Viaticotbk.find(params[:id])
    @company = @viaticotbk.company
    
    @company = Company.find(params[:viaticotbk][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @gastos = Gasto.order(:descrip)
    
    
    @viaticotbk[:inicial] = @viaticotbk.get_total_inicial 
    @viaticotbk[:total_ing] = @viaticotbk.get_total_ing
        begin 
      @viaticotbk[:total_egreso]=  @viaticotbk.get_total_sal
    rescue 
      @viaticotbk[:total_egreso]= 0 
    end 
    @viaticotbk[:saldo] = @viaticotbk[:inicial] +  @viaticotbk[:total_ing] - @viaticotbk[:total_egreso]
    
    if(params[:viaticotbk][:user_id] and params[:viaticotbk][:user_id] != "")
      curr_seller = User.find(params[:viaticotbk][:user_id])
      @ac_user = curr_seller.username
    end
     respond_to do |format|
      if @viaticotbk.update_attributes(viaticotbk_params)
        # Create products for kit
        
        # Check if we gotta process the viaticotbk
        @viaticotbk.process()
         
        if @viaticotbk.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viaticotbk[:saldo]
          a.numero = @viaticotbk.correlativo2(@viaticotbk[:code])
          a.save
        end 
        if @viaticotbk.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viaticotbk[:saldo]
          a.numero = @viaticotbk.correlativo2(@viaticotbk[:code])
          a.save
        end 
        if @viaticotbk.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viaticotbk[:saldo]
          a.numero = @viaticotbk.correlativo2(@viaticotbk[:code])
          a.save
        end 
        if @viaticotbk.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viaticotbk[:saldo]
          a.numero = @viaticotbk.correlativo2(@viaticotbk[:code])
          a.save
        end 
       if @viaticotbk.caja_id == 5 
          a = @cajas.find(5)
          a.inicial =  @viaticotbk[:saldo]
          a.numero = @viaticotbk.correlativo2(@viaticotbk[:code])
          a.save
        end 


        
        format.html { redirect_to(@viaticotbk, :notice => 'viaticotbk was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @viaticotbk.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /viaticotbks/1
  # DELETE /viaticotbks/1.xml
  def destroy
    @viaticotbk = Viaticotbk.find(params[:id])
    company_id = @viaticotbk[:company_id]
    @viaticotbk.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/viaticotbks/" + company_id.to_s) }
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
 

 def rpt_compras1_pdf
    @company=Company.find(1)      
   
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    
    @product = params[:ac_item_id]

    @products = @company.get_products_dato(@product)        

    @facturas_rpt = @company.get_ingresos_day(@fecha1,@fecha2,@product)


    if @facturas_rpt != nil 
    
      case params[:print]
       
        when "Excel" then render xlsx: 'rpt_compras1_xls'
    
          
        else render action: "index"
      end
    end 

    
  end

  def search

    @search = InvoiceSearch.new(params[:search])
 
    @datos = @search.Scope 



  end 


  
  private
  def viaticotbk_params
    params.require(:viaticotbk).permit(:code, :fecha1, :inicial, :total_ing, :total_egreso, :saldo, :comments, :user_id, :company_id, :processed,:caja_id,:search)
  end

end

