class AutoviaticsController < ApplicationController
  before_action :set_autoviatic, only: [:show, :edit, :update, :destroy]

  # GET /autoviatics
  # GET /autoviatics.json
  def index
    @autoviatics = Autoviatic.all
  end

  # GET /autoviatics/1
  # GET /autoviatics/1.json
  def show

     @company = Company.find(1)
    @locations = @company.get_locations 
    @employees = @company.get_employees 
    @tramits = @company.get_tramits
    @tipo_tramits = @company.get_tipo_tramits
    @antecedents = @company.get_antecedents
    @proyecto_mineros = @company.get_proyecto_minero 
    @suppliers_clinica = @company.get_supplier_clinica 
    @tecnic_revisions = @company.get_revision_tecnica
    @trucks = @company.get_trucks 
    @antecedents = @company.get_antecedents
  end

  # GET /autoviatics/new
  def new
    @autoviatic = Autoviatic.new
    @company = Company.find(1)
    @locations = @company.get_locations 
    @employees = @company.get_employees 
    @tramits = @company.get_tramits
    @tipo_tramits = @company.get_tipo_tramits
    @antecedents = @company.get_antecedents
    @proyecto_mineros = @company.get_proyecto_minero 
    @suppliers_clinica = @company.get_supplier_clinica 
    @tecnic_revisions = @company.get_revision_tecnica
    @trucks = @company.get_trucks 
    @antecedents = @company.get_antecedents
    
    @autoviatic[:movilidad] = 0
    @autoviatic[:almuerzo] = 0
    @autoviatic[:otros] = 0
    @autoviatic[:fecha] = Date.today  
   


  end

  # GET /autoviatics/1/edit
  def edit

    @company = Company.find(1)
    @locations = @company.get_locations 
    @employees = @company.get_employees 
    @tramits = @company.get_tramits
    @tipo_tramits = @company.get_tipo_tramits
    @antecedents = @company.get_antecedents
    @proyecto_mineros = @company.get_proyecto_minero 
    @suppliers_clinica = @company.get_supplier_clinica 
    @tecnic_revisions = @company.get_revision_tecnica
    @trucks = @company.get_trucks 
    @antecedents = @company.get_antecedents
    
  end

  # POST /autoviatics
  # POST /autoviatics.json
  def create
    @autoviatic = Autoviatic.new(autoviatic_params)

    @company = Company.find(1)
    @locations = @company.get_locations 
    @employees = @company.get_employees 
    @tramits = @company.get_tramits
    @tipo_tramits = @company.get_tipo_tramits
    @antecedents = @company.get_antecedents
    @proyecto_mineros = @company.get_proyecto_minero 
    @suppliers_clinica = @company.get_supplier_clinica 
    @tecnic_revisions = @company.get_revision_tecnica
    @trucks = @company.get_trucks 
    @antecedents = @company.get_antecedents

    @lcSerie = "1"
    @autoviatic[:code] = @autoviatic.generate_number(@lcSerie)  
    @autoviatic[:processed]  = "0"
    


    respond_to do |format|
      if @autoviatic.save
        format.html { redirect_to @autoviatic, notice: 'Autoviatic was successfully created.' }
        format.json { render :show, status: :created, location: @autoviatic }
      else
        format.html { render :new }
        format.json { render json: @autoviatic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /autoviatics/1
  # PATCH/PUT /autoviatics/1.json
  def update
    @company = Company.find(1)
    @locations = @company.get_locations 
    @employees = @company.get_employees 
    @tramits = @company.get_tramits
    @tipo_tramits = @company.get_tipo_tramits
    @antecedents = @company.get_antecedents
    @proyecto_mineros = @company.get_proyecto_minero 
    @suppliers_clinica = @company.get_supplier_clinica 
    @tecnic_revisions = @company.get_revision_tecnica
    @trucks = @company.get_trucks 
    @antecedents = @company.get_antecedents
    

    respond_to do |format|
      if @autoviatic.update(autoviatic_params)
        format.html { redirect_to @autoviatic, notice: 'Autoviatic was successfully updated.' }
        format.json { render :show, status: :ok, location: @autoviatic }
      else
        format.html { render :edit }
        format.json { render json: @autoviatic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /autoviatics/1
  # DELETE /autoviatics/1.json
  def destroy
    @autoviatic.destroy
    respond_to do |format|
      format.html { redirect_to autoviatics_url, notice: 'Autoviatic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end





  def pdf
    @autoviatic = Autoviatic.find(params[:id])
  
    @company =Company.find(1) 
    


    Prawn::Document.generate("app/pdf_output/#{@autoviatic.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        @lcFileName =  "app/pdf_output/#{@autoviatic.id}.pdf"      
        
    end     

    @lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+@lcFileName      
              send_file("#{@lcFileName1}", :type => 'application/pdf',
    :disposition => 'inline')
  
  end
  
  
def build_pdf_header(pdf)

      pdf.font "Helvetica"  , :size => 8

     image_path = "#{Dir.pwd}/public/images/tpereda2.png"
      
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center}, {:content =>"SISTEMA DE GESTIÓN INTEGRADO",:rowspan => 2},"CODIGO ","TP-EC-F-014"], 
          ["VERSION: ","2"], 
          ["AUTORIZACIÓN DE VIÁTICOS PARA EXÁMENES MÉDICOS - CAPACITACIONES","Pagina: ","1 de 1 "] 
         
          ])
    


       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 261.45
            columns([1]).align = :center
            columns([3]).align = :center
            
            columns([2]).width = 80
          
            columns([3]).width = 80
      
         end
        
      
         
         pdf.move_down 2
      
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text " ", :size => 10, :spacing => 4
    pdf.font "Helvetica" , :size => 6
    @texto_ost = " "

     

     
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
      
  
    # detalle 


         table_content_t1 = ([["1.DETALLE  "]])

         pdf.table(table_content_t1,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 540
            
         end 


      
       max_rows = [exm_2.length,exm_2.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (exm_2.length >= row ? exm_2[rows_index] : ['',''])
        
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

        table_content_t2 = ([["OBSERVACIONES "]])

         pdf.table(table_content_t2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 540
            
         end 


       max_rows = [exm_3.length,exm_3.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (exm_3.length >= row ? exm_3[rows_index] : ['',''])
        
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

      
      pdf

    end


    def build_pdf_footer(pdf)

        
        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        
        pdf.text "___________________                                                                  _____________________                                         ______________________      ", :size => 8, :spacing => 4
        pdf.text ""   
        pdf.text "                  EXM.MEDICOS Y CAPACITACION                                                 JEFE OPERACIONES                                        ADMINISTRACION         ", :size => 8, :spacing => 4
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf
      
  end



 def client_data_headers
  
      client_headers  = [["LOCAL : ", @autoviatic.location.name ]] 
      client_headers << ["PROYECTO  : ", @autoviatic.proyecto_minero.descrip ] 
      client_headers
  end

def invoice_headers   
    
      invoice_headers  = [["NRO.: ",@autoviatic.code   ]]
      invoice_headers <<  ["Estado  : ",@autoviatic.get_processed ]  

      invoice_headers
  end


  def exm_2
     
     @total = @autoviatic.movilidad + @autoviatic.almuerzo + @autoviatic.otros 


       puts @total
       puts @autoviatic.supplier.name 
       puts sprintf("%.2f",@autoviatic.movilidad.to_s) 
       puts sprintf("%.2f",@autoviatic.almuerzo.to_s)
       puts sprintf("%.2f",@autoviatic.otros.to_s)
       puts sprintf("%.2f",@total.to_s)
       puts @autoviatic.hora_ingreso.strftime("%I:%M%p")

      exm_2   = [[ "COLABORADOR:: ",@autoviatic.employee.full_name  ,"FECHA : ",@autoviatic.fecha.strftime("%d/%m/%Y") ]]
      exm_2 <<  ["TEMA : ",@autoviatic.tema  , " ","" ]
      exm_2 <<  ["CLINICA/CAPACITACION: ",@autoviatic.supplier.name  ,"",""  ]    
      exm_2 <<  ["MOVILIDAD : ",sprintf("%.2f",@autoviatic.movilidad.to_s)   ,"LUGAR:",@autoviatic.lugar1 ]    
      exm_2 <<  ["ALMUERZO: ",sprintf("%.2f",@autoviatic.almuerzo.to_s)  ,"LUGAR:",@autoviatic.lugar2   ]    
      exm_2 <<  ["OTROS : ",sprintf("%.2f",@autoviatic.otros.to_s) ,"LUGAR:",@autoviatic.lugar3   ]    
      exm_2 <<  ["TOTAL : ",sprintf("%.2f",@total.to_s) ,"OBSERV:",@autoviatic.obser   ] 
      exm_2 <<  ["LUGAR INGRESO : ",@autoviatic.lugar_salida ,"LUGAR SALIDA ",@autoviatic.lugar_salida2   ] 
      exm_2 <<  ["HORA INGRESO : ",@autoviatic.hora_ingreso.strftime("%I:%M%p")  ,"HORA SALIDA:",@autoviatic.hora_salida.strftime("%I:%M%p")  ] 
      exm_2 


  end

  def exm_3

      exm_3   = [[@autoviatic.obser2  ]]
      exm_3 

    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_autoviatic
      @autoviatic = Autoviatic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def autoviatic_params
      params.require(:autoviatic).permit(:location_id, :proyecto_minero_id, :employee_id, :fecha, :tema, :supplier_id, :asunto, :tramit_id, :movilidad, :almuerzo, :otros, :lugar1, :lugar2, :lugar3, :obser, :lugar_salida, :lugar_salida2, :hora_ingreso, :hora_salida, :obser2, :processed, :date_processed)
    end
end
