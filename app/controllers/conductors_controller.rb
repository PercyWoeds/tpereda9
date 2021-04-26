class ConductorsController < ApplicationController
  before_action :set_conductor, only: [:show, :edit, :update, :destroy]

  

  # GET /conductors
  # GET /conductors.json
  def index
    @conductors = Conductor.order(:employee_id,:created_at )


    @company = Company.find(1)


 @facturas_rpt = @company.get_conductor   
 
 respond_to do |format|
    format.html
    format.xls # { send_data @products.to_csv(col_sep: "\t") }
  end

  end

  # GET /conductors/1
  # GET /conductors/1.json
  def show
  end


  def import
      Conductor.import(params[:file])
       redirect_to root_url, notice: "Conductores  importadas."
  end 



  # GET /conductors/new
  def new
    @conductor = Conductor.new
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @conductor[:expedicion_licencia] = Date.today
    @conductor[:revalidacion_licencia] = Date.today


    @conductor[:expedicion_licencia_especial] = Date.today
    @conductor[:revalidacion_licencia_especial] = Date.today

  
    @conductor[:dni_emision] = Date.today
    @conductor[:dni_caducidad] = Date.today

    @conductor[:ap_emision] = Date.today
    @conductor[:ap_caducidad] = Date.today

    @conductor[:ape_emision] = Date.today
    @conductor[:ape_caducidad] = Date.today

  
    @conductor[:active] = 1

  end

  # GET /conductors/1/edit
  def edit
    @company = Company.find(1)
    @empleados = @company.get_employees()
  end

  # POST /conductors
  # POST /conductors.json
  def create


    @conductor = Conductor.new(conductor_params)

    @conductor[:user_id] =  @current_user.id 
    @company = Company.find(1)
    @empleados = @company.get_employees()

     

     if !params[:cv].empty? 

        @key= params[:cv]

        path = Tempfile.new("data_#{@key}").path


        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")
       
        @s3_obj = s3.bucket(bucket_name).object(@key)


         if @s3_obj.exists? && @s3_obj.last_modified.to_date == Date.current
             
              @s3_obj.delete
            
         end

          File.open(path , 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file
        
       
        @conductor[:cv_url ] = download_url
       end 


     if !params[:cv1].empty? 

        @key= params[:cv1]
        
        path = Tempfile.new("data_#{@key}").path

        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")
       
        @s3_obj = s3.bucket(bucket_name).object(@key)


         if @s3_obj.exists? && @s3_obj.last_modified.to_date == Date.current
             
              @s3_obj.delete
            
         end

          File.open(path , 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file
        
       
        @conductor[:cv1_url ] = download_url
       end 


        if !params[:cv2].empty? 

        @key= params[:cv2]


        path = Tempfile.new("data_#{@key}").path


        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")
       
        @s3_obj = s3.bucket(bucket_name).object(@key)


         if @s3_obj.exists? && @s3_obj.last_modified.to_date == Date.current
             
              @s3_obj.delete
            
         end

          File.open(path , 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file
        
       
        @conductor[:cv2_url ] = download_url
       end 

        if !params[:cv3].empty? 

        @key= params[:cv3]
        
        path = Tempfile.new("data_#{@key}").path

        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")
       
        @s3_obj = s3.bucket(bucket_name).object(@key)


         if @s3_obj.exists? && @s3_obj.last_modified.to_date == Date.current
             
              @s3_obj.delete
            
         end

          File.open(path , 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file
        
       
        @conductor[:cv3_url ] = download_url
       end 
     




    respond_to do |format|
      if @conductor.save
        format.html { redirect_to @conductor, notice: 'Conductor was successfully created.' }
        format.json { render :show, status: :created, location: @conductor }
      else
        format.html { render :new }
        format.json { render json: @conductor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conductors/1
  # PATCH/PUT /conductors/1.json
  def update
    @company = Company.find(1)
    @empleados = @company.get_employees()


     if !params[:cv].empty? 

        @key= params[:cv]

        path = Tempfile.new("data_#{@key}").path


        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")
       
        @s3_obj = s3.bucket(bucket_name).object(@key)


         if @s3_obj.exists? && @s3_obj.last_modified.to_date == Date.current
             
              @s3_obj.delete
            
         end

          File.open(path , 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file
        
       
        @conductor[:cv_url ] = download_url
       end 


     if !params[:cv1].empty? 

        @key= params[:cv1]
        
        path = Tempfile.new("data_#{@key}").path

        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")
       
        @s3_obj = s3.bucket(bucket_name).object(@key)


         if @s3_obj.exists? && @s3_obj.last_modified.to_date == Date.current
             
              @s3_obj.delete
            
         end

          File.open(path , 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file
        
       
        @conductor[:cv1_url ] = download_url
       end 


        if !params[:cv2].empty? 

        @key= params[:cv2]


        path = Tempfile.new("data_#{@key}").path


        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")
       
        @s3_obj = s3.bucket(bucket_name).object(@key)


         if @s3_obj.exists? && @s3_obj.last_modified.to_date == Date.current
             
              @s3_obj.delete
            
         end

          File.open(path , 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file
        
       
        @conductor[:cv2_url ] = download_url
       end 

        if !params[:cv3].empty? 

        @key= params[:cv3]
        
        path = Tempfile.new("data_#{@key}").path

        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")
       
        @s3_obj = s3.bucket(bucket_name).object(@key)


         if @s3_obj.exists? && @s3_obj.last_modified.to_date == Date.current
             
              @s3_obj.delete
            
         end

          File.open(path , 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file
        
       
        @conductor[:cv3_url ] = download_url
       end 


        @conductor[:cv] = params[:cv]
        @conductor[:cv1] = params[:cv1]
        @conductor[:cv2] = params[:cv2]
        @conductor[:cv3] = params[:cv3]

    respond_to do |format|
      if @conductor.update(conductor_params)
        format.html { redirect_to @conductor, notice: 'Conductor was successfully updated.' }
        format.json { render :show, status: :ok, location: @conductor }
      else
        format.html { render :edit }
        format.json { render json: @conductor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conductors/1
  # DELETE /conductors/1.json
  def destroy
    @conductor.destroy
    
    respond_to do |format|
      format.html { redirect_to conductors_url, notice: 'Conductor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


   
  def excel

    @company=Company.find(1)          
  

    @facturas_rpt = @company.get_conductor     

    respond_to do |format|
      format.html    
        format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end 
  end 


def pdf

    @company=Company.find(params[:id])          
   
   

    
    @facturas_rpt = @company.get_conductor 


        Prawn::Document.generate "app/pdf_output/TP_EC_F009.pdf" , :page_layout => :landscape ,:page_size=>"A4"  do |pdf|
            pdf.font "Helvetica"
            pdf = build_pdf_header_rpt8a(pdf)
            pdf = build_pdf_body_rpt8a(pdf)
            build_pdf_footer_rpt8a(pdf)
            $lcFileName =  "app/pdf_output/TP_EC_F009.pdf"              
        end     
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
        send_file("app/pdf_output/TP_EC_F009.pdf", :type => 'application/pdf', :disposition => 'inline')    
 
  end




###################################################################################################
##REPORTE DE COMPRAS FACTURAS CREDITOS 1
###################################################################################################


  def build_pdf_header_rpt8a(pdf)
      pdf.font "Helvetica" , :size => 8
      image_path = "#{Dir.pwd}/public/images/tpereda2.png"

    
      
       table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTIÓN INTEGRADO",:rowspan => 2},"CODIGO ","TP-EC-F-009"], 
          ["VERSION: ","2"], 
          ["CONTROL DE INFORMACIÓN DE DOCUMENTOS - CONDUCTORES","Pagina: ","1 de 1 "] 
         
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

  def build_pdf_body_rpt8a(pdf)

    
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Conductor::TABLE_HEADERS2.each do |header|
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

    
       row = []

       for  product in @facturas_rpt

        
                               
                row = []          
                row << nroitem.to_s
                row << product.employee.lastname + product.employee.firstname
              
             
                row << product.employee.fecha_ingreso.strftime("%d/%m/%Y")
                row << product.lugar 
                row << product.anio 
                if product.dni_emision != nil 
                row << product.dni_emision.strftime("%d/%m/%Y")
              else
                row << "-"
              end 

              if product.dni_caducidad != nil 
                row << product.dni_caducidad.strftime("%d/%m/%Y")
                 else
                row << "-"
              end 

              if product.ap_emision != nil 

                row << product.ap_emision.strftime("%d/%m/%Y")
              else
                row << "-"
              end 

              if product.ap_caducidad != nil 
                row << product.ap_caducidad.strftime("%d/%m/%Y")

              else 
                 row << "-"
              end 

              if product.ape_emision != nil 

                row << product.ape_emision.strftime("%d/%m/%Y")
              else
                  row << "-"
              end 


              if product.ape_caducidad != nil 
                row << product.ape_caducidad.strftime("%d/%m/%Y")
              else 
            row << "-"
              end 



                row << product.licencia 
                row << product.categoria

                if  product.expedicion_licencia != nil 
                row << product.expedicion_licencia.strftime("%d/%m/%Y")

              else 

                row << "-"
              end 
              if  product.revalidacion_licencia != nil 
                row << product.revalidacion_licencia.strftime("%d/%m/%Y")

                  else 

                row << "-"
              end 


                row << product.categoria_especial


                if  product.expedicion_licencia_especial != nil 


                row << product.expedicion_licencia_especial.strftime("%d/%m/%Y")

              else 

                row << "-"
              end 

              if product.revalidacion_licencia_especial != nil 

                row << product.revalidacion_licencia_especial.strftime("%d/%m/%Y")


              else 

                row << "-"
              end 
                row << product.iqbf 

                row << product.nivel_educativo 

               
                
                table_content << row

                nroitem = nroitem + 1
           

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
          
          row << ""
          
          row << ""
          row << ""
          row << ""                 
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
                                           columns([1]).width = 80   
                                          columns([2]).align=:left
                                           columns([2]).width = 40

         
                                          columns([3]).align=:left
                                           columns([3]).width = 40      
                                          
                                          columns([4]).align=:left
                                          columns([3]).width = 60  

                                          columns([5]).width = 40                                                                        
         
                                          columns([6]).width = 40                                                                           
         
                                          columns([7]).align=:right
                                          columns([7]).width = 40
                                          
                                          columns([8]).align=:right 
                                          columns([8]).width =40
                                          
                                          columns([9]).align=:right 
                                          columns([9]).width =40
                                          
                                          columns([10]).align=:left
                                          columns([10]).width =40
                                          columns([11]).width =44
                                          columns([12]).width =25
                                          columns([13]).width =40
                                          columns([14]).width =40
                                          columns([15]).width =40
                                          columns([16]).width =40
                                          columns([17]).width =40

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



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conductor
      @conductor = Conductor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conductor_params
      params.require(:conductor).permit(:lugar, :anio, :licencia, :categoria, :expedicion_licencia, 
        :revalidacion_licencia, :categoria_especial, :expedicion_licencia_especial,
        :revalidacion_licencia_especial, :iqbf, :fecha_emision, :dni_emision, :dni_caducidad, 
        :ap_emision, :ap_caducidad, :ape_emision, :ape_caducidad, :user_id, :company_id, :active, 
        :employee_id,:anio1,:anio2,:anio3,:anio4,:cv,:cv1,:cv2,:cv3,:nivel_educativo,:cv_url,:cv1_url,:cv2_url,:cv3_url )
    end
end
