class CampaignExportJob < ActiveJob::Base
  
  def perform(fecha1,fecha2,categoria,estado,local,user)
    # Build the big, slow report into a zip file
  
    @company = Company.find(1)
    @user = user 


   # @movements = @company.get_stocks_inventarios20(fecha1,fecha2,categoria,estado,local)   
      


    # Prawn::Document.generate("app/pdf_output/stocks2.pdf") do |pdf|            
    #     pdf.font_families.update("Open Sans" => {
    #       :normal => "app/assets/fonts/OpenSans-Regular.ttf",
    #       :italic => "app/assets/fonts/OpenSans-Italic.ttf",
    #     })

    #     pdf.font "Open Sans",:size =>6
    #     pdf = build_pdf_header2(pdf)
    #     pdf = build_pdf_body2(pdf)
    #     build_pdf_footer2(pdf)
    #     $lcFileName =  "app/pdf_output/stocks2.pdf"      
        
    # end     



  #  $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName    

   # send_file("app/pdf_output/stocks2.pdf", :type => 'application/pdf', :disposition => 'inline')
 #   MovementDetail.delete_all 

   
        s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"))  

        bucket_name = ENV.fetch("AWS_BUCKET")

        @directory = "app/pdf_output"
        @key="Stock-1-ARTICULOS DE LIMPIEZA.pdf"
        @s3_obj = s3.bucket(bucket_name).object(@key)

          File.open("#{@directory}/#{@key}", 'rb') do |file|
                    @s3_obj.put(body: file)
          end

        download_url = @s3_obj.presigned_url(:get)

        puts "link s3 "
        puts download_url 

        # Record the location of the file

        user.most_recent_report = download_url


        if user.save 
            
         puts  "actul ok "

        end 

            # Notify the user that the download is ready
                
        puts user.email 


        ActionCorreo.notify_followers(user.email, @user).deliver_now

    

  end

  
  



 end





