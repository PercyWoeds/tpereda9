class QuotationsController < ApplicationController
  before_action :set_quotation, only: [:show, :edit, :update, :destroy]

  # GET /quotations
  # GET /quotations.json
  def index


    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'quotations'
    @pagetitle = "Cotizaciones"

  end

  # GET /quotations/1
  # GET /quotations/1.json
  def show

    @quotations = Quotation.find(params[:id])
    @locations = Location.find(@quotations.location_id)
    @divisions = Division.find(@quotations.division_id)
    @customers = Customer.find(@quotations.customer_id)
    @puntos = Punto.find(@quotations.punto_id)  

  
  end

  # GET /quotations/new
  def new
    @quotation = Quotation.new
    
    @puntos = Punto.all
    @customers = Customer.all.order(:name)
    @quotation[:code]="#{generate_guid7()}"
   
    @instruccions = Instruccion.all 

    @company = Company.find(params[:company_id])
    @quotation.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions
    @monedas = Moneda.all 
    
    @employees = Employee.all.order(:full_name)    
    
    
    @quotation[:fecha1] =  Date.today

  end

  # GET /quotations/1/edit
  def edit
    @locations = Location.all
    @divisions = Division.all
    @puntos = Punto.all
    @customers = Customer.all.order(:name)
    @monedas = Moneda.all 
    @employees = Employee.all.order(:full_name)    
  
  end

  # POST /quotations
  # POST /quotations.json
  def create
    @quotation = Quotation.new(quotation_params)
    
    @puntos =Punto.all
    @customers = Customer.all.order(:name)
    @employees = Employee.all.order(:full_name)    
    @monedas = Moneda.all 
    
    @company = Company.find(params[:quotation][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @quotation[:user_id] = current_user.id
    
    respond_to do |format|
      if @quotation.save
         @quotation.correlativo

        format.html { redirect_to @quotation, notice: 'Quotation was successfully created.' }
        format.json { render :show, status: :created, location: @quotation }
      else
        format.html { render :new }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotations/1
  # PATCH/PUT /quotations/1.json
  def update
    @locations = Location.all
    @divisions = Division.all
    @puntos =Punto.all
    @customers = Customer.all.order(:name)
    @employees = Employee.all.order(:full_name) 
    @monedas = Moneda.all 

    respond_to do |format|
      if @quotation.update(quotation_params)
        format.html { redirect_to @quotation, notice: 'Quotation was successfully updated.' }
        format.json { render :show, status: :ok, location: @quotation }
      else
        format.html { render :edit }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotations/1
  # DELETE /quotations/1.json
  def destroy
    @quotation.destroy
    respond_to do |format|
      format.html { redirect_to quotations_url, notice: 'Quotation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
# Show purchases for a company
  def list_quotations

    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Cotizaciones"
    @filters_display = "block"
    
    @locations = Location.where(company_id: @company.id).order("name ASC")
    @divisions = Division.where(company_id: @company.id).order("name ASC")
    

    if(params[:search] and params[:search] != "")         
  
        @quotations = Quotation.where(["company_id = ? and (documento LIKE  ?)", @company.id,"%" + params[:search] + "%"]).order('id').paginate(:page => params[:page]) 
       
        else
          @quotations = Quotation.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end

  end
  
   def get_services    
    @itemservices = Quotation.where(self.id)
    return @itemservices
  end
  
   def pdf
    @quotation  = Quotation.find(params[:id])
    company =@quotation.company_id
    @company =Company.find(company)


    Prawn::Document.generate("app/pdf_output/#{@quotation.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@quotation.id}.pdf"      
        
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
          pdf.text "COTIZACION", :align => :center
          pdf.text "#{@quotation.code}", :align => :center,
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

      Quotation::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @quotation.get_products()
            row = []
            row << product.tipo_unidad         
            row << product.importe 
  
            table_content << row
            nroitem=nroitem + 1
        end

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:left
                                          columns([1]).align=:left
                                          
                                         
                                        end

      pdf.move_down 10      
      pdf.table invoice_summary, {
        :position => :right,
        :cell_style => {:border_width => 1},
        :width => pdf.bounds.width/3
      } do
        columns([0]).font_style = :bold
        columns([1]).align = :right
        
      end
      pdf

    end


    def build_pdf_footer(pdf)

        pdf.text ""
        pdf.text ""  
        pdf.move_down  20
        
        if @quotation.op1 != "0"
          @detalle = @quotation.condiciones
        end
        
        if @quotation.op2 != "0"
          @detalle = @quotation.respon 
        end
        if @quotation.op3 != "0"
          @detalle = @quotation.seguro 
        end
        
        data =[[@detalle ],
               [""]   
               ]

           {:border_width=>0  }.each do |property,value|
            pdf.text " Condiciones : "
            pdf.table(data,:cell_style=> {property =>value})
            pdf.move_down 20          
           end     

        pdf.text "Agradecemos anticipadamente la atencion al presente , y a la espera de su pronta respuesta"
        
        pdf.bounding_box([0, 26], :width => 535, :height => 40) do
        pdf.text "_________________               _____________________         ____________________      ", :size => 13, :spacing => 4
        pdf.text " Vilma Vega Moreno"
        pdf.text " Jefe Comercial   ", :size => 10, :spacing => 4
        pdf.draw_text "Company: #{@quotation.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf
      
  end

  
  
 def client_data_headers

  
      client_headers  = [["Local: ", @quotation.location.name ]] 
      client_headers << ["Solicitante : ", @quotation.division.name]
      client_headers << ["Cliente : ", @quotation.customer.name ]    
      
      
      client_headers
  end

  def invoice_headers   
    
      invoice_headers  = [["Fecha de emisión : ",@quotation.fecha1.strftime("%Y-%m-%d")  ]]
      invoice_headers <<  ["Tipo de moneda : ", @quotation.moneda.symbol ]
      invoice_headers <<  ["Lugar destino  : ", @quotation.punto.name ]    
      invoice_headers <<  ["Estado  : ",@quotation.get_processed ]    
      invoice_headers
  end
  
  def invoice_summary
      invoice_summary = []
      invoice_summary << ["Costo Total " + @quotation.moneda.symbol ,  ActiveSupport::NumberHelper::number_to_delimited(@quotation.importe,delimiter:",",separator:".").to_s]
      invoice_summary
    end
   def do_process
    @quotation = Quotation.find(params[:id])
    @quotation[:processed] = "1"
    @quotation.process
    
    flash[:notice] = "The serviceorder order has been processed."
    redirect_to @quotation
  end

def do_anular
    @quotation = Quotation.find(params[:id])
    @quotation[:processed] = "2"
    
    @quotation.anular 
    
    flash[:notice] = "Documento a sido anulado."
    redirect_to @quotation 
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotation
      @quotation = Quotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quotation_params
      params.require(:quotation).permit(:fecha1, :code, :customer_id, :punto_id, :carga, :tipo_unidad, :importe, :condiciones, :respon, :seguro, :firma_id, :company_id, :location_id, :division_id,:company_id,:moneda_id ,:user_id,:op1,:op2,:op3)
    end
end 
