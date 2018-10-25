class ManifestsController < ApplicationController
  before_action :set_manifest, only: [:show, :edit, :update, :destroy]

  # GET /manifests
  # GET /manifests.json
  def index
    @manifests = Manifest.find_by_sql(['Select  manifests.id,manifests.code, manifests.solicitante,manifests.fecha1,manifests.telefono1,
    customers.name  from manifests INNER JOIN customers ON manifests.customer_id = customers.id order by code DESC'  ])

  end

  # GET /manifests/1
  # GET /manifests/1.json
  def show
    
  end

  # GET /manifests/new
  def new
    @manifest = Manifest.new
    @customers = @manifest.get_customers()
    @puntos = @manifest.get_puntos()
    @locations = @manifest.get_locations()
    
    @manifest[:code] = "#{generate_guid12()}"
    
    
    @manifest[:fecha1] = Time.now
    
    @manifest[:fecha2] = Time.now
    
  end

  # GET /manifests/1/edit
  def edit
    @customers = @manifest.get_customers()
    @puntos = @manifest.get_puntos()
    @locations = @manifest.get_locations()
    
  end

  # POST /manifests
  # POST /manifests.json
  def create
    @manifest = Manifest.new(manifest_params)
    @customers = @manifest.get_customers()
    @puntos = @manifest.get_puntos()
    @manifest[:company_id] = "1"
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

      pdf.image "#{Dir.pwd}/public/images/logo2.png", :width => 270
        
      pdf.move_down 6
        
      pdf.move_down 4
      #pdf.text supplier.street, :size => 10
      #pdf.text supplier.district, :size => 10
      #pdf.text supplier.city, :size => 10
      pdf.move_down 4

      pdf.bounding_box([325, 725], :width => 200, :height => 80) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C: 20424092941", :align => :center
          pdf.text "SOLICITUD DE TRANSPORTE", :align => :center
          pdf.text "#{@manifest.code}", :align => :center,
                                 :style => :bold
          
        end
      end
      pdf.move_down 25
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text "__________________________________________________________________________", :size => 13, :spacing => 4
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 8

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

        pdf.move_down 20

      end

      headers = []
      table_content = []

      max_rows = [manifest_1.length,manifest_1.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (manifest_1.length >= row ? manifest_1[rows_index] : ['',''])
        
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 1},
          :width => pdf.bounds.width / 2
        }) do
          columns([0, 2]).font_style = :bold

        end

        pdf.move_down 20

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
          :cell_style => {:border_width => 0 },
          :width => pdf.bounds.width 
        }) do
          columns([0, 2 , 4 ]).font_style = :bold

        end

        pdf.move_down 20

      end
      
      # detalle 2
      
      pdf.text "Detalle " , :size => 16, :style => :bold
      pdf.text "Especificacion", :size => 11, :style => :bold
      pdf.move_down 5
      
      pdf.text @manifest.especificacion
      pdf.move_down 10
      
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

        pdf.move_down 20

      end
      
      
      
      
      
      pdf.move_down 10    
      
      
      
      pdf

    end


    def build_pdf_footer(pdf)

        pdf.text "Observaciones Carga :", :size => 11, :style => :bold
        pdf.text @manifest.observa
        pdf.text "Observaciones:  ", :size => 11, :style => :bold
        pdf.text @manifest.observa2
        
        pdf.move_down  20
          
        
        pdf.bounding_box([0, 20], :width => 535, :height => 30) do
        
        pdf.text "_________________               _____________________         ____________________      ", :size => 13, :spacing => 4
        pdf.text ""
        pdf.text "                  Realizado por                                                 V.B.Jefe Compras                                            V.B.Gerencia           ", :size => 10, :spacing => 4
        pdf.draw_text "Company: #{@manifest.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf
      
  end

  
  
 def client_data_headers

  
      client_headers  = [["Local: ", @manifest.location.name ]] 
      client_headers << ["Solicitante : ", @manifest.solicitante]
      client_headers << ["Cliente : ", @manifest.customer.name ]    
      
      
      client_headers
  end

  def invoice_headers   
    
      invoice_headers  = [["Fecha de emisión : ",@manifest.fecha1.strftime("%Y-%m-%d")  ]]

      invoice_headers <<  ["Telefono  : ", @manifest.telefono1 ]    
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
      manifest_3   = [["Punto de Partida : ",@manifest.punto.name ,"Punto de Llegada",@manifest.get_punto(@manifest.punto2_id) ,"Fecha : ",@manifest.fecha2.strftime("%d.%m.%Y") ]]
      manifest_3 <<  ["Contacto 1  : ",@manifest.contacto1,"Telefono 1: ",@manifest.telefono1," ","" ]    
      manifest_3 <<  ["Contacto 2  : ",@manifest.contacto2,"Telefono 2: ",@manifest.telefono2," ","" ] 
      manifest_3
  end
    
   def do_process
    @manifest  = Manifest.find(params[:id])
    @manifest[:processed] = "1"
    @manifest.process
    
    flash[:notice] = "The serviceorder order has been processed."
    redirect_to @manifest 
  end

def do_anular
    @manifest  = Manifest.find(params[:id])
    @manifest[:processed] = "2"
    
    @manifest.anular 
    
    flash[:notice] = "Documento a sido anulado."
    redirect_to @manifest  
  end
  





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manifest
      @manifest = Manifest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manifest_params
      params.require(:manifest).permit(:customer_id, :solicitante, :fecha1, :telefono1, :camionetaqty, :camionetapeso, :camionqty, :camionpeso, :semiqty, :semipeso, :extenqty, :extenpeso, :camaqty, :camapeso, :modularqty, :modularpeso, :punto_id, :punto2_id, :fecha2, :contacto1, :telefono1, :contacto2, :telefono2, :especificacion, :largo, :ancho, :alto, :peso, :bultos, :otros, :observa, :observa2, :company_id,:code,:location_id,:importe)
    end
end
