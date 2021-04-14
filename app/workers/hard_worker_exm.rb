class HardWorkerExm
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: false, backtrace: true 

  
  def perform()
    # Build the big, slow report into a zip file
  
   @company=Company.find(1)      

    @fecha2 = Date.today + 30 
    
    @proyecto_exam  = @company.get_proyecto_exam_empleado_2 


 @directory = "app/pdf_output"
    @namecategoria= "alerts.pdf" 
  

    @key="Examen - #{@namecategoria}"
    
      
            Prawn::Document.generate "#{@directory}/#{@key}" , :page_layout => :landscape , :page_size=> "A4" do |pdf|      
                pdf.font "Helvetica"
                pdf = build_pdf_header_1(pdf)
                pdf = build_pdf_body_1(pdf)
                build_pdf_footer_1(pdf)
              
                
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

       if @user.email == "percywoeds@gmail.com"
        ActionCorreo.notify_followers(@user.email, @user).deliver_now

        end 

  end

  #----------------------------------------------------------------------------------
# REPORTE DE MOVIMIENTO DE STOCK 
#----------------------------------------------------------------------------------
def build_pdf_header_1(pdf)

       pdf.font "Helvetica"  , :size => 8
     image_path = "#{Dir.pwd}/public/images/tpereda2.png"

      @fecha_hoy = Date.today + 30 

       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center },
        {:content => "SISTEMA DE GESTIÓN DE INTEGRADO ",
          :rowspan => 2},"CODIGO ","TP-EC-F-003"], 
          ["VERSION: ","03"], 
          ["STATUS DE INGRESOS A PROYECTOS MINEROS, ALMACENES Y/O PUERTOS : " + @fecha_hoy.strftime("%d/%m/%Y") ,"Pagina: ","1 de 1 "] 
         
          ])
        

       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
            columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 531.34
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
         
      pdf 



  end  

    def build_pdf_body_1(pdf)
    
    pdf.text ""
    pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size => 6

      headers = []
      table_content = []

      ProyectoExam::TABLE_HEADERS.each do |header|605
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem = 1

       for  examen in @proyecto_exam 

             row = []

             row << "Empleado : "
             row << examen.employee.full_name2

              table_content << row

             @proyecto_exam_empleado = @company.get_proyecto_exam_empleado_3(examen.employee_id ) 


            for proyecto_exam in @proyecto_exam_empleado 

              if proyecto_exam.proyecto_minero_exam.proyectominero3.alert == "1"
      
              row = []
              row << nroitem 
              row << ""
              row << ""
              row << proyecto_exam.proyecto_minero_exam.proyecto_minero.descrip
              row << proyecto_exam.proyecto_minero_exam.proyectominero2.name
              row << proyecto_exam.proyecto_minero_exam.proyectominero3.name


              if proyecto_exam.fecha != nil 
            
                row << proyecto_exam.fecha.strftime("%d/%m/%Y") 
              else

                row << ""
              end 
              
        

               nroitem=nroitem + 1

              table_content << row
              end 

            end 

         end
            
    

              result = pdf.table table_content, {:position => :center,
                                                :header => true,
                                                :width => pdf.bounds.width
                                                } do 
                                                  columns([0]).align=:center
                                                  columns([1]).align=:center 
                                                  columns([2]).align=:left
                                                  columns([3]).align=:left
                                                  columns([4]).align=:left  
                                                  columns([5]).align=:left 
                                                  columns([6]).align=:left
                                                  columns([7]).align=:left 
                                                  columns([8]).align=:left
                                                  columns([9]).align=:left
                                                  columns([10]).align=:left
                                                  columns([11]).align=:left
                                                  columns([12]).align=:left  
                                                
                                                  



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
            row << "V.B.VENTAS "
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





