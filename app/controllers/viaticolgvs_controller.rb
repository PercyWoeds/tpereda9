

include UsersHelper
require "open-uri"


class ViaticolgvsController < ApplicationController

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
        when "To Excel" then render xlsx: 'rpt_viatico_xls'
        else render action: "index"
      end
  end
  
     
  def build_pdf_header(pdf)

      pdf.font "Helvetica"  , :size => 8
     image_path = "#{Dir.pwd}/public/images/tpereda2.png"


     
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD EN EL TRABAJO ",:rowspan => 2},"CODIGO ","TP-FZ-F-018"], 
          ["VERSION: ","4"], 
          ["LIQUIDACION DE CAJA-LGV " +  @viaticolgv.code,"Pagina: ","1 de 1 "] 
         
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
         table_content2 = ([["Fecha : ",@viaticolgv.fecha1.strftime("%d/%m/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
           
            
         end 

         pdf.move_down 2


          @viaticolgv_cout = @viaticolgv.get_comprobante_ingreso

       


          if  !@viaticolgv_cout.nil? 




               @viatico_cab =  @viaticolgv_cout.first



                if @viatico_cab.cout.tranportorder_id != 222

                  viatico_cab_ost =  @viatico_cab.cout.tranportorder.code
                else
                

                  viatico_cab_ost  = " "
                  
                end 

               viatico_cab_chofer  =   @viatico_cab.cout.employee.full_name2
               viatico_cab_chofer2 =   @viatico_cab.cout.get_employee(@viatico_cab.cout.employee2_id)
               viatico_cab_fecha1  =  @viatico_cab.cout.fecha1.strftime("%d/%m/%Y") 

               lcFechaSalida =  @viatico_cab.cout.fecha2.nil? ? " " : @viatico_cab.cout.fecha2.strftime("%d/%m/%Y")

               viatico_cab_fecha2  =  lcFechaSalida

               viatico_cab_placa  = @viatico_cab.cout.truck.placa 

               viatico_cab_desde  = @viatico_cab.cout.get_punto( @viatico_cab.cout.ubication_id)
               viatico_cab_hasta  = @viatico_cab.cout.get_punto( @viatico_cab.cout.ubication2_id)


          else

               viatico_cab_chofer  = ""
               viatico_cab_chofer2 = ""
               viatico_cab_fecha1  = ""
          

               viatico_cab_fecha2  = ""

               viatico_cab_placa   = ""

               viatico_cab_desde   = ""
               viatico_cab_hasta   = ""
          
          end   



         

         table_content3 = ([ ["Chofer:  ",viatico_cab_chofer , "OST:", viatico_cab_ost ],
                             ["Apoyo :  ",viatico_cab_chofer2, "Fecha Salida: " , viatico_cab_fecha1  ],
                             ["Placa :  ",viatico_cab_placa, "Fecha Llegada: ", lcFechaSalida  ],
                             ["Desde :  ",viatico_cab_desde , "Hasta: " , viatico_cab_hasta  ],
          ])

         pdf.table(table_content3,{:position=>:right, :width => pdf.bounds.width  } ) do

            columns([0, 2]).font_style = :bold
            columns([0, 2]).width = 100
            
         end 

         pdf.move_down 2
      
         pdf 
  end   

  def build_pdf_body(pdf)
  
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 8
    pdf.text "FECHA :" << @viaticolgv.fecha1.strftime("%d/%m/%Y")  <<    "           CAJA :" << @viaticolgv.caja.descrip  ,:style => :bold;  
    pdf.text "SALDO ANTERIOR :" << sprintf("%.2f",@viaticolgv.inicial) ,:style => :bold;
    pdf.font "Helvetica" , :size => 6      
      headers = []
      table_content = []

      viaticolgv::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

      
       for  product in @viaticolgv.get_viaticos_cheque() 
              

              puts "dddd" 

             puts product.egreso_id   

            puts product.detalle

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


            
    
       for  product in @viaticolgv.get_viaticos_lima() 
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
    
       for  product in @viaticolgv.get_viaticos_provincia() 
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



      Viaticolgv::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers_ing  << cell
      end

      table_content_ing << headers_ing 

  
       nroitem = 1
       @total_importe = 0


        for  egresos  in @viaticolgv.get_ingresos() 


         @detalle_ing = egresos.get_detalle_egresolgv(@viaticolgv.id,egresos.id)


            table_content = ([ [egresos.name  ]   ])
            

             pdf.table(table_content  ,{
                 :position => :center,
                 :width => pdf.bounds.width
               })do
                 columns([0]).font_style = :bold
                
                 columns([0]).align = :center
                
               end


          #SALDO INICIAL 
            @viatico_last = Viaticolgv.where("id < ? ", @viaticolgv.id).order("id DESC").first # last - 1

          row = []
          total_content_ing = []

          row << ""    
          row << ""
           if !@viatico_last.nil?
          row << "SALDO ANTERIOR AL " + @viatico_last.fecha1.to_date.to_s 
        else 
            row << "SALDO ANTERIOR  " 
        end 
          row << ""
           row << ""
           row << sprintf("%.2f",@viaticolgv.inicial)
           row << ""

        
         
          table_content_ing << row

            @total_importe   +=  @viaticolgv.inicial 
              
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
       for  egresos  in @viaticolgv.get_egresoslgv() 


         @detalle = egresos.get_detalle_egresolgv(@viaticolgv.id,egresos.id)

        
         

            table_content = ([ [egresos.name + " " + egresos.extension  ]   ])
            

             pdf.table(table_content  ,{
                 :position => :center,
                 :width => pdf.bounds.width
               })do
                 columns([0]).font_style = :bold
                
                 columns([0]).align = :left
                
               end

              
                  table_content2 = []
                  headers = []

              Viaticolgv::TABLE_HEADERS.each do |header|
                cell = pdf.make_cell(:content => header)
                cell.background_color = "FFFFCC"
                headers << cell
              end

              table_content2 << headers



             
                total_importe = 0

              
          for product in @detalle 

          
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


       

       #resumen 

       end 
       
       

      pdf.move_down 10  
      pdf

    end

    def build_pdf_footer(pdf)


 pdf.move_down 10  

    @viaticolgv_cout = @viaticolgv.get_comprobante_ingreso 




if  !@viaticolgv_cout.nil? 


  total_comp = 0 

  table_content1 =  []

   row = []


    @viaticolgv_cout.each do |product|
       
             
            row = []
              if product.cout.carr != "0"   
        
              row << "Viaticos por rendir "       
              else 
              row << "Entregado en ruta  "       
              end 
        
              row << product.document.descripshort +  product.numero

              row << product.fecha.strftime("%d/%m/%Y") 
              row  <<  product.importe.round(2) 

                table_content1 << row 


              total_comp += product.importe.round(2)   

      end

    

          row = []
            


        row << "Total a rendir   "

        row  << ""

        row  << ""

        row <<  total_comp.round(2)



 else 
        row << "No hay comprobantes"
  end

 table_content1 << row


 result = pdf.table table_content1, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width/2
                                        } do 
                                        
                                                                             
                                         columns([0]).width = 100 
                                          columns([0]).font_style = :bold
                                          columns([0]).align = :right
                                          columns([1]).align = :right
                                          columns([3]).align = :right
                  
                                        end 

 pdf.move_down 10  


 table_content2 =  []

  row = []

   row << "Gastos Realizados. " 
   row << ""
   row << ""
   row << @viaticolgv.total_egreso.round(2)
   table_content2 << row


   row = []

   row << "Vuelto. " 
   row << ""
   row << @viaticolgv.fecha_devuelto.strftime("%d/%m/%Y")
   row << @viaticolgv.cdevuelto_importe 
   table_content2 << row

   row = []

   row << "Descuento del chofer. " 
   row << ""
   row << @viaticolgv.fecha_descuento.strftime("%d/%m/%Y")
   row << @viaticolgv.cdescuento_importe 
   table_content2 << row


   row = []

   row << "Reembolso del chofer  " 
   row << ""
   row << @viaticolgv.fecha_reembolso.strftime("%d/%m/%Y")
   row << @viaticolgv.creembolso_importe 
   table_content2 << row



 result = pdf.table table_content2, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width/2
                                        } do 
                                        
                                                                             
                                         columns([0]).width = 100 
                                          columns([0]).font_style = :bold
                                          columns([0]).align = :left
                                          columns([1]).align = :right
                                           columns([3]).align = :right
                                        end 



 # pdf.move_down 10  
    
      
 #      total_egresos = 0
 #      table_content_footer = []
 #    for  egresos  in @viaticolgv.get_egresos_suma() 

 #       total_egresos += egresos.total.round(2) 


 #       row =[]
 #       row << egresos.egreso.name 
 #       row << egresos.total.round(2)
 #       table_content_footer << row 

 #    end 

 #      row = []
 #      row << "TOTAL EGRESOS S/.:"
 #      row << sprintf("%.2f",total_egresos.round(2))

 #        table_content_footer << row 
 #         pdf.table(table_content_footer  ,{
 #                 :position => :center,
 #                 :width => pdf.bounds.width/3
 #               })do
 #                 columns([0]).font_style = :bold
                
 #                 columns([0]).align = :center
 #                 columns([0]).width = 100 
 #                  columns([0]).align = :left
 #                   columns([1]).align = :right
                  

 #               end




# row = []
# table_content_footer2=[]

# row << "DIFERENCIA S/.:"
# row << sprintf("%.2f",@total_importe - total_egresos)

#  pdf.move_down 10  


 # table_content_footer2 << row 

 #             pdf.table(table_content_footer2  ,{
 #                 :position => :center,
 #                 :width => pdf.bounds.width/3
 #               })do
 #                 columns([0]).font_style = :bold
                
 #                columns([0]).align = :center
 #                columns([0]).width = 100 
 #                columns([0]).align = :left
 #                columns([1]).align = :right
                  

 #               end


total_resumen = 0


table_content_footer3=[]

@detalle1 = @viaticolgv.get_viatico_suma

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
                 :position => :center,
                 :width => pdf.bounds.width/3
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
        pdf.draw_text "Company: #{@viaticolgv.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom ]

      end

      pdf
      
  end   
     
  # Export viaticolgv to PDF

  def pdf
    @viaticolgv = Viaticolgv.find(params[:id])
    company =@viaticolgv.company_id
    @company =Company.find(company)
  
    
     $lcFecha1= @viaticolgv.fecha1.strftime("%d/%m/%Y") 
     $lcMon   = @viaticolgv.get_moneda(1)
     $lcPay= ""
     $lcSubtotal=0
     $lcIgv=0
     $lcTotal=sprintf("%.2f",@viaticolgv.inicial)

     $lcDetracion=0
     $lcAprobado= @viaticolgv.get_processed 


    $lcEntrega5 =  "FECHA :"
    $lcEntrega6 =  $lcFecha1

    Prawn::Document.generate("app/pdf_output/#{@viaticolgv.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body_2(pdf)
        build_pdf_footer(pdf)
         $lcFileName =  "app/pdf_output/#{@viaticolgv.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end
  
  
  # Process an viaticolgv
  def do_process
    @viaticolgv = viaticolgv.find(params[:id])
    @viaticolgv[:processed] = "1"
    
    @viaticolgv.process
    
    flash[:notice] = "The viaticolgv order has been processed."
    redirect_to @viaticolgv
  end
  
  # Do send viaticolgv via email
  def do_email
    @viaticolgv = viaticolgv.find(params[:id])
    @email = params[:email]
    
    Notifier.viaticolgv(@email, @viaticolgv).deliver
    
    flash[:notice] = "The viaticolgv has been sent successfully."
    redirect_to "/viaticos/#{@viaticolgv.id}"
  end

  
  # Send viaticolgv via email
  def email
    @viaticolgv = viaticolgv.find(params[:id])
    @company = @viaticolgv.company
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
  
  
  def list_items2

    
    @company = Company.find(params[:company_id])
    items = params[:items2]
    items = items.split(",")
    items_arr = []
    @lgvs = []
    i = 0
    @total_inicial = 0
    total = 0 
    monto_inicial = 0
    $total_inicial= 0
    @viaticolgv_d = Viaticolgv.last 

    for item in items
      if item != ""
        parts = item.split("|BRK|")

        id      = parts[0]  
        monto_inicial = parts[1]
        
        product = Cout.find(id.to_i)
        
        product[:i] = i
        product[:importe] = monto_inicial.to_f
        product[:detalle] = product.employee.full_name 
        product[:observa] = product.truck.placa 
        
        total += product[:importe]
        
        @total_inicial  = total 

        @viaticolgv_d.actualiza(parts)

        $total_inicial= @total_inicial
        i += 1
      end
    end  

    render :layout => false
  end 


  def list_items3

    
    @viaticolgv = Viaticolgv.find(params[:viaticolgv_id])


    items = params[:items3]
    items = items.split(",")
    items_arr = []
    @lgvs = []
    i = 0
    @total_inicial = 0
    total = 0 
    monto_inicial = 0
    puts "items 3....."

    puts items   

    @viaticolgv_d = Viaticolgv.last 

    for item in items
      if item != ""
        parts = item.split("|BRK|")
       

          @viaticolgv.fecha_devuelto     = parts[1]
          @viaticolgv.fecha_descuento    = parts[2]
          @viaticolgv.fecha_reembolso    = parts[3]
          @viaticolgv.cdevuelto_importe  = parts[4]
          @viaticolgv.cdescuento_importe = parts[5]
          @viaticolgv.creembolso_importe = parts[6]
          @viaticolgv.save

      end
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
         @viaticolgvs = Viaticolgv.all.order('id DESC').paginate(:page => params[:page])
        if params[:search]
          @viaticolgvs = Viaticolgv.search(params[:search]).order('id DESC').paginate(:page => params[:page])
        else
          @viaticolgvs = Viaticolgv.all.order('id DESC').paginate(:page => params[:page]) 
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
    @company  = Company.find(1)     
    @viaticolgv = Viaticolgv.find(params[:id])
     @egresos = Egreso.where(["extension = ? or extension = ?", "LGV","ALL"]).order(:code)
    
    @viaticolgv_detail = @viaticolgv.viaticolgv_details
    
    
     respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @viaticolgv   }
    end
    
  end


  def new
    @pagetitle = "New viaticolgv"
    @action_txt = "Create"
    
    @viaticolgv = Viaticolgv.new
    @viaticolgv[:code] = ""
    
    @viaticolgv[:processed] = "0"
    
    @company = Company.find(params[:company_id])
    @viaticolgv.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @documents = @company.get_documents()
    @cajas = Caja.all 
    
    @gastos = Gasto.order(:descrip)
   
    @ac_user = getUsername()
    @viaticolgv[:fecha1] = Date.today 
    @viaticolgv[:user_id] = getUserId()
    
    @viaticolgv[:cdevuelto]  = 0 
    @viaticolgv[:cdescuento]  = 0
    @viaticolgv[:creembolso]  = 0

  end


  def update_inicial
    # updates songs based on artist selected
     @viaticos = viaticolgv.find(params[:viatico_caja_id])
     
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

      viaticolgv::TABLE_HEADERS4.each do |header|
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
    

      Prawn::Document.generate("app/pdf_output/rpt_caja.pdf") do |pdf|
      pdf.font "Helvetica"

      for viaticolgv in @viaticos_rpt do 

        @viaticolgv =  viaticolgv.find(viaticolgv.id) 
      
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
  
 
  
  # GET /viaticos/1/edit
  def edit
    @pagetitle = "Edit viaticolgv"
    @action_txt = "Update"
    
    @viaticolgv = viaticolgv.find(params[:id])
    
    @company = @viaticolgv.company
    @ac_caja = @viaticolgv.caja.descrip  
    @ac_user = @viaticolgv.user.username
    
    @documents = @company.get_documents()
    @cajas = Caja.all 
    @gastos = Gasto.order(:descrip)
       @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /viaticos
  # POST /viaticos.xml
  def create
    @pagetitle = "Nuevo viaticolgv"
    @action_txt = "Create"
    @cajas = Caja.all      
    @gastos = Gasto.order(:descrip)
    @company= Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @viaticolgv = Viaticolgv.new(viaticolgv_params)
    @company = Company.find(params[:viaticolgv][:company_id])
    
 

    begin
      @viaticolgv[:inicial] = @viaticolgv.get_total_inicial
    rescue
      @viaticolgv[:inicial] = 0
    end 
    
    begin
      @viaticolgv[:total_ing] = @viaticolgv.get_total_ing
    rescue 
      @viaticolgv[:total_ing] = 0
    end 
    begin 
      @viaticolgv[:total_egreso]=  @viaticolgv.get_total_sal
    rescue 
      @viaticolgv[:total_egreso]= 0 
    end 
    
    @viaticolgv[:saldo] = @viaticolgv[:inicial] +  @viaticolgv[:total_ing] - @viaticolgv[:total_egreso]
    
    if(params[:viaticolgv][:user_id] and params[:viaticolgv][:user_id] != "")
      curr_seller = User.find(params[:viaticolgv][:user_id])
      @ac_user = curr_seller.username
    end


      
    @viaticolgv[:code] = @viaticolgv.generate_viatico_number( @viaticolgv[:caja_id]) 

 

    respond_to do |format|
      if @viaticolgv.save
        # Create products for kit
        # Check if we gotta process the viaticolgv

     
        @viaticolgv.process()
       
        
        format.html { redirect_to(@viaticolgv, :notice => 'viaticolgv was successfully created.') }
        format.xml  { render :xml => @viaticolgv, :status => :created, :location => @viaticolgv }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @viaticolgv.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /viaticos/1
  # PUT /viaticos/1.xml
  def update
    @pagetitle = "Edit viaticolgv"
    @action_txt = "Update"
    
    @viaticolgv = Viaticolgv.find(params[:id])
    @company = @viaticolgv.company
    
    @company = Company.find(params[:viaticolgv][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @gastos = Gasto.order(:descrip)
     
    
    @viaticolgv[:inicial] = @viaticolgv.get_total_inicial 
    @viaticolgv[:total_ing] = @viaticolgv.get_total_ing
        begin 
      @viaticolgv[:total_egreso]=  @viaticolgv.get_total_sal
    rescue 
      @viaticolgv[:total_egreso]= 0 
    end 
    @viaticolgv[:saldo] = @viaticolgv[:inicial] +  @viaticolgv[:total_ing] - @viaticolgv[:total_egreso]
    
    if(params[:viaticolgv][:user_id] and params[:viaticolgv][:user_id] != "")
      curr_seller = User.find(params[:viaticolgv][:user_id])
      @ac_user = curr_seller.username
    end
     respond_to do |format|
      if @viaticolgv.update_attributes(viatico_params)
        # Create products for kit
        
        # Check if we gotta process the viaticolgv
        @viaticolgv.process()
         
        if @viaticolgv.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viaticolgv[:saldo]
          a.numero = @viaticolgv.correlativo2(@viaticolgv[:code])
          a.save
        end 
        if @viaticolgv.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viaticolgv[:saldo]
          a.numero = @viaticolgv.correlativo2(@viaticolgv[:code])
          a.save
        end 
        if @viaticolgv.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viaticolgv[:saldo]
          a.numero = @viaticolgv.correlativo2(@viaticolgv[:code])
          a.save
        end 
        if @viaticolgv.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viaticolgv[:saldo]
          a.numero = @viaticolgv.correlativo2(@viaticolgv[:code])
          a.save
        end 
       
        if @viaticolgv.caja_id == 7 
          a = @cajas.find(7)
          a.inicial =  @viaticolgv[:saldo]
          a.numero = @viaticolgv.correlativo2(@viaticolgv[:code])
          a.save
        end 

        
        format.html { redirect_to(@viaticolgv, :notice => 'viaticolgv was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @viaticolgv.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /viaticos/1
  # DELETE /viaticos/1.xml
  def destroy
    @viaticolgv = viaticolgv.find(params[:id])
    company_id = @viaticolgv[:company_id]
    @viaticolgv.destroy

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

  def reportes1


    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
   
    
    @cajas = @company.get_viaticolgv(@fecha1,@fecha2)          

    

    case params[:print]
      when "To PDF" then 
        begin 

       Prawn::Document.generate "app/pdf_output/rpt_caja_01.pdf", :page_layout => :landscape  ,:page_size=>"A4"   do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_1(pdf)
        pdf = build_pdf_body_1(pdf)
        build_pdf_footer_1(pdf)
        @lcFileName =  "app/pdf_output/rpt_caja_01.pdf"              
    end     
   

    send_file("app/pdf_output/rpt_caja_01.pdf", :type => 'application/pdf', :disposition => 'inline')


        end   


      when "To Excel" then render xlsx: 'rpt_caja_01'
      else render action: "index"
    end

  end  

  

#########################################################################


# reporte completo
  def build_pdf_header_1(pdf)
      
     pdf.font "Helvetica" , :size => 8
      image_path = "#{Dir.pwd}/public/images/tpereda2.png"

    
         
 table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION INTEGRADO ",:rowspan => 2},"CODIGO ","TP-FZ-F-033"], 
          ["VERSION: ","1"], 
          ["CONTROL DE LIQUIDACIÓN DE GASTOS DE VIAJE (LGV) - SERVICIOS LOCALES " + "#{@fecha1}"+ " AL " + "#{@fecha2}","Pagina: ","1 de 1 "] 
         
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

         pdf.move_down 2
      
      pdf 
  end   

  def build_pdf_body_1(pdf)
    
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 5

      headers = []
      table_content = []

      header_text = [ {content: "Text", colspan: 4}]


Viaticolgv::TABLE_HEADERS5.each do |header|


        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"


        headers << cell
      end


  table_content <<  headers 


  
      nroitem=1
      @tot_valor_referencial = 0
      @tot_monto_detraccion = 0
      @subtotal = 0
      @tax = 0
      @importe = 0 
      total_cancelado = 0
      total_pendiente = 0 

       for  product in @cajas
            rendido = 0

            puts "carr"
            puts  product.carr 

 
                   row = []
                 row << nroitem.to_s
                 row <<   product.code
                  product.fecha1.nil? ? row << "-" : row << product.fecha1.strftime("%d/%m/%Y")
                  product.fecha2.nil? ? row <<  "-" :  row << product.fecha2.strftime("%d/%m/%Y")

                 row <<   product.get_placa(product.truck_id).concat(" / ",product.get_placa(product.truck2_id))
                 row <<   product.get_punto(product.ubication_id).concat( " - " ,product.get_punto(product.ubication2_id))

                 row <<   product.get_empleado(product.employee_id)


                   product.tranportorder_id.nil?  ? row << "-" : row << product.get_ost(product.tranportorder_id)

                  product.carr == "0" ? row << product.code :  row << "-"

                  product.carr == "0" ? row <<  product.importe  : row << "-"

                  product.carr == "1" ? row << product.code : row << "-"
                  
                  product.carr == "1" ?  row << product.importe : row << "0.0"

                 row <<   sprintf("%.2f",product.total_egreso.to_s)

                 rendido = product.total_egreso - product.cdescuento_importe

               

                 row <<   sprintf("%.2f",rendido.to_s)

                 row <<    product.cdevuelto 

                 row <<   sprintf("%.2f",product.cdevuelto_importe.to_s)

                 row <<    product.cdescuento 

                 row <<   sprintf("%.2f",product.cdescuento_importe.to_s)
                 
                 row <<    product.creembolso  

                 row <<   sprintf("%.2f",product.creembolso_importe.to_s)

                 row <<  " "
                 row <<  " "
                 row <<  " "

                 table_content << row

               
                 nroitem +=  1

        end


       
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          
                                        end                                          
      pdf.move_down 10      
      pdf




    end

    def build_pdf_footer_1(pdf)
      
    
        table_content3 =[]
      row = []
      row << "--------------------------------------------"
      row << "--------------------------------------------"
      row << "--------------------------------------------"
      
      table_content3 << row 
      row = []
      row << " JEFE COMERCIAL  "
      row << " JEFE FINANZAS "
      row << " JEFE CONTABILIDAD"
      
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
########################################################################




  
  private
  def viaticolgv_params
    params.require(:viaticolgv).permit(:code, :fecha1, :inicial, :total_ing, :total_egreso, :saldo, :comments, :user_id, :company_id, :processed,:caja_id)
  end




end
