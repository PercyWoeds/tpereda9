class VueltosController < ApplicationController
  before_action :set_vuelto, only: [:show, :edit, :update, :destroy]

  # GET /vueltos
  # GET /vueltos.json
  def index
    @vueltos = Vuelto.all
  end

  # GET /vueltos/1
  # GET /vueltos/1.json
  def show

    @vuelto  = Vuelto.find(params[:id])
    
    @vuelto_detail =  @vuelto.vuelto_details
    
    
     respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vuelto   }
    end
  end

  # GET /vueltos/new
  def new
    @vuelto = Vuelto.new

    @company   =  Company.find(1)
    @vuelto[:fecha] = Date.today 

  end

  # GET /vueltos/1/edit
  def edit
    @company   =  Company.find(1)
  end

  # POST /vueltos
  # POST /vueltos.json
  def create
    @vuelto = Vuelto.new(vuelto_params)

     @vuelto[:code]  =   @vuelto.generate_viatico_number
     @vuelto[:user_id]  =  current_user.id 
     @vuelto[:processed]  =   "0"

     items = params[:items]  

    respond_to do |format|
      if @vuelto.save

       
        @vuelto.add_products(items)
        @vuelto.process()


        format.html { redirect_to @vuelto, notice: 'Vuelto was successfully created.' }
        format.json { render :show, status: :created, location: @vuelto }
      else
        format.html { render :new }
        format.json { render json: @vuelto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vueltos/1
  # PATCH/PUT /vueltos/1.json
  def update
    respond_to do |format|
      if @vuelto.update(vuelto_params)
        format.html { redirect_to @vuelto, notice: 'Vuelto was successfully updated.' }
        format.json { render :show, status: :ok, location: @vuelto }
      else
        format.html { render :edit }
        format.json { render json: @vuelto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vueltos/1
  # DELETE /vueltos/1.json
  def destroy
    @vuelto.destroy
    respond_to do |format|
      format.html { redirect_to vueltos_url, notice: 'Vuelto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def ac_couts 
    @couts = Cout.where([" (code  iLIKE ?)", "%" + params[:q] + "%"])
   
    render :layout => false
  end

  def list_items3
    
    @company = Company.find(1)
    items = params[:items3]
    items = items.split(",")
    items_arr = []
    @guias = []
    i = 0
    puts "item list items3 999999"
    puts items 
    
    for item in items
      if item != ""
        parts = item.split("|BRK|")

        puts parts

        id = parts[0]    
        importe =    parts[1]
        fechas =    parts[2]
        

        product = Cout.find(id.to_i)
        product[:i] = i
         product[:importe] = importe.to_f
         product[:fecha1] = fechas.to_date
        

        @guias.push(product)

      end
      
      i += 1
    end

    render :layout => false
  end 
  



  def pdf
    @vuelto =  Vuelto.find(params[:id])
    
    @company =Company.find(1)
    company =  @company.id
    
    Prawn::Document.generate "app/pdf_output/#{@vuelto.id}.pdf" , :page_layout => :landscape   do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body_2(pdf)
        build_pdf_footer(pdf)
        @lcFileName =  "app/pdf_output/#{@vuelto.id}.pdf"      
        
    end     

    @lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+@lcFileName
                
    send_file("#{@lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end

     
  def build_pdf_header(pdf)

      pdf.font "Helvetica"  , :size => 8
     image_path = "#{Dir.pwd}/public/images/tpereda2.png"


     
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD EN EL TRABAJO ",:rowspan => 2},"CODIGO ","TP-FZ-F-015"], 
          ["VERSION: ","2"], 
          ["INGRESO DE VUELTOS  ","PAGINA: ","1 de 1 "] 
         
          ])
      

       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
            columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 481.45
            columns([1]).align = :center
            columns([2]).align = :center
            columns([3]).align = :center

            columns([2]).width = 60

            columns([3]).width = 60

         end
        
      
        
         pdf.move_down 2
         table_content2 = ([["Fecha : ",@vuelto.fecha.strftime("%d/%m/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

         pdf.move_down 2

         table_content3 = ([["LIQ N°: ",@vuelto.code ]])

         pdf.table(table_content3,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

         pdf.move_down 2
      
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


      Vuelto::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers_ing  << cell
      end

      table_content2 << headers_ing 

  
       nroitem = 1
       @total_importe = 0

      @vuelto_detail =  @vuelto.vuelto_details

     

        for  product  in @vuelto_detail

           row = []

            row << nroitem.to_s 

            row << product.fecha.strftime("%d/%m/%Y") 

            row <<  product.cout.code 
        
            table_content2 << row

            @total_importe   += product.total.round(2)

            row <<  product.cout.employee.full_name
      
            row <<  product.cout.truck.placa + " / " + product.cout.get_placa(product.cout.truck2_id) +  product.cout.get_placa(product.cout.truck3_id) 
            
            row <<  product.cout.get_punto(product.cout.ubication_id) + "  -  "+ product.cout.get_punto(product.cout.ubication2_id) +" EJES:"+ product.cout.tranportorder.get_ejes2(product.cout.tranportorder.id) + "( TBK " + product.cout.tbk_documento + " )"

            row << "VUELTO DE VIAJE "
            row << sprintf("%.2f",product.importe)


            row << sprintf("%.2f",product.flete)


            row << sprintf("%.2f",product.egreso)


            row << sprintf("%.2f",product.total)

            row << " "

            row << "  "
            

        end 

      pdf.move_down 10  
      ###EGRESOS 




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
         
         row << "DEPOSITADO A LA CTA AHORRO    S/."
         row << sprintf("%.2f",@total_importe)
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

      
       
       

      pdf.move_down 10  
      pdf

    end
def build_pdf_footer(pdf)
  

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
      
      pdf
      
  end   
     



  def pdf2
    @vuelto =  Vuelto.find(params[:id])
    
    @company =Company.find(1)
    company =  @company.id
    
    Prawn::Document.generate "app/pdf_output/#{@vuelto.id}.pdf" , :page_layout => :landscape   do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header2(pdf)
        pdf = build_pdf_body2(pdf)
        build_pdf_footer2(pdf)
        @lcFileName =  "app/pdf_output/#{@vuelto.id}.pdf"      
        
    end     

    @lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+@lcFileName
                
    send_file("#{@lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end

     
  def build_pdf_header2(pdf)

      pdf.font "Helvetica"  , :size => 8
     image_path = "#{Dir.pwd}/public/images/tpereda2.png"


     
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD EN EL TRABAJO ",:rowspan => 2},"CODIGO ","TP-FZ-F-015"], 
          ["VERSION: ","2"], 
          ["RESUMEN SEMANAL DE VUELTOS DE VIAJE  ","PAGINA: ","1 de 1 "] 
         
          ])
      

       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
            columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 481.45
            columns([1]).align = :center
            columns([2]).align = :center
            columns([3]).align = :center

            columns([2]).width = 60

            columns([3]).width = 60

         end
        
      
        
         pdf.move_down 2
         table_content2 = ([["Fecha : ",@vuelto.fecha.strftime("%d/%m/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

         pdf.move_down 2

         table_content3 = ([["LIQ N°: ",@vuelto.code ]])

         pdf.table(table_content3,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

         pdf.move_down 2
      
         pdf 
  end   



  def build_pdf_body2(pdf)
  
    pdf.text " ", :size => 13, :spacing => 4
    
      pdf.font "Helvetica" , :size => 5      
      headers = []
      table_content = []
      table_content0 = []
      table_content2 = []
      table_content3 = []

      headers_ing = []
      table_content_ing = []


      Vuelto::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers_ing  << cell
      end

      table_content2 << headers_ing 

  
       nroitem = 1
       @total_importe = 0

      @vuelto_detail =  @vuelto.vuelto_details


 

      
       
       table_content = ([ [  {:content =>"VUELTOS ",:colspan => 2},{:content =>" " } ," " ,{:content =>"VUELTOS 01 ",:colspan => 2}  ], 
          ["DIA ","MONTO"," "," ","DIA ","MONTO"], 
          [@vuelto.fecha.strftime("%d/%m/%Y"), @vuelto.total ," "," "," "," "],
          [" " , " "," "," "," "," "],
          ["TOTAL S/. ", @vuelto.total ," "," ","TOTAL S/.  ", " "]
         
          ])
      

       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
            columns([0,1,4,5]).font_style = :bold
           
            
            columns([0]).align = :center
            columns([1]).align = :center
            columns([4]).align = :center
            columns([5]).align = :center

            columns([2]).width = 80

            columns([3]).width = 80

         end
        
      
      pdf.move_down 10  



       table_content = ([ [  {:content =>"INGRESO DE VUELTOS ",:colspan => 1},@vuelto.total  ], 
          ["INGRESO DE VUELTOS 01",""], 
          ["TOTAL DE SEMANA  ", @vuelto.total ],
          [" " , " "],
          ["OBSERV. ",  " " ]
         
          ])
      

       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width   / 3
         })do
            columns([0,1,4,5]).font_style = :bold
           
            
            columns([0]).align = :center
            columns([1]).align = :center
            columns([4]).align = :center
            columns([5]).align = :center

            columns([2]).width = 80

            columns([3]).width = 80

         end
        
      
      pdf.move_down 10  
      pdf

    end
def build_pdf_footer2(pdf)


      @valores =  @company.get_min_max(params[:id])

      if @valores.length > 1

        @valores_min = @valores.last.dmin.to_s
        @valores_max = @valores.last.dmax.to_s 


      else

        @valores_min = " " 
        @valores_max = " " 



      end 
      puts " ***********************************************  " 
      puts  @valores_min
      puts  @valores_max

 pdf.move_down 30
      
       pdf.text "Ingresos del " + @valores_min +   " al  " + @valores_max +"se Deposito el " + @vuelto.fecha.strftime("%d/%m/%Y"), size: 11 
       pdf.text "El voucher original se presente con el reporte " , size: 11 
        
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
      
      pdf
      
  end   
     

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vuelto
      @vuelto = Vuelto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vuelto_params
      params.require(:vuelto).permit(:code, :fecha, :user_id, :processed, :date_processed, :total)
    end
end
