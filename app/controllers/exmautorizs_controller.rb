class ExmautorizsController < ApplicationController
  before_action :set_exmautoriz, only: [:show, :edit, :update, :destroy]

  # GET /exmautorizs
  # GET /exmautorizs.json
  def index
    @exmautorizs = Exmautoriz.all
  end

  # GET /exmautorizs/1
  # GET /exmautorizs/1.json
  def show
     @company = Company.find(1)
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

  # GET /exmautorizs/new
  def new
    @company = Company.find(1)
    @exmautoriz = Exmautoriz.new

    @exmautoriz[:fecha] = Date.today 

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

  # GET /exmautorizs/1/edit
  def edit
    @company = Company.find(1)
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

  # POST /exmautorizs
  # POST /exmautorizs.json
  def create
    @exmautoriz = Exmautoriz.new(exmautoriz_params)
    @lcSerie = "1"
    @exmautoriz[:code] = @exmautoriz.generate_number(@lcSerie)  
    @exmautoriz[:processed]  = "0"


    respond_to do |format|
      if @exmautoriz.save
        format.html { redirect_to @exmautoriz, notice: 'Exmautoriz was successfully created.' }
        format.json { render :show, status: :created, location: @exmautoriz }
      else
        format.html { render :new }
        format.json { render json: @exmautoriz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exmautorizs/1
  # PATCH/PUT /exmautorizs/1.json
  def update
    respond_to do |format|
      if @exmautoriz.update(exmautoriz_params)
        format.html { redirect_to @exmautoriz, notice: 'Exmautoriz was successfully updated.' }
        format.json { render :show, status: :ok, location: @exmautoriz }
      else
        format.html { render :edit }
        format.json { render json: @exmautoriz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exmautorizs/1
  # DELETE /exmautorizs/1.json
  def destroy
    @exmautoriz.destroy
    respond_to do |format|
      format.html { redirect_to exmautorizs_url, notice: 'Exmautoriz was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sendcancelar 
    
    @company  = Company.find(1)
    @exmautoriz = Exmautoriz.find(params[:id])

  end



  
  def do_process
    @exmautoriz  = Exmautoriz.find(params[:id])
    @exmautoriz[:processed] = "1"


    @exmautoriz.process
    
    flash[:notice] = "El documento ha sido procesado."
    redirect_to @exmautoriz 
  end


  def get_processed
    if(self.processed == "1")
      return "Aprobado "
    elsif (self.processed == "2")      
      return "**Anulado **"
    elsif (self.processed == "3")      
      return "* Cerrado **"
    elsif (self.processed == "4")        
      return "* Facturado **"
    else 
      return "No Aprobado"
    end
  
  end




  def do_cancelar


    @company =  Company.find(1)
    @exmautoriz = Exmautoriz.find(params[:id])
    @observa  = params[:motivo]
  
    @exmautoriz[:processed] = "3"

     @exmautoriz.update_attributes(:motivo => @observa,:processed =>"3") 
     @exmautoriz.cancelar
    
    
    flash[:notice] = "Motivo grabado."
    redirect_to "/exmautorizs/#{@exmautoriz.id}"

  end


  def pdf
    @exmautoriz = Exmautoriz.find(params[:id])
  
    @company =Company.find(1) 
    


    Prawn::Document.generate("app/pdf_output/#{@exmautoriz.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        @lcFileName =  "app/pdf_output/#{@exmautoriz.id}.pdf"      
        
    end     

    @lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+@lcFileName      
              send_file("#{@lcFileName1}", :type => 'application/pdf',
    :disposition => 'inline')
  
  end
  
  
def build_pdf_header(pdf)

      pdf.font "Helvetica"  , :size => 8

     image_path = "#{Dir.pwd}/public/images/tpereda2.png"
      
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center}, {:content =>"SISTEMA DE GESTIÓN INTEGRADO",:rowspan => 2},"CODIGO ","TP-EC-F-001"], 
          ["VERSION: ","2"], 
          ["AUTORIZACIÓN DE GESTIÓN NUEVA O RENOVACIÓN ","Pagina: ","1 de 1 "] 
         
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


         table_content_t1 = ([["1.EXAMEN MEDICO "]])

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

          table_content_t2 = ([["2.REVISION TECNICA "]])

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


        table_content_t3 = ([["3.ANTECEDENTES "]])

         pdf.table(table_content_t3,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 540
            
         end 



       max_rows = [exm_4.length,exm_4.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (exm_4.length >= row ? exm_4[rows_index] : ['',''])
        
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



    table_content_t4 = ([["4.CAPACITACION "]])

         pdf.table(table_content_t4,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 540
            
         end 
       max_rows = [exm_5.length,exm_5.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (exm_5.length >= row ? exm_5[rows_index] : ['',''])
        
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





    table_content_t5 = ([["5.OTROS "]])

         pdf.table(table_content_t5,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 540
            
         end 

       max_rows = [exm_6.length,exm_6.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (exm_6.length >= row ? exm_6[rows_index] : ['',''])
        
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



  def exm_2
     
      if @exmautoriz.fecha_ingreso != nil 
       @fecha_ingreso = @exmautoriz.fecha_ingreso.strftime("%d/%m/%Y")
      else 
        @fecha_ingreso = "//"
      end 

      if @exmautoriz.fecha_vmto != nil 
       @fecha_vmto = @exmautoriz.fecha_vmto.strftime("%d/%m/%Y")
      else 
        @fecha_vmto  = "//"
      end 

      exm_2   = [[ "COLABORADOR:: ",@exmautoriz.employee.full_name  ,"PROYECTO : ",@exmautoriz.proyecto_minero.descrip ]]

      exm_2 <<  ["CLÍNICA: ",@exmautoriz.supplier.name  , " ","" ]

      exm_2 <<  ["FECHA DE INGRESO: ",@fecha_ingreso ,"FECHA DE VENCIMIENTO: ",@fecha_vmto   ]    
       
     
      exm_2 


  end


  def exm_3

      if @exmautoriz.truck_id != nil

          @placa = @exmautoriz.truck.placa
          @tipo_unidad = @exmautoriz.tipo_unidad.name 
          @certificado = @exmautoriz.truck.certificado 

      else
        @placa = ""
        @certificado = ""
        @tipo_unidad = ""

      end 

      if @exmautoriz.tecnic_revision_id != nil

        @revision_tecnica =  @exmautoriz.tecnic_revision.name

      else
        @revision_tecnica = ""
      end 

      if @exmautoriz.fecha_vmto_rt != nil
        @fecha_vmto_rt  = @exmautoriz.fecha_vmto_rt.strftime("%d/%m/%Y")
      else
        @fecha_vmto_rt  = ""
      end 
   

     if @exmautoriz.fecha_carga_rt != nil
      @fecha_carga_rt = @exmautoriz.fecha_carga_rt.strftime("%d/%m/%Y")
     else 
      @fecha_carga_rt = ""
     end

      exm_3   = [[ "PLACA: ",@placa ,"TIPO DE UNIDAD: ",@tipo_unidad   ]]

      exm_3 <<  ["CERT. OPERATIVIDAD: ",@certificado , " CONDUCTOR:", @exmautoriz.get_empleado(@exmautoriz.employee2_id)]

      exm_3 <<  ["TIPO DE REVISION TECNICA:: ",@revision_tecnica,"",""]

      exm_3 <<  [ "FECHA DE VENCIMIENTO: ",@fecha_vmto_rt,"FECHA DE CARGA:" , @fecha_carga_rt ]    
       
      exm_3 <<  ["OBSERVACION:",@exmautoriz.obs_rt,"",""]
      exm_3
  end

  
  def exm_4
      if @exmautoriz.antecedent_id != nil
        @tipo_antecedent = @exmautoriz.antecedent.name 
      else
        @tipo_antecedent = ""
      end 
     if @exmautoriz.fecha_vmto_ant != nil
      @fecha_vmto_ant = @exmautoriz.fecha_vmto_ant.strftime("%d/%m/%Y")
     else 
      @fecha_vmto_ant = ""
     end


      exm_4   = [[ "COLABORADOR:: ",@exmautoriz.get_empleado(@exmautoriz.employee3_id) ,"TIPO ANTECEDENTE: ",@tipo_antecedent]]

      exm_4 <<  ["FECHA VENCIMIENTO",@fecha_vmto_ant , "OBSERVACION ",@exmautoriz.obs_ant  ]

    
      exm_4
  end



  def exm_5


     if @exmautoriz.fecha_vmto_cap != nil
      @fecha_vmto_cap = @exmautoriz.fecha_vmto_cap.strftime("%d/%m/%Y")
     else 
      @fecha_vmto_cap = ""
     end

    if @exmautoriz.proyecto_minero2_id != nil 
     @proyecto_5 = @exmautoriz.get_proyecto_minero(@exmautoriz.proyecto_minero2_id)

    else

     @proyecto_5 = ""
    end 



      exm_5  = [[ "COLABORADOR:: ",@exmautoriz.get_empleado(@exmautoriz.employee4_id) ,"CURSO/CAPACITACION ", @exmautoriz.curso_cap]]

      exm_5 <<  ["PROYECTO:", @proyecto_5 , "FECHA VENCIMIENTO ",@fecha_vmto_cap  ]

      exm_5 << ["OBSERVACION: ",@exmautoriz.obs_cap,"",""]
  end

   def exm_6



     if @exmautoriz.fecha_vmto_ot != nil
      @fecha_vmto_ot = @exmautoriz.fecha_vmto_ot.strftime("%d/%m/%Y")
     else 
      @fecha_vmto_ot = ""
     end



      exm_6  = [[ "CONDUCTOR:: ", @exmautoriz.get_empleado(@exmautoriz.employee5_id)  ,"TRAMITE:",  @exmautoriz.tramite ]]

      exm_6 <<  ["FECHA VENCIMIENTO ", @fecha_vmto_ot ,"OBSERVACION",@exmautoriz.obs_ot  ]
    
      exm_6
  end

  
  



 def client_data_headers
  
      client_headers  = [["TRAMITE : ", @exmautoriz.tramit.name ]] 
      client_headers << ["TIPO TRAMITE  : ", @exmautoriz.tipo_tramit.name ]    
   
      
      
      client_headers
  end

def invoice_headers   
    
      invoice_headers  = [["Fecha de emisión : ",@exmautoriz.fecha.strftime("%Y-%m-%d")  ]]
      invoice_headers <<  ["Estado  : ",@exmautoriz.get_processed ]    
      

      invoice_headers
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exmautoriz
      @exmautoriz = Exmautoriz.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exmautoriz_params
      params.require(:exmautoriz).permit(:tramit_id, :tipo_tramit_id, :employee_id, :proyecto_minero_id,
       :supplier_id, :fecha_ingreso, :fecha_vmto, :truck_id, :employee2_id, :tipo_revision_tecnica, 
       :fecha_vmto_rt, :fecha_carga_rt, :obs_rt, :employee3_id, :antecedent_id, :tipo_antecedent_id,
        :fecha_vmto_ant, :obs_ant, :employee4_id, :curso_cap, :proyecto_minero2_id, :fecha_vmto_cap,
         :obs_cap, :employee5_id, :tramite, :fecha_vmto_ot, :obs_ot,:code,:date_processed,:fecha )
    end
end
