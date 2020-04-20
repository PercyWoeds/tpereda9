include UsersHelper
include ServicesHelper


class RequerimientosController < ApplicationController
   $: << Dir.pwd  + '/lib'
    require "open-uri"

  before_action :set_requerimiento, only: [:show, :edit, :update, :destroy ]

  # GET /requerimientos
  # GET /requerimientos.json
  def index
    @requerimientos = Requerimiento.all
  end

  # GET /requerimientos/1
  # GET /requerimientos/1.json
  def show
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @divisions = @company.get_divisions()
  end

  # GET /requerimientos/new
  def new
    @requerimiento = Requerimiento.new
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @divisions = @company.get_divisions()

    @requerimiento[:fecha] = DateTime.now
    @requerimiento[:hora] = Time.zone.now.strftime("%H:%M")
    @unidads = @company.get_unidads()

    10.times {@requerimiento.rqdetails.build }

  end

  # GET /requerimientos/1/edit
  def edit
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @divisions = @company.get_divisions()
    @unidads = @company.get_unidads()
  end

  # POST /requerimientos
  # POST /requerimientos.json
  def create
    @requerimiento = Requerimiento.new(requerimiento_params)
    
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @divisions = @company.get_divisions()
    @requerimiento[:user_id] = getUserId()

    respond_to do |format|

      @requerimiento[:code] = @requerimiento.generate_rq_number("001")
      
      if @requerimiento.save
        format.html { redirect_to @requerimiento, notice: 'Requerimiento was successfully created.' }
        format.json { render :show, status: :created, location: @requerimiento }
      else
        format.html { render :new }
        format.json { render json: @requerimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requerimientos/1
  # PATCH/PUT /requerimientos/1.json
  def update
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @divisions = @company.get_divisions()
    @unidads = @company.get_unidads()

    respond_to do |format|
      if @requerimiento.update(requerimiento_params)
        format.html { redirect_to @requerimiento, notice: 'Requerimiento was successfully updated.' }
        format.json { render :show, status: :ok, location: @requerimiento }
      else
        format.html { render :edit }
        format.json { render json: @requerimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requerimientos/1
  # DELETE /requerimientos/1.json
  def destroy

    @requerimiento.destroy

    respond_to do |format|
      format.html { redirect_to requerimientos_url, notice: 'Requerimiento was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



def pdf
    @requerimiento  = Requerimiento.find(params[:id])
    
    @company =Company.find(1) 
    

    Prawn::Document.generate("app/pdf_output/#{@requerimiento.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@requerimiento.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end
  
  
def build_pdf_header(pdf)

  pdf.font "Helvetica" , :size => 8
  image_path = "#{Dir.pwd}/public/images/tpereda2.png"


  
   table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD OCUPACIONAL",:rowspan => 2},"CODIGO ","TP-CM-F-010 "], 
      ["VERSION: ","04"], 
      ["SOLICITUD DE REQUERIMIENTOS " ,"Pagina: ","1 "] 
     
      ])
  



   pdf.table(table_content  ,{
       :position => :center,
       :width => pdf.bounds.width
     })do
       columns([1,2]).font_style = :bold
        columns([0]).width = 100
        columns([1]).width = 340
        columns([1]).align = :center
        
        columns([2]).width = 50
      
        columns([3]).width = 50
  
     end
     pdf.move_down 2 
     table_content2 = ([["Fecha : ",Date.today.strftime("%d/%m/%Y")]])

     pdf.table(table_content2,{:position=>:right }) do

        columns([0, 1]).font_style = :bold
        columns([0, 1]).width = 50
        
     end 


     
     pdf.move_down 2
  
  pdf 
   
  end   

  def build_pdf_body(pdf)
    
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 6

     
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
      
     
    headers = []
    table_content = []

    Requerimiento::TABLE_HEADERS.each do |header|
      cell = pdf.make_cell(:content => header)
      cell.background_color = "FFFFCC"
      headers << cell
    end

    table_content << headers

    
      nroitem = 1 
    for rq  in @requerimiento.rqdetails  
        row = []
        row << nroitem.to_s
        row << rq.codigo
        row << rq.qty 
        row << rq.unidad.descrip
        row << rq.descrip 
        row << rq.placa_destino
        nroitem += 1
        table_content << row
    end 

    result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:center
                                          columns([3]).align=:center
                                          columns([4]).align=:left
                                          columns([5]).align=:left
                                          
                                        end

      # detalle 2
     pdf.move_down  10                          
     
      pdf

    end


    def build_pdf_footer(pdf)

     
        pdf.bounding_box([0, 120], :width => 535, :height => 120) do
        pdf.text "Nota: ", :size => 6, :style => :bold
        pdf.text "En descripcion detallar las especificaciones como color,marca, modelo,medidas, tipo,peso,etc. De esta manera se realizara la solicitud de manera efectiva. ", :size => 6
        pdf.text " "
        pdf.text "Observaciones:  ", :size => 6, :style => :bold 
        pdf.text @requerimiento.observa , :size => 6
        pdf.text " "
        pdf.text " "
        pdf.text " "
        pdf.text "_________________                                                     ____________________      ", :size => 13, :spacing => 4
        pdf.text ""
        pdf.text "                         Almacen                                                                                                     Firma de Conformidad           ", :size => 10, :spacing => 4
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf
      
  end
  
  
 def client_data_headers
  
      client_headers  = [["Nombre: ", @requerimiento.employee.full_name ]] 
      client_headers << ["Area : ", @requerimiento.division.name ]   
      
      
      client_headers
  end

  def invoice_headers   
    
      invoice_headers  = [["Fecha : ",@requerimiento.fecha.strftime("%Y-%m-%d")  ]]
      invoice_headers <<  ["Hora : ",@requerimiento.hora ]    
      

      invoice_headers
  end
  

  # Do send invoice via email
 
  # Send invoice via email
  def sendmail
    @requerimiento  = Requerimiento.find(params[:id])
    ActionCorreo.rq_email(@requerimiento).deliver_now 

  end

  
  def do_process
    @requerimiento  = Requerimiento.find(params[:id])
    @requerimiento[:processed] = "1"

    @requerimiento.process
    
    flash[:notice] = "El documento ha sido procesado."
    redirect_to @requerimiento 
  end

  def do_anular
    @requerimiento = Requerimiento.find(params[:id])

 
   a = Rqdetail.where(:requerimiento_id=> @requerimiento.id, :atento=> !nil  )
    if a.size > 0 
    flash[:notice] = "Requerimiento  tiene RQ atendidas, no se puede anular."
    
    else

    @requerimiento[:processed] = "2"
    @requerimiento.anular 
    
    flash[:notice] = "Documento a sido anulado."
    end 
    redirect_to @requerimiento



  end
  

  def sendcancelar 
    
    @company  = Company.find(1)
    @requerimiento = Requerimiento.find(params[:id])

  end


  def do_cancelar


    @company =  Company.find(1)
    @requerimiento = Requerimiento.find(params[:id])
    @observa  = params[:motivo]
  
    @requerimiento[:processed] = "3"

     @requerimiento.update_attributes(:motivo => @observa,:processed =>"3") 
     @requerimiento.cancelar
    
    
    flash[:notice] = "Motivo grabado."
    redirect_to "/requerimientos/#{@requerimiento.id}"

  end


  private


    # Use callbacks to share common setup or constraints between actions.
    def set_requerimiento
      @requerimiento = Requerimiento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def requerimiento_params
      params.require(:requerimiento).permit(:code, :employee_id, :division_id, :fecha, :hora, :nota, :observa,:date_processed,:user_id ,
          :rqdetails_attributes => [:id, :requerimiento_id, :codigo,:qty, :unidad_id,:descrip,:placa_destino, :_destroy ]
        )

    end
end
