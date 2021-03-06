class CotizacionsController < ApplicationController
  before_action :set_cotizacion, only: [:show, :edit, :update, :destroy]

  # GET /cotizacions
  # GET /cotizacions.json
  def index
    @cotizacions = Cotizacion.all
  end


  # GET /cotizacions/1
  # GET /cotizacions/1.json
  def show


  end

  # GET /cotizacions/new
  def new
    @cotizacion = Cotizacion.new
    @company = Company.find(1)

    @customers = @company.get_customers

    @puntos = @company.get_puntos 
    @tipo_unidad = @company.get_tipo_unidad
    @config_vehi = @company.get_configvehi
    @tipocarga = Tipocargue.all 
    @monedas = @company.get_monedas()
    @payments = @company.get_payments()
      @tipocustomers =  @company.get_tipocustomers()


    @cotizacion[:fecha]= Date.today 

    @cotizacion[:price] = 0
    @cotizacion[:qty] = 0
    @cotizacion[:total] = 0

    @cotizacion[:price2] = 0
    @cotizacion[:qty2] = 0
    @cotizacion[:total2] = 0

    @cotizacion[:price3] = 0
    @cotizacion[:qty3] = 0
    @cotizacion[:total3] = 0


    @cotizacion[:price] = 0
    @cotizacion[:qty] = 0
    @cotizacion[:total] = 0

    @cotizacion[:price2] = 0
    @cotizacion[:qty2] = 0
    @cotizacion[:total2] = 0

    @cotizacion[:price3] = 0
    @cotizacion[:qty3] = 0
    @cotizacion[:total3] = 0


    @cotizacion[:price] = 0
    @cotizacion[:qty] = 0
    @cotizacion[:total] = 0

    @cotizacion[:price2] = 0
    @cotizacion[:qty2] = 0
    @cotizacion[:total2] = 0

    @cotizacion[:price3] = 0
    @cotizacion[:qty3] = 0
    @cotizacion[:total3] = 0


    @cotizacion[:price4] = 0
    @cotizacion[:qty4] = 0
    @cotizacion[:total4] = 0

    @cotizacion[:price5] = 0
    @cotizacion[:qty5] = 0
    @cotizacion[:total5] = 0

    @cotizacion[:price6] = 0
    @cotizacion[:qty6] = 0
    @cotizacion[:total6] = 0


    @cotizacion[:price7] = 0
    @cotizacion[:qty7] = 0
    @cotizacion[:total7] = 0

    @cotizacion[:price8] = 0
    @cotizacion[:qty8] = 0
    @cotizacion[:total8] = 0

    @cotizacion[:price9] = 0
    @cotizacion[:qty9] = 0
    @cotizacion[:total9] = 0


    @cotizacion[:price10] = 0
    @cotizacion[:qty10] = 0
    @cotizacion[:total10] = 0



  end

  # GET /cotizacions/1/edit
  def edit
     @company = Company.find(1)
    @customers = @company.get_customers
     @monedas = @company.get_monedas()
    @payments = @company.get_payments()

    @puntos = @company.get_puntos 
    @tipo_unidad = @company.get_tipo_unidad
    @config_vehi = @company.get_configvehi
    @tipocarga = Tipocargue.all 
    @tipocustomers =  @company.get_tipocustomers()


    @puntos = @company.get_puntos 
    @tipocarga = Tipocargue.all 

    if @cotizacion.tm == 1

        tm = 1 
    end

  end

  # POST /cotizacions
  # POST /cotizacions.json
  def create
     @company = Company.find(1)
    @customers = @company.get_customers

     @puntos = @company.get_puntos 
    @tipo_unidad = @company.get_tipo_unidad
    @config_vehi = @company.get_configvehi
    @tipocarga = Tipocargue.all 
    @monedas = @company.get_monedas()
    @payments = @company.get_payments()
      @tipocustomers =  @company.get_tipocustomers()


    @tipocarga = Tipocargue.all 
    
    @cotizacion = Cotizacion.new(cotizacion_params)
    
    @cotizacion[:code] = @cotizacion.generate_number("1") 


    @cotizacion[:tm] = params[:tm]

    @cotizacion[:total]  = @cotizacion[:price] * @cotizacion[:qty] 

    @cotizacion[:total2] = @cotizacion[:price2] * @cotizacion[:qty2] 
     
    @cotizacion[:total3] = @cotizacion[:price3] * @cotizacion[:qty3] 

    @cotizacion[:total4] = @cotizacion[:price4] * @cotizacion[:qty4] 

    @cotizacion[:total5] = @cotizacion[:price5] * @cotizacion[:qty5] 
     
    @cotizacion[:total6] = @cotizacion[:price6] * @cotizacion[:qty6] 



     

    respond_to do |format|
      if @cotizacion.save
        format.html { redirect_to @cotizacion, notice: 'Cotizacion was successfully created.' }
        format.json { render :show, status: :created, location: @cotizacion }
      else
        format.html { render :new }
        format.json { render json: @cotizacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cotizacions/1
  # PATCH/PUT /cotizacions/1.json
  def update
     @company = Company.find(1)
    @customers = @company.get_customers
    @monedas = @company.get_monedas()
    @payments = @company.get_payments()
    @tipocustomers =  @company.get_tipocustomers()

    @puntos = @company.get_puntos 
    @tipo_unidad = @company.get_tipo_unidad
    @config_vehi = @company.get_configvehi
    @tipocarga = Tipocargue.all 
    @cotizacion[:tm] = params[:tm]
    puts "cotiza tm "
    puts  @cotizacion[:tm] 


    @cotizacion[:total] = params[:cotizacion][:price].to_f * params[:cotizacion][:qty].to_f 

    @cotizacion[:total2] = params[:cotizacion][:price2].to_f * params[:cotizacion][:qty2].to_f
     
    @cotizacion[:total3] = params[:cotizacion][:price3].to_f * params[:cotizacion][:qty3].to_f


    @cotizacion[:total4] = params[:cotizacion][:price4].to_f * params[:cotizacion][:qty4].to_f 

    @cotizacion[:total5] = params[:cotizacion][:price5].to_f * params[:cotizacion][:qty5].to_f
     
    @cotizacion[:total6] = params[:cotizacion][:price6].to_f * params[:cotizacion][:qty6].to_f



    respond_to do |format|
      if @cotizacion.update(cotizacion_params)
        format.html { redirect_to @cotizacion, notice: 'Cotizacion was successfully updated.' }
        format.json { render :show, status: :ok, location: @cotizacion }
      else
        format.html { render :edit }
        format.json { render json: @cotizacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cotizacions/1
  # DELETE /cotizacions/1.json
  def destroy
    @cotizacion.destroy
    respond_to do |format|
      format.html { redirect_to cotizacions_url, notice: 'Cotizacion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def do_anular

    @cotizacion = Cotizacion.find(params[:id])  
    @cotizacion[:processed] = "2"
    @cotizacion.anular    

    flash[:notice] = "Documento a sido anulado."

    redirect_to @cotizacion

  end
  
  def do_cancelar
    @cotizacion = Cotizacion.find(params[:id])  
    @cotizacion[:processed] = "3"
    @cotizacion.cancelar      
    flash[:notice] = "Documento a sido cancelado."
     redirect_to @cotizacion

  end

   
   def do_process
    @cotizacion  = Cotizacion.find(params[:id])
    @cotizacion[:processed] = "1"


    @cotizacion.process
    
    flash[:notice] = "El documento ha sido aceptado"
    redirect_to @cotizacion
  end



  def pdf

    @company =Company.find(1) 

    @cotizacion = Cotizacion.find(params[:id])
  
  

    Prawn::Document.generate("app/pdf_output/#{@cotizacion.id}.pdf", 
      :page_size => "A4",:margin=> 0 ) do |pdf|
     
       
      
      pdf.font "Helvetica"
      pdf = build_pdf_header(pdf)

       pdf = build_pdf_body(pdf)
       build_pdf_footer(pdf)
        @lcFileName =  "app/pdf_output/#{@cotizacion.id}.pdf"     

    end

    @lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+@lcFileName                
    send_file("#{@lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end 


  def pdf2

    @company =Company.find(1) 

    @cotizacion = Cotizacion.find(params[:id])
    
    @lcName = "COTIZACION-"
  
    Prawn::Document.generate("app/pdf_output/#{@lcName+@cotizacion.code}.pdf", 
      :page_size => "A4",:margin=> 0 ) do |pdf|
     
       
      
      pdf.font "Helvetica"
      pdf = build_pdf_header2(pdf)

      if @cotizacion.tipocustomer_id == 1
          pdf = build_pdf_body2(pdf)
          build_pdf_footer2(pdf)
      end 

        if @cotizacion.tipocustomer_id == 2
          pdf = build_pdf_body3(pdf)
          build_pdf_footer3(pdf)
      end 

        if @cotizacion.tipocustomer_id == 3
          pdf = build_pdf_body3(pdf)
          build_pdf_footer3(pdf)
      end 

        if @cotizacion.tipocustomer_id == 4
                pdf = build_pdf_body4(pdf)
            
            end 

        @lcFileName =  "app/pdf_output/#{@lcName + @cotizacion.code}.pdf"     

    end
    puts "nombre archivo.."
    puts @lcFileName1


    @lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+@lcFileName                
    send_file("#{@lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end 


  def build_pdf_header2(pdf)

     image_path = "#{Dir.pwd}/public/images/cotizacion1.jpg"

              pdf.font "Times-Roman"  , :size => 8
            
              
             table_content0 = []

             table_content0 = ([[{:image => image_path, :fit => [pdf.bounds.width, pdf.bounds.height] }]  ])

               pdf.table(table_content0,{ 
                       :position => :right,
                      :width => pdf.bounds.width,
                      :cell_style => {:border_width => 0} }) do

                      columns([0]).font_style = :bold

               end 

             pdf.canvas do 
              
                 pdf.bounding_box [160,450], :width  => pdf.bounds.width,:border_width=> 0 do
                  pdf.cell :content=> "COTIZACIÓN 
                  Nº GC 001-"+@cotizacion.code  , align: :center, valign: :top, size: 24 , :text_color => "FFFFFF", :border_width => 0 ,:font_style => :bold_italic
                 end

                  pdf.bounding_box [200,220], :width  => pdf.bounds.width,:border_width=> 0 do
                  pdf.cell :content=> "CLIENTE : 
                   "+@cotizacion.customer.name   , align: :center, valign: :top, size: 24 , :text_color => "000000", :border_width => 0 ,:font_style => :italic
                 end
      
              end

              pdf 

    ##########################################################################################



  end 


  def build_pdf_body2(pdf)

              pdf.font "Times-Roman"  , :size => 9

              image_path = "#{Dir.pwd}/public/images/cotizacion2.jpg"

              table_content0 = []

              table_content0 = ([[{:image => image_path, :fit => [pdf.bounds.width, pdf.bounds.height] }] ])

              pdf.table(table_content0,{ 
              :position => :right,
              :width => pdf.bounds.width,
              :cell_style => {:border_width => 0} }) do
                   columns([0]).font_style = :bold
              end 


       pdf.canvas do 
    
              pdf.bounding_box [340,760 ], :width  => pdf.bounds.width,:border_width=> 0  do
              pdf.cell :content=>"Lima , "+I18n.l(@cotizacion.fecha.to_date, locale: :es ,format: :long )   , align: :right , valign: :top, size: 11  , :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic  
              end

              pdf.bounding_box [20,750], :width  => pdf.bounds.width,:border_width=> 0 do

              pdf.cell :content=> "COTIZACIÓN N°. :"+@cotizacion.code + "\n"+
              "Señores :" + "\n" + @cotizacion.customer.name + "\n" +
              @cotizacion.customer.ruc + "\n" +
              "Atención:" + "\n" + 
                 @cotizacion.customer.sr + " : "+ @cotizacion.customer.contacto , align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end

              pdf.bounding_box [20,680], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> "Es grato dirigirnos  a usted  para comunicarle que de acuerdo a su solicitud, nuestro precio por el servicio" +"\n" + "solicitado es el siguiente. :",
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end


              pdf.font "Times-Roman"  , :size => 8
              pdf.bounding_box [40,650], :width  => pdf.bounds.width,:border_width=> 0 do
               pdf.cell :content=> "RUTA: " + "  " + @cotizacion.punto.name + "-" + @cotizacion.get_punto(@cotizacion.punto2_id),
                align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end


              pdf.bounding_box [40,630], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> "ESPECIFICACIONES DE LA CARGA : " ,
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end


              pdf.bounding_box [50,620], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> @cotizacion.especifica ,
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end
         
              pdf.bounding_box [40,610], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> "TIPO DE UNIDAD E IMPORTE DEL SERVICIO  : " ,
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end


              pdf.font "Times-Roman"  , :size => 6


               pdf.bounding_box [40,595], :width  => pdf.bounds.width* 0.9 ,:border_width=> 0 do

              table_content =[]


              row=[]
              

             row << "ITEM"
             row << "TIPO DE UNIDAD"
             row << "CONFIGURACION 
             VEHICULAR"
             row << "DESCRIPCION"
             row << "CANTIDAD"
             row << "PRECIO
             UNITARIO"
             row << "PRECIO 
             TOTAL"

             table_content << row 
             puts "apdfdfd"
             puts row 


            row=[]

            row << "01"
            if !@cotizacion.tipo_unidad_id.nil?
              row << @cotizacion.tipo_unidad.name 
            else 
              row << ""
            end 

            if !@cotizacion.config_vehi_id.nil?

              row << @cotizacion.config_vehi.name 
            else 
              row << " "
            end 

            row << @cotizacion.descrip1
            row << @cotizacion.qty
            row << @cotizacion.price
            row << @cotizacion.total 
            table_content << row 


            row=[]

            row << "02"
            if !@cotizacion.tipo_unidad2_id.nil?
             row << @cotizacion.get_tipounidad(@cotizacion.tipo_unidad2_id)
            else 
              row << ""
            end 
            if !@cotizacion.config_vehi2_id.nil?
              row << @cotizacion.get_configvehi(@cotizacion.config_vehi2_id)
            else
              row << ""
            end 
            row << @cotizacion.descrip2
            row << @cotizacion.qty2
            row << @cotizacion.price2
            row << @cotizacion.total2
            table_content << row 


            row=[]
            row << "03"
            if !@cotizacion.tipo_unidad3_id.nil?
              row << @cotizacion.get_tipounidad(@cotizacion.tipo_unidad3_id)
            else 
              row << ""
            end 

            if !@cotizacion.config_vehi3_id.nil?
              puts "cotizacion..."
              puts @cotizacion.config_vehi3_id
             row << @cotizacion.get_configvehi(@cotizacion.config_vehi3_id)
            else
             row << ""
            end 
            row << @cotizacion.descrip3
            row << @cotizacion.qty3
            row << @cotizacion.price3
            row << @cotizacion.total3
            table_content << row 


            row=[]
            row << "04"
            if !@cotizacion.tipo_unidad4_id.nil?
              row << @cotizacion.get_tipounidad(@cotizacion.tipo_unidad4_id)
            else 
              row << ""
            end 

            if !@cotizacion.config_vehi4_id.nil?
              puts "cotizacion..."
              puts @cotizacion.config_vehi4_id
             row << @cotizacion.get_configvehi(@cotizacion.config_vehi4_id)
            else
             row << ""
            end 
            row << @cotizacion.descrip4
            row << @cotizacion.qty4
            row << @cotizacion.price4
            row << @cotizacion.total4
            table_content << row 




            row=[]
            row << "05"
            if !@cotizacion.tipo_unidad5_id.nil?
              row << @cotizacion.get_tipounidad(@cotizacion.tipo_unidad5_id)
            else
              row << ""
            end 

            if !@cotizacion.config_vehi5_id.nil?
              puts "cotizacion..."
              puts @cotizacion.config_vehi5_id
             row << @cotizacion.get_configvehi(@cotizacion.config_vehi5_id)
            else
             row << ""
            end 
            row << @cotizacion.descrip5
            row << @cotizacion.qty5
            row << @cotizacion.price5
            row << @cotizacion.total5
            table_content << row 




            row=[]
            row << "06"
            if !@cotizacion.tipo_unidad6_id.nil?
              row << @cotizacion.get_tipounidad(@cotizacion.tipo_unidad6_id)
            else 
              row << ""
            end 

            if !@cotizacion.config_vehi6_id.nil?
              puts "cotizacion..."
              puts @cotizacion.config_vehi6_id
             row << @cotizacion.get_configvehi(@cotizacion.config_vehi6_id)
            else
             row << ""
            end 
            row << @cotizacion.descrip6
            row << @cotizacion.qty6
            row << @cotizacion.price6
            row << @cotizacion.total6
            table_content << row 


              puts "totales"

              puts @cotizacion.total
                  puts @cotizacion.total2
                      puts @cotizacion.total3
                          puts @cotizacion.total4
                            puts @cotizacion.total5
                              puts @cotizacion.total6
                          



            row=[]
            row << ""
            row << {:content=>"VALOR TOTAL DEL SERVICIO",:colspan => 5 } 
            row << @cotizacion.total + @cotizacion.total2 + @cotizacion.total3 +
              @cotizacion.total4 + @cotizacion.total5 + @cotizacion.total6

            


            table_content << row 
          

            pdf.table table_content , {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width

                                        } do 
                                          rows([0]).font_style = :bold
                                          columns([0]).align=:center
                                          columns([0]).width = 40
                                  
                                          columns([1]).align = :left
                                          columns([1]).width = 80

                                          columns([2]).align = :left
                                          columns([2]).width = 80

                                          columns([3]).align = :right
                                          columns([3]).width = 105.752

                                          columns([4]).align = :right
                                          columns([4]).width = 70

                                          columns([5]).align = :right
                                          columns([5]).width = 70
            
                                          columns([6]).align = :right
                                          columns([6]).width = 90
                                        end 
               #tabl bouxing                            
               end 

              

              if @cotizacion.tipocustomer_id == 1 

                texto = Instruccion.find(7)

                @instruccion1 = texto.description1
                @instruccion2 = texto.description2
                @instruccion3 = texto.description3
                @instruccion4 = texto.description4
                @instruccion5 = texto.instruccion6
                @instruccion7 = texto.instruccion7
                @instruccion8 = texto.instruccion8
                @instruccion9 = texto.instruccion9
                @instruccion10 = texto.instruccion10

              end 


              pdf.bounding_box [40,450], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content => @instruccion1 + @cotizacion.moneda.description + "\n" +  @instruccion5 + 
              @cotizacion.payment.descrip + "\n" +   @instruccion7 , align: :left, valign: :top, size: 9, :text_color => "000000", 
              :border_width => 0 , :font_style => :italic 
              end


               pdf.bounding_box [40,360], :width  => pdf.bounds.width,:border_width=> 0 do
               
            table_content =[]
              row=[]
              

             row << "TIPO DE UNIDAD"
             row << "STAND BY DIA"
             
             table_content << row 
          

            row=[]
            row << "CAMIONETA"
            row << @cotizacion.tipounidad1
            table_content << row 


            row=[]
            row << "CAMION"
            row << @cotizacion.tipounidad2
            table_content << row 

            row=[]
            row << "PLATAFORMA"
            row << @cotizacion.tipounidad3
            table_content << row 

            row=[]
            row << "CAMABAJA"
            row << @cotizacion.tipounidad4
            table_content << row 

            row=[]
            row << "MODULAR "
            row << @cotizacion.tipounidad5
            row << @cotizacion.modularobs 

            table_content << row 
            row=[]
            row << "CAMACUNA "
            row << @cotizacion.camacuna 
            table_content << row 
             row=[]
            row << "STAND BY "
            row << @cotizacion.stand_by 
            table_content << row 


          

            pdf.table table_content , {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width/3

                                        } do 
                                          rows([0]).font_style = :bold
                                          columns([0]).align = :center
                                      
                                          columns([1]).align = :center
                                        
                                        
                                        end 
              


           end # canvas 




              pdf.bounding_box [40,200], :width  => pdf.bounds.width - 50,:border_width=> 0 do
              pdf.cell :content => @instruccion2 ,
              align: :left , valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end

          #end canvas 
                
          end 




        pdf 

  end 

  ##CLIENTE NUEVOOOOOO


  

    def build_pdf_footer2(pdf)

         pdf.font "Times-Roman"  , :size => 9

              image_path = "#{Dir.pwd}/public/images/cotizacion2.jpg"

              table_content0 = []

              table_content0 = ([[{:image => image_path, :fit => [pdf.bounds.width, pdf.bounds.height] }] ])

              pdf.table(table_content0,{ 
              :position => :right,
              :width => pdf.bounds.width,
              :cell_style => {:border_width => 0} }) do
                   columns([0]).font_style = :bold
              end 


       pdf.canvas do 

         pdf.bounding_box [40,740], :width  => pdf.bounds.width - 50,:border_width=> 0 do
              pdf.cell :content => @instruccion3 ,
              align: :left , valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end

         pdf.bounding_box [40,600], :width  => pdf.bounds.width - 50,:border_width=> 0 do
              pdf.cell :content => @instruccion4 + "\n"+ @instruccion8 + @cotizacion.valorseguro.to_s +  @instruccion9,
              align: :left , valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end



 pdf.bounding_box [40,350], :width  => pdf.bounds.width - 50,:border_width=> 0 do
              pdf.cell :content => "Se expide la presente Cotización, con el fin de dar su conformidad y pronta respuesta.
Muy atentamente, 
Diana Nathaly Perez Luciano." ,
              align: :left , valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end



       end 
      
      pdf
      
     end


##CLIENTE NUEVOOOO

  def build_pdf_body3(pdf)

              pdf.font "Times-Roman"  , :size => 9

              image_path = "#{Dir.pwd}/public/images/cotizacion2.jpg"

              table_content0 = []

              table_content0 = ([[{:image => image_path, :fit => [pdf.bounds.width, pdf.bounds.height] }] ])

              pdf.table(table_content0,{ 
              :position => :right,
              :width => pdf.bounds.width,
              :cell_style => {:border_width => 0} }) do
                   columns([0]).font_style = :bold
              end 


       pdf.canvas do 
    
              pdf.bounding_box [340,760 ], :width  => pdf.bounds.width,:border_width=> 0  do
              pdf.cell :content=>"Lima , "+I18n.l(@cotizacion.fecha.to_date, locale: :es ,format: :long )   , align: :right , valign: :top, size: 11  , :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic  
              end

              pdf.bounding_box [20,750], :width  => pdf.bounds.width,:border_width=> 0 do

              pdf.cell :content=> "COTIZACIÓN N°. :"+@cotizacion.code + "\n"+
              "Señores :" + "\n" + @cotizacion.customer.name + "\n" +
              @cotizacion.customer.ruc + "\n" +
              "Atención:" + "\n" + 
                 @cotizacion.customer.sr + " : "+ @cotizacion.customer.contacto , align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end

              pdf.bounding_box [20,680], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> "Es grato dirigirnos  a usted  para comunicarle que de acuerdo a su solicitud, nuestro precio por el servicio" +"\n" + "solicitado es el siguiente. :",
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end


              pdf.font "Times-Roman"  , :size => 8
              pdf.bounding_box [40,650], :width  => pdf.bounds.width,:border_width=> 0 do
               pdf.cell :content=> "RUTA: " + "  " + @cotizacion.punto.name + "-" + @cotizacion.get_punto(@cotizacion.punto2_id),
                align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end


              pdf.bounding_box [40,630], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> "ESPECIFICACIONES DE LA CARGA : " ,
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end


              pdf.bounding_box [50,620], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> @cotizacion.especifica ,
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end
         
              pdf.bounding_box [40,610], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> "TIPO DE UNIDAD E IMPORTE DEL SERVICIO  : " ,
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end


              pdf.font "Times-Roman"  , :size => 6


               pdf.bounding_box [40,595], :width  => pdf.bounds.width* 0.9 ,:border_width=> 0 do

              table_content =[]


              row=[]
              

             row << "ITEM"
             row << "TIPO DE UNIDAD"
             row << "CONFIGURACION 
             VEHICULAR"
             row << "DESCRIPCION"
             row << "CANTIDAD"
             row << "PRECIO
             UNITARIO"
             row << "PRECIO 
             TOTAL"

             table_content << row 
             puts "apdfdfd"
             puts row 


            row=[]

            row << "01"
            if !@cotizacion.tipo_unidad_id.nil?
              row << @cotizacion.tipo_unidad.name 
            else 
              row << ""
            end 

            if !@cotizacion.config_vehi_id.nil?

              row << @cotizacion.config_vehi.name 
            else 
              row << " "
            end 

            row << @cotizacion.descrip1
            row << @cotizacion.qty
            row << @cotizacion.price
            row << @cotizacion.total 
            table_content << row 


            row=[]

            row << "02"
            if !@cotizacion.tipo_unidad2_id.nil?
             row << @cotizacion.get_tipounidad(@cotizacion.tipo_unidad2_id)
            else 
              row << ""
            end 
            if !@cotizacion.config_vehi2_id.nil?
              row << @cotizacion.get_configvehi(@cotizacion.config_vehi2_id)
            else
              row << ""
            end 
            row << @cotizacion.descrip2
            row << @cotizacion.qty2
            row << @cotizacion.price2
            row << @cotizacion.total2
            table_content << row 

            row=[]
            row << "03"
            if !@cotizacion.tipo_unidad3_id.nil?
              row << @cotizacion.get_tipounidad(@cotizacion.tipo_unidad3_id)
            else 
              row << ""
            end 

            if !@cotizacion.config_vehi3_id.nil?
              puts "cotizacion..."
              puts @cotizacion.config_vehi3_id
             row << @cotizacion.get_configvehi(@cotizacion.config_vehi3_id)
            else
             row << ""
            end 
            row << @cotizacion.descrip3
            row << @cotizacion.qty3
            row << @cotizacion.price3
            row << @cotizacion.total3
            table_content << row 

            row=[]
            row << ""
            row << {:content=>"VALOR TOTAL DEL SERVICIO",:colspan => 5 } 
            row << @cotizacion.total  +  @cotizacion.total2 +  @cotizacion.total3

            table_content << row 
          

            pdf.table table_content , {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width

                                        } do 
                                          rows([0]).font_style = :bold
                                          columns([0]).align=:center
                                          columns([0]).width = 40
                                  
                                          columns([1]).align = :left
                                          columns([1]).width = 80

                                          columns([2]).align = :left
                                          columns([2]).width = 80

                                          columns([3]).align = :right
                                          columns([3]).width = 105.752

                                          columns([4]).align = :right
                                          columns([4]).width = 70

                                          columns([5]).align = :right
                                          columns([5]).width = 70
            
                                          columns([6]).align = :right
                                          columns([6]).width = 90
                                        end 
               #tabl bouxing                            
               end 

              

              if @cotizacion.tipocustomer_id == 1 

                texto = Instruccion.find(7)

                @instruccion1 = texto.description1
                @instruccion2 = texto.description2
                @instruccion3 = texto.description3
                @instruccion4 = texto.description4
                @instruccion5 = texto.instruccion6
                @instruccion7 = texto.instruccion7
                @instruccion8 = texto.instruccion8
                @instruccion9 = texto.instruccion9
                @instruccion10 = texto.instruccion10

              end 

              if @cotizacion.tipocustomer_id == 2

                texto = Instruccion.find(8)

                @instruccion1 = texto.description1
                @instruccion2 = texto.description2
                @instruccion3 = texto.description3
                @instruccion4 = texto.description4
                @instruccion5 = texto.instruccion6
                @instruccion7 = texto.instruccion7
                @instruccion8 = texto.instruccion8
                @instruccion9 = texto.instruccion9
                @instruccion10 = texto.instruccion10

              end 


               if @cotizacion.tipocustomer_id == 3

                texto = Instruccion.find(9)

                @instruccion1 = texto.description1
                @instruccion2 = texto.description2
                @instruccion3 = texto.description3
                @instruccion4 = texto.description4
                @instruccion5 = texto.instruccion6
                @instruccion7 = texto.instruccion7
                @instruccion8 = texto.instruccion8
                @instruccion9 = texto.instruccion9
                @instruccion10 = texto.instruccion10

              end 
               if @cotizacion.tipocustomer_id == 4

                texto = Instruccion.find(10)

                @instruccion1 = texto.description1
                @instruccion2 = texto.description2
                @instruccion3 = texto.description3
                @instruccion4 = texto.description4
                @instruccion5 = texto.instruccion6
                @instruccion7 = texto.instruccion7
                @instruccion8 = texto.instruccion8
                @instruccion9 = texto.instruccion9
                @instruccion10 = texto.instruccion10

              end 

              pdf.bounding_box [40,500], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content => @instruccion1 + @cotizacion.moneda.description + "\n" +  @instruccion5 + 
              @cotizacion.payment.descrip , align: :left, valign: :top, size: 9, :text_color => "000000", 
              :border_width => 0 , :font_style => :italic 
              end
              

             image2_path = "#{Dir.pwd}/public/images/cuentaspereda.jpg"


              pdf.bounding_box [40,440], :width  => pdf.bounds.width - 150,:border_width=> 0 do
              pdf.cell :content =>{:image => image2_path } , align: :center, valign: :top, size: 9, :text_color => "000000", 
              :border_width => 0 , :font_style => :italic 
              end


      

              pdf.bounding_box [40,350], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content => @instruccion7 , align: :left, valign: :top, size: 9, :text_color => "000000", 
              :border_width => 0 , :font_style => :italic 
              end





               pdf.bounding_box [40,310], :width  => pdf.bounds.width,:border_width=> 0 do
               
            table_content =[]
              row=[]
              

             row << "TIPO DE UNIDAD"
             row << "STAND BY DIA"
             
             table_content << row 
          

            row=[]
            row << "CAMIONETA"
            row << @cotizacion.tipounidad1
            table_content << row 


            row=[]
            row << "CAMION"
            row << @cotizacion.tipounidad2
            table_content << row 

            row=[]
            row << "PLATAFORMA"
            row << @cotizacion.tipounidad3
            table_content << row 

            row=[]
            row << "CAMABAJA"
            row << @cotizacion.tipounidad4
            table_content << row 

            row=[]
            row << "MODULAR "
            row << @cotizacion.tipounidad5
              row << @cotizacion.modularobs 
            table_content << row 
row=[]
            row << "CAMACUNA "
            row << @cotizacion.camacuna 
            table_content << row 
             row=[]
            row << "STAND BY "
            row << @cotizacion.stand_by 
            table_content << row 


          

            pdf.table table_content , {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width/3

                                        } do 
                                          rows([0]).font_style = :bold
                                          columns([0]).align = :center
                                      
                                          columns([1]).align = :center
                                        
                                        
                                        end 
              


           end # canvas 




              pdf.bounding_box [40,180], :width  => pdf.bounds.width - 50,:border_width=> 0 do
              pdf.cell :content => @instruccion2 ,
              align: :left , valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end

          #end canvas 
                
          end 




        pdf 

  end 

  ##CLIENTE NUEVOOOOOO

  
  

    def build_pdf_footer3(pdf)

         pdf.font "Times-Roman"  , :size => 9

              image_path = "#{Dir.pwd}/public/images/cotizacion2.jpg"

              table_content0 = []

              table_content0 = ([[{:image => image_path, :fit => [pdf.bounds.width, pdf.bounds.height] }] ])

              pdf.table(table_content0,{ 
              :position => :right,
              :width => pdf.bounds.width,
              :cell_style => {:border_width => 0} }) do
                   columns([0]).font_style = :bold
              end 


       pdf.canvas do 

         pdf.bounding_box [40,740], :width  => pdf.bounds.width - 50,:border_width=> 0 do
              pdf.cell :content => @instruccion3 ,
              align: :left , valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end

         pdf.bounding_box [40,600], :width  => pdf.bounds.width - 50,:border_width=> 0 do
              pdf.cell :content => @instruccion4 + "\n"+ @instruccion8 ,
              align: :left , valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end



 pdf.bounding_box [40,350], :width  => pdf.bounds.width - 50,:border_width=> 0 do
              pdf.cell :content => "Se expide la presente Cotización, con el fin de dar su conformidad y pronta respuesta.
Muy atentamente, " ,
              align: :left , valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end



       end 
      
      pdf
      
     end



  def build_pdf_body4(pdf)

              pdf.font "Times-Roman"  , :size => 9

              image_path = "#{Dir.pwd}/public/images/cotizacion2.jpg"

              table_content0 = []

              table_content0 = ([[{:image => image_path, :fit => [pdf.bounds.width, pdf.bounds.height] }] ])

              pdf.table(table_content0,{ 
              :position => :right,
              :width => pdf.bounds.width,
              :cell_style => {:border_width => 0} }) do
                   columns([0]).font_style = :bold
              end 


       pdf.canvas do 
    
              pdf.bounding_box [340,760 ], :width  => pdf.bounds.width,:border_width=> 0  do
              pdf.cell :content=>"Lima , "+I18n.l(@cotizacion.fecha.to_date, locale: :es ,format: :long )   , align: :right , valign: :top, size: 11  , :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic  
              end

              pdf.bounding_box [20,750], :width  => pdf.bounds.width,:border_width=> 0 do

              pdf.cell :content=> "COTIZACIÓN N°. :"+@cotizacion.code + "\n"+
              "Señores :" + "\n" + @cotizacion.customer.name + "\n" +
              @cotizacion.customer.ruc + "\n" +
              "Atención:" + "\n" + 
                 @cotizacion.customer.sr + " : "+ @cotizacion.customer.contacto , align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end

              pdf.bounding_box [20,680], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> "Es grato dirigirnos  a usted  para comunicarle que de acuerdo a su solicitud, nuestro precio por el servicio" +"\n" + "solicitado es el siguiente. :",
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end


              pdf.font "Times-Roman"  , :size => 8
              pdf.bounding_box [40,650], :width  => pdf.bounds.width,:border_width=> 0 do
               pdf.cell :content=> "RUTA: " + "  " + @cotizacion.punto.name + "-" + @cotizacion.get_punto(@cotizacion.punto2_id),
                align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end


              pdf.bounding_box [40,630], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> "ESPECIFICACIONES DE LA CARGA : " ,
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end


              pdf.bounding_box [50,620], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> @cotizacion.especifica ,
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end
         
              pdf.bounding_box [40,610], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content=> "TIPO DE UNIDAD E IMPORTE DEL SERVICIO  : " ,
              align: :left, valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :bold_italic
              end


              pdf.font "Times-Roman"  , :size => 6


               pdf.bounding_box [40,595], :width  => pdf.bounds.width* 0.9 ,:border_width=> 0 do

              table_content =[]


              row=[]
              

             row << "ITEM"
             row << "TIPO DE UNIDAD"
             row << "CONFIGURACION 
             VEHICULAR"
             row << "DESCRIPCION"
             row << "CANTIDAD"
             row << "PRECIO
             UNITARIO"
             row << "PRECIO 
             TOTAL"

             table_content << row 
             puts "apdfdfd"
             puts row 


            row=[]

            row << "01"
            if !@cotizacion.tipo_unidad_id.nil?
              row << @cotizacion.tipo_unidad.name 
            else 
              row << ""
            end 

            if !@cotizacion.config_vehi_id.nil?

              row << @cotizacion.config_vehi.name 
            else 
              row << " "
            end 

            row << @cotizacion.descrip1
            row << @cotizacion.qty
            row << @cotizacion.price
            row << @cotizacion.total 
            table_content << row 


            row=[]

            row << "02"
            if !@cotizacion.tipo_unidad2_id.nil?
             row << @cotizacion.get_tipounidad(@cotizacion.tipo_unidad2_id)
            else 
              row << ""
            end 
            if !@cotizacion.config_vehi2_id.nil?
              row << @cotizacion.get_configvehi(@cotizacion.config_vehi2_id)
            else
              row << ""
            end 
            row << @cotizacion.descrip2
            row << @cotizacion.qty2
            row << @cotizacion.price2
            row << @cotizacion.total2
            table_content << row 

            row=[]
            row << "03"
            if !@cotizacion.tipo_unidad3_id.nil?
              row << @cotizacion.get_tipounidad(@cotizacion.tipo_unidad3_id)
            else 
              row << ""
            end 

            if !@cotizacion.config_vehi3_id.nil?
              puts "cotizacion..."
              puts @cotizacion.config_vehi3_id
             row << @cotizacion.get_configvehi(@cotizacion.config_vehi3_id)
            else
             row << ""
            end 
            row << @cotizacion.descrip3
            row << @cotizacion.qty3
            row << @cotizacion.price3
            row << @cotizacion.total3
            table_content << row 

            row=[]
            row << ""
            row << {:content=>"VALOR TOTAL DEL SERVICIO",:colspan => 5 } 
            row << @cotizacion.total +  @cotizacion.total2 +  @cotizacion.total3

            table_content << row 
          

            pdf.table table_content , {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width

                                        } do 
                                          rows([0]).font_style = :bold
                                          columns([0]).align=:center
                                          columns([0]).width = 40
                                  
                                          columns([1]).align = :left
                                          columns([1]).width = 80

                                          columns([2]).align = :left
                                          columns([2]).width = 80

                                          columns([3]).align = :right
                                          columns([3]).width = 105.752

                                          columns([4]).align = :right
                                          columns([4]).width = 70

                                          columns([5]).align = :right
                                          columns([5]).width = 70
            
                                          columns([6]).align = :right
                                          columns([6]).width = 90
                                        end 
               #tabl bouxing                            
               end 

              

              if @cotizacion.tipocustomer_id == 1 

                texto = Instruccion.find(7)

                @instruccion1 = texto.description1
                @instruccion2 = texto.description2
                @instruccion3 = texto.description3
                @instruccion4 = texto.description4
                @instruccion5 = texto.instruccion6
                @instruccion7 = texto.instruccion7
                @instruccion8 = texto.instruccion8
                @instruccion9 = texto.instruccion9
                @instruccion10 = texto.instruccion10

              end 

              if @cotizacion.tipocustomer_id == 2

                texto = Instruccion.find(8)

                @instruccion1 = texto.description1
                @instruccion2 = texto.description2
                @instruccion3 = texto.description3
                @instruccion4 = texto.description4
                @instruccion5 = texto.instruccion6
                @instruccion7 = texto.instruccion7
                @instruccion8 = texto.instruccion8
                @instruccion9 = texto.instruccion9
                @instruccion10 = texto.instruccion10

              end 


               if @cotizacion.tipocustomer_id == 3

                texto = Instruccion.find(9)

                @instruccion1 = texto.description1
                @instruccion2 = texto.description2
                @instruccion3 = texto.description3
                @instruccion4 = texto.description4
                @instruccion5 = texto.instruccion6
                @instruccion7 = texto.instruccion7
                @instruccion8 = texto.instruccion8
                @instruccion9 = texto.instruccion9
                @instruccion10 = texto.instruccion10

              end 



               if @cotizacion.tipocustomer_id == 4

                texto = Instruccion.find(10)

                @instruccion1 = texto.description1
                @instruccion2 = texto.description2
                @instruccion3 = texto.description3
                @instruccion4 = texto.description4
                @instruccion5 = texto.instruccion6
                @instruccion7 = texto.instruccion7
                @instruccion8 = texto.instruccion8
                @instruccion9 = texto.instruccion9
                @instruccion10 = texto.instruccion10

              end 


              pdf.bounding_box [40,500], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content => @instruccion1 + @cotizacion.moneda.description + "\n" +  @instruccion5 + 
              @cotizacion.payment.descrip , align: :left, valign: :top, size: 9, :text_color => "000000", 
              :border_width => 0 , :font_style => :italic 
              end
              

      

              pdf.bounding_box [40,450], :width  => pdf.bounds.width,:border_width=> 0 do
              pdf.cell :content => @instruccion7 , align: :left, valign: :top, size: 9, :text_color => "000000", 
              :border_width => 0 , :font_style => :italic 
              end

  pdf.bounding_box [40,350], :width  => pdf.bounds.width - 50,:border_width=> 0 do
              pdf.cell :content => @instruccion4 + "\n" + @instruccion8 ,
              align: :left , valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end


 pdf.bounding_box [40,170], :width  => pdf.bounds.width - 50,:border_width=> 0 do
              pdf.cell :content => "Se expide la presente Cotización, con el fin de dar su conformidad y pronta respuesta.
Muy atentamente, " ,
              align: :left , valign: :top, size: 9, :text_color => "000000", :border_width => 0 ,:font_style => :italic
              end





          #end canvas 
                
          end 




        pdf 

  end 

  ##CLIENTE NUEVOOOOOO

  
  

    def build_pdf_footer4(pdf)

         pdf.font "Times-Roman"  , :size => 9

              image_path = "#{Dir.pwd}/public/images/cotizacion2.jpg"

              table_content0 = []

              table_content0 = ([[{:image => image_path, :fit => [pdf.bounds.width, pdf.bounds.height] }] ])

              pdf.table(table_content0,{ 
              :position => :right,
              :width => pdf.bounds.width,
              :cell_style => {:border_width => 0} }) do
                   columns([0]).font_style = :bold
              end 


       pdf.canvas do 

         
       


       end 
      
      pdf
      
     end







  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cotizacion
      @cotizacion = Cotizacion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cotizacion_params
      params.require(:cotizacion).permit(:fecha, :code, :customer_id, :punto_id, :punto2_id, :moneda_id,:payment_id,
        :tipocargue_id, :tarifa, :processed, :comments,:tipo_unidad,:estado,:especifica,:valorseguro,
        :tipo_unidad_id,
        :tipo_unidad2_id,
        :tipo_unidad3_id,
        :tipo_unidad4_id,
        :tipo_unidad5_id,
        :tipo_unidad6_id,

        :config_vehi_id,
        :config_vehi2_id,
        :config_vehi3_id,

        :config_vehi4_id,
        :config_vehi5_id,
        :config_vehi6_id,


        :descrip1,
        :descrip2,
        :descrip3, 
        :descrip4,
        :descrip5,
        :descrip6, 
        :descrip7,
        :descrip8,
        :descrip9, 
        :descrip10, 

        :qty,
        :qty2,
        :qty3,
        :qty4,
        :qty5,
        :qty6,
        :qty7,
        :qty8,
        :qty9,
        :qty10,

        :price,
        :price2,
        :price3,
        :price4,
        :price5,
        :price6,
        :price7,
        :price8,
        :price9,
        :price10,
        :total,
        :total2,
        :total3,
        :total4,
        :total5,
        :total6,
        :total7,
        :total8,
        :total9,
        :total10,
        :tipounidad1,
        :tipounidad2,
        :tipounidad3,
        :tipounidad4,
        :tipounidad5,
        :modularobs,
        :camacuna,
        :stand_by,
  :tm ,:tipocustomer_id )
    end
end
