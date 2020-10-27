class HardWorkerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: false, backtrace: true 

  
  def perform(fecha1,fecha2,categoria,estado,local,user_id)
    # Build the big, slow report into a zip file
  
    @company = Company.find(1)
    @user = User.find(user_id)
    @fecha1 = fecha1 
    @fecha2 = fecha2 
    
    @directory = "app/pdf_output"
    @namecategoria= @company.get_categoria_name(categoria)   
    @local_name= @company.get_almacen_name(local) 

    @key="Stock-#{categoria}-#{@namecategoria}"
    @movements = @company.get_stocks_inventarios20(fecha1,fecha2,categoria,estado,local)   
    


    Prawn::Document.generate("#{@directory}/#{@key}") do |pdf|            
        pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6
        pdf = build_pdf_header2(pdf)
        pdf = build_pdf_body2(pdf)
        build_pdf_footer2(pdf)
       
        
    end     

   
        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")
       
        @s3_obj = s3.bucket(bucket_name).object(@key)


         if @s3_obj.exists? && @s3_obj.last_modified.to_date == Date.current
             
              @s3_obj.delete
            
         end

          File.open("#{@directory}/#{@key}", 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file
        

        @user.most_recent_report = download_url


        if @user.save 
            
         puts  "actul ok "

        end 

            # Notify the user that the download is ready
                
       # puts user.email 


        ActionCorreo.notify_followers(@user.email, @user).deliver_now

    

  end

  #----------------------------------------------------------------------------------
# REPORTE DE MOVIMIENTO DE STOCK 
#----------------------------------------------------------------------------------

  def build_pdf_header2(pdf)
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


      pdf.move_down 15
      pdf 
  end   

  def build_pdf_body2(pdf)
    
    pdf.text "Stocks de Productos :"+@local_name  +" Desde : "+@fecha1.to_s + " Hasta: "+@fecha2.to_s   , :size => 11 
    pdf.text " Categoria : " + @namecategoria , :size => 11 
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Stock::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end


      table_content << headers

      nroitem=1
      @cantidad1 = 0
      @cantidad2 = 0
      @cantidad3 = 0
      @cantidad = 0

      @totales  = 0
        

       for  stock in @movements 
          puts stock.product.id 
          puts stock.product.name

              row = []
              row << nroitem.to_s
              row << stock.product.code
              row << stock.product.name

             if stock.product.unidad.nil? 
                row << ""
               else 
                 row << stock.product.unidad.descrip 
               end 


              row << stock.product.ubicacion 

               saldo = stock.stock_inicial  + stock.ingreso - stock.salida       
                if (stock.price == 0  and saldo > 0)
                  stock.price = 1.0
                end 
                if stock.product.code.strip == "20108"
                    stock.price = 60.00
                end

                if stock.product.code.strip == "91231"
                    stock.price = 35.00
                end
                if stock.product.code.strip == "10409"
                    stock.price = 1.25
                end

              row << sprintf("%.3f",stock.price.round(3).to_s)
              row << sprintf("%.2f",stock.stock_inicial.round(2).to_s)         
              row << sprintf("%.2f",stock.ingreso.round(2).to_s)
              row << sprintf("%.2f",stock.salida.round(2).to_s)

             

              row << sprintf("%.2f",saldo.round(2).to_s)

             

              if stock.price 
              @total = saldo * stock.price                         
              else
              @total = 0.0
              end
              row << sprintf("%.2f",@total.round(2).to_s)
                if (stock.price == 0  and saldo > 0) ||  saldo < 0
                  #  row << "NX*"
                else
                  
                end 
              @cantidad1 += stock.stock_inicial 
              @cantidad2 += stock.ingreso 
              @cantidad3 += stock.salida  
              @cantidad  += saldo 

              @totales  += @total 

              table_content << row
              nroitem=nroitem + 1
              end 



           row = []
            row << ""
            row <<""          
            row << "TOTALES GENERAL"
            row << ""            
            row << ""            
            row <<""          
            row << sprintf("%.2f",@cantidad1.round(2).to_s)
            row << sprintf("%.2f",@cantidad2.round(2).to_s)                                  
            row << sprintf("%.2f",@cantidad3.round(2).to_s)
            row << sprintf("%.2f",@cantidad.round(2).to_s)
            row << sprintf("%.2f",@totales.round(2).to_s)
            
            table_content << row


      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left  
                                          columns([2]).width = 200
                                          columns([3]).align=:left  
                                          columns([4]).align=:right
                                          columns([5]).align=:right 
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                          columns([10]).align=:right
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer2(pdf)

        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf      
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
  
  



 end





