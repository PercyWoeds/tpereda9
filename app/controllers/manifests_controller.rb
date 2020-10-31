include UsersHelper

include ServicesHelper

class ManifestsController < ApplicationController
 before_action :set_manifest, only: [:show, :edit, :update, :destroy,:sendmail]

  # GET /manifests
  # GET /manifests.json

  
  def index
   
    #Manifest.find_by_sql(['Select  manifests.id,manifests.code, manifests.solicitante,manifests.fecha1,manifests.telefono1,
    #customers.name  from manifests INNER JOIN customers ON manifests.customer_id = customers.id order by code DESC'  ])
   @company = Company.find(1)
  

  if params[:search]
    @manifests = Manifest.search(params[:search]).paginate(:page => params[:page]) 
  else
    @manifests = Manifest.order("CAST ( SUBSTRING(code,1,3) as int),CAST ( SUBSTRING(code,5,13) as int)").paginate(:page => params[:page])


  end

  end

  # GET /manifests/1
  # GET /manifests/1.json
  def show
   @customers = @manifest.get_customers()
    @puntos = @manifest.get_puntos()
    @locations = @manifest.get_locations()
    @cargas = @manifest.get_cargas()

    
  end
  # GET /manifests/new
  
  # Do send invoice via email
  def do_email
    @manifest = Manifest.find(params[:id])
    @email = params[:email]
    
    Notifier.manifest(@email, @manifest).deliver
    
    flash[:notice] = "El documento ha sido enviado con exito ."
    redirect_to "/manifests/#{@manifest.id}"
  end


  def do_anular
    @invoice = Manifest.find(params[:id])


   a = Manifestship.find_by(:manifest_id=> @invoice.id)
    if a 
    flash[:notice] = "Solicitud de Transporte tiene OST asignadas, no se puede anular."
    
    else

    @invoice[:processed] = "2"
    @invoice.anular 
    
    flash[:notice] = "Documento a sido anulado."
    end 
    redirect_to @invoice 



  end
  
  
  # Send invoice via email
  def sendmail
    puts "send mail "
    puts @manifest.code 

    @company  = @manifest.company

    ActionCorreo.st_email(@manifest).deliver_now 
  end

  def sendcancelar 
    
    @company  = Company.find(1)
    @manifest = Manifest.find(params[:id])

  end


  def do_cancelar


    @company =  Company.find(1)
    @manifest = Manifest.find(params[:id])
    @observa  = params[:motivo]
  
    @manifest[:processed] = "3"

     @manifest.update_attributes(:motivo => @observa,:processed =>"3") 
     @manifest.cancelar
    
    
    flash[:notice] = "Motivo grabado."
    redirect_to "/manifests/#{@manifest.id}"

  end

  # Send invoice via email
  def cancela
    @manifest = Manifest.find(params[:id])
    @company = @manifest.company
  end


  def new
    @manifest = Manifest.new
    @customers = @manifest.get_customers()
    @puntos = @manifest.get_puntos()
    @locations = @manifest.get_locations()
    @cargas = @manifest.get_cargas()
    @company =  Company.find(1)
    
    @manifest[:code] = "#{generate_guid12()}"
    @manifest[:importe] = 0.00
    @manifest[:importe2] = 0.00
    
    @manifest[:empaletizado] = 0.00
    @manifest[:montacarga] = 0.00
    @manifest[:escolta] = 0.00
    @manifest[:stand_by] = 0.00
    @manifest[:escolta_pen] = 0.00
    @manifest[:stand_by_pen] = 0.00

    
    @manifest[:fecha1] = Time.now
    
    @manifest[:fecha2] = Time.now
    
  end

  # GET /manifests/1/edit
  def edit
    @customers = @manifest.get_customers()
    @puntos = @manifest.get_puntos()
    @locations = @manifest.get_locations()
    @cargas = @manifest.get_cargas()
    
  end

  # POST /manifests
  # POST /manifests.json
  def create
    @manifest = Manifest.new(manifest_params)
    @customers = @manifest.get_customers()
    @puntos = @manifest.get_puntos()
    @locations = @manifest.get_locations()
    @manifest[:company_id] = "1"
    @cargas = @manifest.get_cargas()

   if  @manifest[:location_id] == 3
      @lcSerie =  1
   end 
   if  @manifest[:location_id] == 1
      @lcSerie =  2
   end 
   if  @manifest[:location_id] == 4
      @lcSerie =  8
   end 
   

   @manifest[:code] = @manifest.generate_manifest_number(@lcSerie)  
  


    respond_to do |format|
      if @manifest.save
        @manifest.correlativo
        
        format.html { redirect_to @manifest, notice: 'Manifest was successfully created.' }
        format.json { render :show, status: :created, location: @manifest }
      else
        format.html { render :new }
        format.json { render json: @manifest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manifests/1
  # PATCH/PUT /manifests/1.json
  def update
    @customers = @manifest.get_customers()
    @puntos = @manifest.get_puntos()
    @locations = @manifest.get_locations()
    @cargas = @manifest.get_cargas()
    @manifest[:user_id] =  current_user.id 


    respond_to do |format|
      if @manifest.update(manifest_params)
        format.html { redirect_to @manifest, notice: 'Manifest was successfully updated.' }
        format.json { render :show, status: :ok, location: @manifest }
      else
        format.html { render :edit }
        format.json { render json: @manifest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manifests/1
  # DELETE /manifests/1.json
  def destroy
    @manifest.destroy
    respond_to do |format|
      format.html { redirect_to manifests_url, notice: 'Manifest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

def pdf
    @manifest  = Manifest.find(params[:id])
    company =@manifest.company_id
    @company =Company.find(company) 
    

    Prawn::Document.generate("app/pdf_output/#{@manifest.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@manifest.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end
  
  
def build_pdf_header(pdf)

      pdf.font "Helvetica"  , :size => 8

     image_path = "#{Dir.pwd}/public/images/tpereda2.png"

      two_dimensional_array0 = [["SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD "],["OCUPACIONAL "],["SOLICITUD DE TRANSPORTE DE CARGA NRO: "+@manifest.code ]]    
      two_dimensional_array1 = [["CODIGO     "],["VERSION"],["PAGINA"]] 
      two_dimensional_array2 = [["TP-CL-F-002    "],["03"],["1 DE 1 "]]
       

      table_content = ([ [{:image=> image_path, :width => 100 },{:content => two_dimensional_array0,:width=>320,},two_dimensional_array1,two_dimensional_array2 ]
                ]) 

      pdf.table(table_content, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold

          
        end


      pdf.move_down 2
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 8

    @texto_ost = " "

      for productItem in @manifest.get_osts()
      
        @texto_ost = " " + productItem.code
  
      
     end
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

        pdf.move_down 5

      end
     


       pdf.text "__________________________________________________________________________", :size => 13, :spacing => 4

       pdf.text " "
       pdf.text "Tipo Carga", :size => 8, :style => :bold
       pdf.text @manifest.tipocargue.name 
    
     max_rows = [manifest_2.length,manifest_2.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (manifest_2.length >= row ? manifest_2[rows_index] : ['',''])
        
      end
      
      
    
      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 1},
          :width => pdf.bounds.width * 0.70
        }) do
          columns([0, 2, 4]).font_style = :bold

        end

        pdf.move_down 10

      end
    # detalle 
      
       max_rows = [manifest_3.length,manifest_3.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (manifest_3.length >= row ? manifest_3[rows_index] : ['',''])
        
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 1 },
          :width => pdf.bounds.width 
        }) do
          columns([0, 2  ]).font_style = :bold

        end

        pdf.move_down 20

      end
      
      # detalle 2
      
     pdf.text "Observaciones:  ", :size => 11, :style => :bold
        pdf.text @manifest.observa
         pdf.move_down  10
          
       
       
      
      
      
      pdf

    end


    def build_pdf_footer(pdf)

        
        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        
        pdf.text "_________________               _____________________         ____________________      ", :size => 13, :spacing => 4
        pdf.text ""
        pdf.text "                  Jefe Comercial                                                 Jefe de Operaciones                                            Recepcion y Despacho           ", :size => 10, :spacing => 4
        pdf.draw_text "Company: #{@manifest.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf
      
  end
  
  
 def client_data_headers
  
      client_headers  = [["Local: ", @manifest.location.name ]] 
      client_headers << ["Cliente : ", @manifest.customer.name ]    
      client_headers << ["OST.: ", @manifest.solicitante+ @texto_ost]
      
      
      client_headers
  end

  def invoice_headers   
    
      invoice_headers  = [["Fecha de emisión : ",@manifest.fecha1.strftime("%Y-%m-%d")  ]]
      invoice_headers <<  ["Estado  : ",@manifest.get_processed ]    
      

      invoice_headers
  end
  
  def invoice_summary
      invoice_summary = []
      invoice_summary << ["Importe",  "0.00"]
      invoice_summary
  end
  
  def manifest_1   
      manifest_1   = [["Camioneta : ",@manifest.camionqty ,@manifest.camionpeso  ]]
      manifest_1 <<  ["Semitrailer: ",@manifest.semiqty,@manifest.semipeso ]    
      manifest_1 <<  ["Extensible : ",@manifest.extenqty,@manifest.extenpeso] 
      manifest_1 <<  ["Camabaja   : ",@manifest.camaqty,@manifest.camapeso ]    
      manifest_1 <<  ["Modular    : ",@manifest.modularqty,@manifest.modularpeso ] 
      manifest_1
  end
  def manifest_2   
      manifest_2   = [["Largo : ",@manifest.largo ,"Ancho",@manifest.ancho,"Alto",@manifest.alto  ]]
      manifest_2 <<  ["Peso : ",@manifest.peso,"Bultos",@manifest.bultos,"Otros",@manifest.otros ]    
      manifest_2
  end
  def manifest_3   
      manifest_3   = [[ "Descripcion de la carga: ",@manifest.especificacion ,"Fecha de  carguio : ",@manifest.fecha2.strftime("%d.%m.%Y") ]]

      manifest_3 <<  ["Punto de carguio : ",@manifest.direccion1 , "Hora de carguio :",@manifest.hora ]

      manifest_3 <<  ["Contacto de carga  : ",@manifest.contacto1,"Telefono : ",@manifest.telefono1 ]    
       
      manifest_3 <<  ["Punto de Descarga",@manifest.direccion2,"","" ]

      manifest_3 <<  ["Contacto de descarga  : ",@manifest.contacto2,"Telefono : ",@manifest.telefono2 ] 

      manifest_3
  end
    
   def do_process
    @manifest  = Manifest.find(params[:id])
    @manifest[:processed] = "1"


    @manifest.process
    
    flash[:notice] = "El documento ha sido procesado."
    redirect_to @manifest 
  end

  def do_anularx
      @manifest  = Manifest.find(params[:id])
      @manifest[:processed] = "2"
      
      @manifest.anular 
      
      flash[:notice] = "Documento a sido anulado."
      redirect_to @manifest  
  end

#####################
def self.search(search)
      where("code LIKE ?", "%#{search}%") 
        
  end

def add_manifest

@friend = Manifest.find(params[:friend])

current_user.friendships.build(friend_id: @friend.id)

if current_user.save

redirect_to my_friends_path, notice: "Friend was successfully added."

else

redirect_to my_friends_path, flash[:error] = "There was an error with adding user as friend."

end

end


######################

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manifest
      @manifest = Manifest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manifest_params
      params.require(:manifest).permit(:customer_id,:processed,:date_processed,:solicitante, :fecha1, :telefono1, :camionetaqty, :camionetapeso, :camionqty, :camionpeso, :semiqty, :semipeso, :extenqty, :extenpeso, :camaqty, :camapeso, :modularqty, :modularpeso, :punto_id, :punto2_id, :fecha2, :contacto1, :telefono1, :contacto2, :telefono2, :especificacion, :largo, :ancho, :alto, :peso, :bultos, :otros, :observa, :observa2, :company_id,:code,:location_id,:importe,:hora,:tipocargue_id,:direccion1,:direccion2,:importe,:importe2,:empaletizado,:montacarga,:escolta,:stand_by,:cotizacion,:escolta_pen,:stand_by_pen)
    end
end
