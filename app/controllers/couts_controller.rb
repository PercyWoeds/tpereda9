class CoutsController < ApplicationController
  before_action :set_cout, only: [:show, :edit, :update, :destroy]

  # GET /couts
  # GET /couts.json


  def index
    @couts = Cout.order(:code)
      @company = Company.find(1)
  end

  # GET /couts/1
  # GET /couts/1.json
  def show


    @company   = Company.find(1)

       @trucks = @company.get_trucks

      @employees = @company.get_employees2() 
      @puntos = @company.get_puntos()
  end

  # GET /couts/new
  def new
    @cout = Cout.new

    @company   = Company.find(1)

       @trucks = @company.get_trucks

      @employees = @company.get_employees2() 
      @puntos = @company.get_puntos()

      @cout[:fecha] = Date.today 

      @cout[:importe] = 0.00
      @cout[:tbk] = 0.00
      @cout[:tbk_documento] = ""


      @cout[:ost_exist] = "1"
      @cout[:employee4_id] = 64
      @cout[:tranportorder_id] = 10079


  end

  # GET /couts/1/edit
  def edit

      @company   = Company.find(1)

      @trucks = @company.get_trucks

      @puntos = @company.get_puntos()
     @employees = @company.get_employees2() 
  end

  # POST /couts
  # POST /couts.json
  def create

     @company   = Company.find(1)

    @cout = Cout.new(cout_params)


     @cout[:code] = @cout.generate_cout_number
     @puntos = @company.get_puntos()
     @employees = @company.get_employees2() 
     @trucks = @company.get_trucks

    respond_to do |format|
      if @cout.save
        format.html { redirect_to @cout, notice: 'Cout was successfully created.' }
        format.json { render :show, status: :created, location: @cout }
      else
        format.html { render :new }
        format.json { render json: @cout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /couts/1
  # PATCH/PUT /couts/1.json
  def update

     @company   = Company.find(1)
     @puntos = @company.get_puntos()
     @employees = @company.get_employees2() 
@trucks = @company.get_trucks

    respond_to do |format|
      if @cout.update(cout_params)
        format.html { redirect_to @cout, notice: 'Cout was successfully updated.' }
        format.json { render :show, status: :ok, location: @cout }
      else
        format.html { render :edit }
        format.json { render json: @cout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /couts/1
  # DELETE /couts/1.json
  def destroy

     @company   = Company.find(1)

    respond_to do |format|
       a = ViaticotbkDetail.find_by(:cout_id=> params[:id])
    if a 
        format.html { redirect_to couts_url, notice: 'Compronbante registrado en  Caja, no se puede eliminar' }
        format.json { render json: a.errors, status: :unprocessable_entity }
   else 
      @cout.destroy

      format.html { redirect_to couts_url, notice: 'Comprobante eliminado.' }
      format.json { head :no_content }
    end

  end

  end





def get_employee(id)

  a = Employee.find(id)

  return a.full_name 



end 

def update_compro




     ost = Tranportorder.find_by(params[:ost_code])
    # map to name and id for use in our options_for_select
  
     @puntos = Punto.where(id: ost.punto_id)
     @empleados = Employee.where(id: ost.empployee_id)
     @trucks  = Truck.where(id: ost.truck_id )



end

def do_crear

    @company = Company.find(1)

    @action_txt = "do_crear" 
    @tranportorder = Tranportorder.find(params[:id] ) 

    puts params[:total_importe]

    puts "checked "

   @placa = 376
   @placa2 =376
   @placa3 =376


    
        @employee_id = @tranportorder.employee_id
 
        @employee2_id = @tranportorder.employee2_id

        @employee3_id = @tranportorder.employee3_id
 
        @employee4_id = @tranportorder.employee4_id
   

  
        @placa = @tranportorder.truck_id
    
        @placa2 = @tranportorder.truck2_id
  
        @placa3 = @tranportorder.truck3_id
    

    @couts = Cout.new
    @couts[:code] = @couts.generate_cout_number

    puts "code ----"

    puts @couts[:code]
    puts @employee_id
    
    puts @placa 
    


    @couts[:fecha] =  params[:fecha]
    @couts[:importe] = params[:total_importe]
    @couts[:tbk] = params[:tbk]
    @couts[:tbk_documento] = params[:tbk_documento]
    @couts[:truck_id] = @placa
    @couts[:truck2_id] = @placa2
    @couts[:truck3_id] = @placa3    
    @couts[:tranportorder_id] = @tranportorder.id
    @couts[:employee_id] = @employee_id
    @couts[:employee2_id] = @employee2_id
    @couts[:employee3_id] = @employee3_id
    @couts[:employee4_id] = @employee4_id

   @couts[:ubication_id] =@tranportorder.ubication_id
    @couts[:ubication2_id] =@tranportorder.ubication2_id
   
 @couts[:fecha1] =  @tranportorder.fecha1
 @couts[:fecha2] =   @tranportorder.fecha2


    @couts[:peajes] =  0
    @couts[:lavado] = 0
    @couts[:llanta] = 0
    @couts[:alimento] = 0
    @couts[:otros] = 0
    @couts[:monto_recibido] = params[:total_importe].to_f +  params[:tbk].to_f
    @couts[:flete] = 0
    @couts[:recibido_ruta] = 0
    @couts[:vuelto] = 0
    @couts[:descuento] = 0
    @couts[:reembolso] = 0

    
     respond_to do |format|
       if    @couts.save           
        
          format.html { redirect_to(couts_path , :notice => 'Comprobante fue grabada con exito .') }
          format.xml  { render :xml => @couts, :status => :created, :location => @couts}
        else

          format.html { redirect_to("/companies/couts/do_cargar/#{@company.id}", :notice  => 'Ocurrio un error .') }
          format.xml  { render :xml => @couts.errors, :status => :unprocessable_entity }
        end 
        
      end


end 

def do_cargar
  @company   = Company.find(1)

   if params[:search]
           
          
        @osts   = Tranportorder.search(params[:search]).where(["fecha1 >= ?","2021-03-01 00:00:00"]).order("fecha desc ,code desc ").paginate(:page => params[:page])
     
    else
              
        @osts = Tranportorder.where(["fecha1 >= ?","2021-04-01 00:00:00"]).order("fecha desc ,code desc ").paginate(:page => params[:page])

    end

end 


def newviatico


   @tranportorder =   Tranportorder.find(params[:id])

    




end 

  def update_employee

     @employees = Employee.where(params[:employee_id])
    # map to name and id for use in our options_for_select
     puts @employee.id
   
  end




  def do_anular
    @invoice = Tranportorder.find(params[:id])


   a = Delivery.find_by(:tranportorder_id=> params[:id])


   if a 
    flash[:notice] = "Comprobante  tiene cajas asignadas, no se puede anular. Elimine primero las cajas "
    
    else

    @invoice[:processed] = "2"
    @invoice.anular 
    
    flash[:notice] = "Documento a sido anulado."

    end 
    redirect_to @invoice 



  end




##-----------------------------------------------------------------------------------
## REPORTE DE GUIAS EMITIDAS
##-----------------------------------------------------------------------------------
  def build_pdf_header(pdf)
        pdf.font "Helvetica"  , :size => 8
     image_path = "#{Dir.pwd}/public/images/tpereda2.png"


     
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD EN EL TRABAJO ",:rowspan => 2},"CODIGO ","TP-FZ-F-009"], 
          ["VERSION: ","2"], 
          ["COMPROBANTE DE EGRESO   Nro. " + @cout.code ,"Pagina: ","1 de 1 "] 
         
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

  def build_pdf_body(pdf)
     pdf.font "Helvetica"  , :size => 6


     
    
          ############

               

                texto_letras = @cout.textify.upcase + " SOLES "
          


      tb_text_guias = [ [{:content => "FECHA  : " + @cout.fecha.strftime("%d/%m/%Y"), :font_style => :bold , :border_width => 0 }, 
                         {:content => "S/.", :font_style => :bold , :border_width => 0 }  ,@cout.importe]


                        ]

            pdf.table( tb_text_guias ,:position => :right,
                                              
                                              :width =>  pdf.bounds.width,
                                              :cell_style => {:height => 17}
                                                    ) do

            row(0).font_style = :bold
            columns([0]).align = :left
            columns([1]).align = :right
            columns([2]).width = 135
            columns([2]).align = :right
            end

     pdf.move_down 5

      tb_text_guias = [ [{:content => "RECIBI DE : TRANSPORTE PEREDA SRL. ", :font_style => :bold , :border_width => 0 },
                            {:content => "TBK S/. ", :font_style => :bold , :border_width => 0 } , 
                            @cout.tbk],


                        ]

            pdf.table( tb_text_guias ,:position => :right,
                                              
                                              :width =>  pdf.bounds.width,
                                              :cell_style => {:height => 17}
                                                    ) do

            row(0).font_style = :bold
            columns([0]).align = :left
            columns([1]).align = :right
            columns([2]).width = 135
            columns([2]).align = :right
            end
        pdf.move_down 5



      tb_text_guias = [ [{:content => "LA CANTIDAD DE : " + texto_letras, :font_style => :bold , :border_width => 0 },
                            {:content => "PLACA ", :font_style => :bold , :border_width => 0 } , 
                            @cout.truck.placa ],


                        ]

            pdf.table( tb_text_guias ,:position => :right,
                                              
                                              :width =>  pdf.bounds.width,
                                              :cell_style => {:height => 17}
                                                    ) do

            row(0).font_style = :bold
            columns([0]).align = :left
            columns([1]).align = :right
            columns([2]).width = 135
            columns([2]).align = :right
            end
        pdf.move_down 5


      tb_text_guias = [ [{:content => "DESTINO . "+ @cout.tranportorder.get_punto(@cout.tranportorder.ubication_id ), :font_style => :bold , :border_width => 0 },
                             {:content => "  ", :font_style => :bold , :border_width => 0 }, 
                              {:content => "  ", :font_style => :bold , :border_width => 0 } ],


                        ]

            pdf.table( tb_text_guias ,:position => :right,
                                              
                                              :width =>  pdf.bounds.width,
                                              :cell_style => {:height => 17}
                                                    ) do

            row(0).font_style = :bold
            columns([0]).align = :left
            columns([1]).align = :right
            columns([2]).width = 135
            columns([2]).align = :right
            end
        pdf.move_down 5



       table_content = ([ ["OST SALIDA  .: ", @cout.tranportorder.code   ]   ])
      

       pdf.table(table_content  ,{
           :position => :right ,
           :width => pdf.bounds.width/4 
         })do
           columns([0]).font_style = :bold
          
            columns([0]).align = :center
      
         end

         pdf.move_down 2




            tb_text_guias2 = [ [{:content => "FIRMA:", :font_style => :bold , :border_width => 0 },"......................................................................................."],

            [{:content => "RECIBIDO POR :", :font_style => :bold , :border_width => 0 },"......................................................................................."],
            [{:content => "DNI.:", :font_style => :bold , :border_width => 0 },"......................................................................................."],
            [{:content => "AYUDANTE.:", :font_style => :bold , :border_width => 0 },"......................................................................................."]
           
           
                         
                        ]

            pdf.table( tb_text_guias2 ,:position => :left,
                                              
                                              :width =>  pdf.bounds.width/2,
                                              :cell_style => {:height => 17 ,:border_width =>0}
                                                    ) do

            row(0).font_style = :bold
               columns([0]).align = :left 
               columns([0]).width = 80
            end

         pdf.move_down 2



            tb_text_direccion = [ 
                  [{:content => " " , :font_style => :bold, :border_width => 0},{:content => " " , :font_style => :bold, :colspan=>3 , :border_width => 0}, {:content => "MONTO RECIBIDO : ", :font_style => :bold}, @cout.monto_recibido ],
                   [{:content => "PEAJES: ", :font_style => :bold}," ", @cout.peajes, {:content => " " , :font_style => :bold, :border_width => 0}, {:content => "FLETE  ", :font_style => :bold}, @cout.flete ],
                   [{:content => "LAVADO  : ", :font_style => :bold} ," ", @cout.lavado    ,{:content => " " , :font_style => :bold, :border_width => 0}, {:content => "RECIBIDO RUTA  ", :font_style => :bold}, @cout.flete ],
                   [{:content => "LLANTA : ", :font_style => :bold}  ," ", @cout.llanta    ,{:content => " " , :font_style => :bold, :border_width => 0}, {:content => "TOTAL S/.  ", :font_style => :bold,:align => :right}, @cout.flete ],
                   [{:content => "ALIMENTO : ", :font_style => :bold}," ", @cout.alimento  ,{:content => " " , :font_style => :bold, :border_width => 0}, {:content => "VUELTO ", :font_style => :bold}, @cout.flete ],
                   
                   [" "," "," ", {:content => " " , :font_style => :bold, :border_width => 0}, {:content => "DESCUENTO   ", :font_style => :bold}, @cout.flete ],
                   [" " ," "," "    ,{:content => " " , :font_style => :bold, :border_width => 0}, {:content => "REEMBOLSO  ", :font_style => :bold}, @cout.flete ],
                   [" " ," ", " "   ,{:content => " " , :font_style => :bold, :border_width => 0}, {:content => "FLETE .  ", :font_style => :bold,:align => :left }, @cout.flete ],
                   [" " ," "," "  ,{:content => " " , :font_style => :bold, :border_width => 0}, {:content => "N.OST RETORNO ", :font_style => :bold}, @cout.flete ]
                  ]


             pdf.table( tb_text_direccion ,:position => :right,
                                              :width => pdf.bounds.width,
                                               :cell_style => {:height => 17}
                                                    ) do
              columns([0,1,2]).width = 80
              columns([0]).font_style = :bold


             columns([0]).align = :center
          
              columns([2,5]).align = :right
            end
      

          pdf.move_down 20


            tb_text_direccion = [ ["-------------------------------------------------------","               ","----------------------------------------"],
            ["RENDIDO","                    ","V.B."]]               

             pdf.table( tb_text_direccion ,:position => :center,
                                              :width => pdf.bounds.width , :cell_style=>{:border_width =>0}
                                                    ) do
              columns([0]).width = 200
              columns([2]).width = 200

             columns([0,2]).align = :center
          
              
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
  def pdf
   
    
    @company =Company.find(1)
    @cabecera ="Facturacion"
    @abajo    ="Viatico"
          
    @cout = Cout.find(params[:id])
     
    Prawn::Document.generate("app/pdf_output/#{@cout.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        @lcFileName =  "app/pdf_output/#{@cout.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+@lcFileName
    #send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    send_file(@lcFileName, :type => 'application/pdf', :disposition => 'inline')
  end
  



 def client_cout_headers

    #{@serviceorder.description}
      client_headers  = [[ "Chofer: ", @cout.employee.full_name ], 
                          ["Apoyo : ", @cout.get_employee(@cout.employee2_id)] 
                          ]
    
      
      client_headers
  end

  def cout_headers            

      if @cout.fecha2.nil?

      cout_headers  = [["Fecha Salida : ",@cout.fecha1.strftime("%d/%m/%Y") ]]
      cout_headers << ["Fecha Llegada : "," "]
      cout_headers << [" ", " " ]
     
     
      cout_headers

      else 
      cout_headers  = [["Fecha Salida : ",@cout.fecha1.strftime("%d/%m/%Y") ]]
      cout_headers << ["Fecha Llegada : ",@cout.fecha2.strftime("%d/%m/%Y")]
      cout_headers << [" ", " " ]
     
     
      cout_headers

    end 
  end

 def cout_headers2         
      cout_headers2  = [["Desde : ", @cout.get_punto(@cout.ubication_id)]]

       cout_headers2 << ["Hasta : ", @cout.get_punto(@cout.ubication2_id)]
       

     
      cout_headers2
  end
def cout_headers3        
      cout_headers3  = [["Placa : ", @cout.truck.placa + " " + @cout.get_placa(@cout.truck2_id) ] ]

      cout_headers3 << [" "," "]
      cout_headers3 << [" "," "]
      cout_headers3
  end


  ###########################FORMATO LIQUIDACION




  # Export serviceorder to PDF
  def pdf1
   
    
    @company =Company.find(1)
    @cabecera ="Facturacion"
    @abajo    ="Viatico"
          
    @cout = Cout.find(params[:id])
     
    Prawn::Document.generate("app/pdf_output/#{@cout.id}.pdf" ,:page_size => "A4",:margin=> 2 ) do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_1(pdf)
        pdf = build_pdf_body_1(pdf)
        build_pdf_footer_1(pdf)
        @lcFileName =  "app/pdf_output/#{@cout.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+@lcFileName
    #send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    send_file(@lcFileName, :type => 'application/pdf', :disposition => 'inline')
  end
  
def build_pdf_header_1(pdf)
        pdf.font "Helvetica"  , :size => 6
     image_path = "#{Dir.pwd}/public/images/tpereda2.png"


     
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD EN EL TRABAJO ",:rowspan => 2},"CODIGO ","TP-FZ-F-014"], 
          ["VERSION: ","4"], 
          ["LIQUIDACION DE GASTOS DE VIAJE "  ,"Pagina: ","1 de 1 "] 
         
          ])
        

       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
            columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 352.73
            columns([1]).align = :center
            columns([2]).align = :center
            columns([3]).align = :center

            columns([2]).width = 60

            columns([3]).width = 60

         end
        
      
        
         pdf.move_down 2
      pdf 

 
  end   


  def build_pdf_body_1(pdf)


     pdf.font "Helvetica"  , :size => 6
    
          ############
  texto_letras = @cout.textify.upcase + " SOLES "
  if !@cout.tranportorder.nil? 

  ost =  @cout.tranportorder.code
  else
    ost = ""
  end 

tb_text_guias  = [["Fecha :", @cout.fecha.strftime('%d-%m-%Y'), "TBK: "+@cout.tbk.to_s , 
  "Importe", {:content => @cout.importe.to_s , :font_style => :bold ,:size=> 6  },
   {:content => "O.S.T.", :font_style => :bold ,:size=> 6 ,:text_color=> "0000FF"  }, 
   {:content => ost , :font_style => :bold ,:size=> 6 ,:text_color=> "0000FF"  } ]]
    
      
            pdf.table( tb_text_guias ,:position => :right,
                                              
                                              :width =>  pdf.bounds.width,
                                          
                                                    ) do

            row(0).font_style = :bold
            columns([0]).align = :left
            columns([1]).align = :right
      
            columns([2]).align = :right
            end

     pdf.move_down 2




    max_rows = [client_cout_headers.length, client_cout_headers.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_cout_headers.length >= row ? client_cout_headers[rows_index] : ['',''])
        rows[rows_index] += (cout_headers.length >= row ? cout_headers[rows_index] : ['',''])
        rows[rows_index] += (cout_headers2.length >= row ? cout_headers2[rows_index] : ['',''])
        rows[rows_index] += (cout_headers3.length >= row ? cout_headers3[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0,:height => 17},
          :width => pdf.bounds.width
        }) do
          columns([0, 2,4,6]).font_style = :bold

        end

        pdf.move_down 2

      end      
     pdf.font "Helvetica"  , :size => 6

 image_path2 = "#{Dir.pwd}/public/images/CAJA.png"

      pdf.table [  
      [ {:image => image_path2, :vposition => :center,
      :fit => [390, 1000]}]
      ], :width => pdf.bounds.width

  pdf.move_down 10 
  ########################## rotulo ##########################3
  


  if !@cout.tranportorder.nil?

     ost_code = @cout.tranportorder.code

  else
    ost_code = "-"
  end 

if @cout.fecha2.nil?


    data2 = [  ["RUTA :"+ @cout.get_punto(@cout.ubication_id) + "  -  "+ @cout.get_punto(@cout.ubication2_id) ,  
               + "   FECHA SALIDA : "+@cout.fecha1.strftime("%d/%m/%Y") +  "   FECHA LLEGADA : " ," IMPORTE  S/."  +  @cout.importe.to_s ],
                 [  " PLACA TRACTO/CAMION: " + @cout.truck.placa  + " " + @cout.get_placa(@cout.truck2_id)  ," " ," TBK S/.:" + @cout.tbk.to_s ],
                 [ " CONDUCTOR DE CARGA  " + @cout.employee.full_name,"SUPERVISOR/APOYO: "+@cout.get_employee(@cout.employee3_id)," TBK DOC.: " + @cout.tbk_documento ],
                 
                 [ " CONDUCTOR DE RUTA  : "+@cout.get_employee(@cout.employee2_id)  ],
                 
                 ["OBSERVACIONES: " , @cout.observa ],
                 [" ", " "],
                 ["................................ ", " ................................ "],
                 [" Conductor.:  ", "          V.B."]]


else 

    data2 = [  ["RUTA :"+ @cout.get_punto(@cout.ubication_id) + "  -  "+ @cout.get_punto(@cout.ubication2_id) ,  
               + "   FECHA SALIDA : "+@cout.fecha1.strftime("%d/%m/%Y") +  "   FECHA LLEGADA : "+@cout.fecha2.strftime("%d/%m/%Y") ," IMPORTE  S/."  +  @cout.importe.to_s ],
                 [  " PLACA TRACTO/CAMION: " + @cout.truck.placa  + " " + @cout.get_placa(@cout.truck2_id)  ," " ," TBK S/.:" + @cout.tbk.to_s ],
                 [ " CONDUCTOR DE CARGA  " + @cout.employee.full_name,"SUPERVISOR/APOYO: "+@cout.get_employee(@cout.employee3_id)," TBK DOC.: " + @cout.tbk_documento ],
                 
                 [ " CONDUCTOR DE RUTA  : "+@cout.get_employee(@cout.employee2_id)  ],
                 
                 ["OBSERVACIONES: " , @cout.observa ],
                 [" ", " "],
                 ["................................ ", " ................................ "],
                 [" Conductor.:  ", "          V.B."]]


end 


                         pdf.bounding_box([0, 200], :width => 550, :height => 200) do
          
          
        pdf.text "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
        pdf.text "COMPROBANTE DE EGRESO :  " + @cout.code  + "              OST.:  " + ost_code  ,   :size => 13 
        
        
        pdf.table(data2, :cell_style => { :border_width => 0 }, :column_widths => [223, 223,104] )
        pdf.text @abajo , :align => :right 
      end
      
      
      pdf


    end


    def build_pdf_footer_1(pdf)

        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cout
      @cout = Cout.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cout_params
      params.require(:cout).permit(:code, :fecha, :importe, :truck_id, :punto_id, :tranportorder_id, :employee_id, :employee2_id, 
        :employee3_id, :peajes, :lavado, :llanta, :alimento, :otros, :monto_recibido, :flete, :recibido_ruta, :vuelto, :descuento, 
        :reembolso, :flete, :ost_id,:tbk,:tbk_documento,:employee4_id,:truck2_id,:truck3_id,:observa,:fecha1,:fecha2,
        :ubication_id ,:ubication2_id,:search)
    end

end
