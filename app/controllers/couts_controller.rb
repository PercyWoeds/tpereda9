class CoutsController < ApplicationController
  before_action :set_cout, only: [:show, :edit, :update, :destroy]

  # GET /couts
  # GET /couts.json
  def index
    @couts = Cout.all
      @company = Company.find(1)
  end

  # GET /couts/1
  # GET /couts/1.json
  def show
  end

  # GET /couts/new
  def new
    @cout = Cout.new

    @company   = Company.find(1)

      @employees = @company.get_employees() 

      @cout[:fecha] = Date.today 

      @cout[:importe] = 0.00
  end

  # GET /couts/1/edit
  def edit

      @company   = Company.find(1)


  end

  # POST /couts
  # POST /couts.json
  def create
    @cout = Cout.new(cout_params)

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
    @cout.destroy
    respond_to do |format|
      format.html { redirect_to couts_url, notice: 'Cout was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

def get_employee(id)

  a = Employee.find(id)

  return a.full_name 



end 

def do_crear

    @company = Company.find(1)

    @action_txt = "do_crear" 
    @tranportorder = Tranportorder.find(params[:id] ) 

    puts params[:total_importe]

    puts "checked "

   puts params[:emp1]

      puts params[:emp2]
         puts params[:emp3]


    if params[:emp1] == "true"
        @employee_id = @tranportorder.employee_id
    end 
 if params[:emp2] == "true"
        @employee_id = @tranportorder.employee2_id
    end 

 if params[:emp3] == "true"
        @employee_id = @tranportorder.employee3_id
    end 
 if params[:emp4] == "true"
        @employee_id = @tranportorder.employee4_id
    end 


    if params[:placa1] == "true"
        @placa = @tranportorder.truck_id
    end 
 if params[:placa2] == "true"
        @placa = @tranportorder.truck2_id
    end 

 if params[:placa3] == "true"
        @placa = @tranportorder.truck3_id
    end 


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
    @couts[:tranportorder_id] = @tranportorder.id
    @couts[:employee_id] = @employee_id
    @couts[:peajes] =  0
    @couts[:lavado] = 0
    @couts[:llanta] = 0
    @couts[:alimento] = 0
    @couts[:otros] = 0
    @couts[:monto_recibido] = @couts[:total_importe] +   @couts[:tbk]
    @couts[:flete] = 0
    @couts[:recibido_ruta] = 0
    @couts[:vuelto] = 0
    @couts[:descuento] = 0
    @couts[:reembolso] = 0|
    
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
   @osts   = Tranportorder.where(["fecha1 >= ?","2020-11-01 00:00:00"]).order("fecha desc ,code desc ").paginate(:page => params[:page])
                 
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
          ["COMPROBANTE DE EGRESO  Nro. " + @cout.code ,"Pagina: ","1 de 1 "] 
         
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
    
    
       table_content = ([ [" " ]   ])
      

       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([0]).font_style = :bold
          
            columns([0]).align = :center
      
         end

         pdf.move_down 2
  


      ############


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



      tb_text_guias = [ [{:content => "LA CANTIDAD DE : " , :font_style => :bold , :border_width => 0 },
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




            tb_text_guias2 = [ [{:content => "FIRMA: ...................................................", :font_style => :bold , :border_width => 0 }],

            [{:content => "RECIBIDO POR : ...................................................", :font_style => :bold , :border_width => 0 }],
            [{:content => "DNI.: ...................................................", :font_style => :bold , :border_width => 0 }],
            [{:content => "AYUDANTE: ...................................................", :font_style => :bold , :border_width => 0 }]

                         
                        ]

            pdf.table( tb_text_guias2 ,:position => :left,
                                              
                                              :width =>  pdf.bounds.width/2,
                                              :cell_style => {:height => 17}
                                                    ) do

            row(0).font_style = :bold
          
            end

         pdf.move_down 2



            tb_text_direccion = [ [{:content => "PEAJES: ", :font_style => :bold}," ", @cout.peajes, "  ", {:content => "FLETE  ", :font_style => :bold}, @cout.flete ],
                   [{:content => "LAVADO  : ", :font_style => :bold} ," ", @cout.lavado    ,"  ", {:content => "RECIBIDO RUTA  ", :font_style => :bold}, @cout.flete ],
                   [{:content => "LLANTA : ", :font_style => :bold}  ," ", @cout.llanta    ,"  ", {:content => "TOTAL S/.  ", :font_style => :bold,:align => :right}, @cout.flete ],
                   [{:content => "ALIMENTO : ", :font_style => :bold}," ", @cout.alimento  ,"  ", {:content => "VUELTO ", :font_style => :bold}, @cout.flete ]]
                   


             pdf.table( tb_text_direccion ,:position => :right,
                                              :width => pdf.bounds.width 
                                                    ) do
              columns([0]).width = 60
              columns([0]).font_style = :bold
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

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    #send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    send_file(@lcFileName, :type => 'application/pdf', :disposition => 'inline')
  end
  



 def client_cout_headers

    #{@serviceorder.description}
      client_headers  = [["Fecha :", @cout.fecha.strftime('%d-%m-%Y') ]]
      client_headers << ["Recibi de :","TRANSPORTES PEREDA S.R.L."]
      client_headers << ["La cantidad de :",@cout.monto_recibido]
      client_headers << ["Destino :",@cout.tranportorder.get_punto(@cout.tranportorder.ubication_id )]
     
      
      client_headers
  end

  def cout_headers            
      cout_headers  = [["Efectivo  S/.: ",@cout.importe.round(2) ]]
      cout_headers << ["TBK S/.:", @cout.tbk.round(2) ]
      cout_headers << ["Placa : ",@cout.truck.placa ]
      cout_headers << [""]
     
      cout_headers
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
        :reembolso, :flete, :ost_id,:tnk,:tbk_documento)
    end

end
