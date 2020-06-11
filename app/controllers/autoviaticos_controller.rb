class AutoviaticosController < ApplicationController
  before_action :set_autoviatico, only: [:show, :edit, :update, :destroy]


  # GET /autoviaticos
  # GET /autoviaticos.json
  def index
    @autoviaticos = Autoviatico.all
  end

  # GET /autoviaticos/1
  # GET /autoviaticos/1.json
  def show
  end

  # GET /autoviaticos/new
  def new

    

    @autoviatico = Autoviatico.new
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @suppliers = @company.get_suppliers()

     now = Time.now.in_time_zone.change( hour: 8)
    

    @autoviatico['fecha'] = Date.today
    @autoviatico['fecha2'] = Date.today
    @autoviatico['hora_ingreso'] = "08:00"
    @autoviatico['hora_salida'] = "18:00"
    @autoviatico['hora1'] = "08:00"
    @autoviatico['hora2'] = "18:00"

  end

  # GET /autoviaticos/1/edit
  def edit
    @company = Company.find(1)
    @empleados = @company.get_employees()
    @suppliers = @company.get_suppliers()
  end

  # POST /autoviaticos
  # POST /autoviaticos.json
  def create
    @autoviatico = Autoviatico.new(autoviatico_params)

     @autoviatico[:code] = @autoviatico.generate_number("001")  
  puts "asunto"
  puts @autoviatico[:asunto1]
  puts @autoviatico[:asunto2]

    @company = Company.find(1)
    @empleados = @company.get_employees()
    @suppliers = @company.get_suppliers()
    respond_to do |format|
      if @autoviatico.save
        format.html { redirect_to @autoviatico, notice: 'Autoviatico was successfully created.' }
        format.json { render :show, status: :created, location: @autoviatico }
      else
        format.html { render :new }
        format.json { render json: @autoviatico.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /autoviaticos/1
  # PATCH/PUT /autoviaticos/1.json
  def update


     puts "asunto"
  puts @autoviatico[:asunto1]
  puts @autoviatico[:asunto2]


    respond_to do |format|
      if @autoviatico.update(autoviatico_params)
        format.html { redirect_to @autoviatico, notice: 'Autoviatico was successfully updated.' }
        format.json { render :show, status: :ok, location: @autoviatico }
      else
        format.html { render :edit }
        format.json { render json: @autoviatico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /autoviaticos/1
  # DELETE /autoviaticos/1.json
  def destroy
    @autoviatico.destroy
    respond_to do |format|
      format.html { redirect_to autoviaticos_url, notice: 'Autoviatico was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

   def do_anular
      @autoviatico  = Autoviatico.find(params[:id])
      @autoviatico[:processed] = "2"
      
      @autoviatico.anular 
      
      flash[:notice] = "Documento a sido anulado."
      redirect_to @autoviatico
  end


 def do_process
    @automatico  = Autoviatico.find(params[:id])
    @automatico[:processed] = "1"


    @automatico.process
    
    flash[:notice] = "El documento ha sido procesado."
    redirect_to @automatico
  end


def pdf
    @company = Company.find(1)
    @autoviatico = Autoviatico.find(params[:id])
    

    Prawn::Document.generate("app/pdf_output/#{@autoviatico.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@autoviatico.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end
  

  def build_pdf_header(pdf)
      pdf.font "Helvetica" , :size => 8
      image_path = "#{Dir.pwd}/public/images/tpereda2.png"

       table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION DE LA CALIDAD, SEGURIDAD VIAL,SEGURIDAD Y SALUD OCUPACIONAL",:rowspan => 2},"CODIGO ","TP-EC-F-014 "], 
          ["VERSION: ","3"], 
          ["AUTORIZACION DE VIATICOS PARA EXAMENES MEDICOS  Y CAPACITACIONES ","Pagina: ","1 de 1 "] 
         
          ])
      

       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 261.45
            columns([1]).align = :center
            
            columns([2]).width = 60
          
            columns([3]).width = 100
      
         end
        
         table_content2 = ([["Fecha : ",Date.today.strftime("%d/%m/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
             columns([0]).width = 60
            columns([ 1]).width = 100
            
         end 

    
         
         pdf.move_down 2
      
      pdf 
  end   


  def build_pdf_body(pdf)
    
    pdf.text " ", :size => 13, :spacing => 4
  
   
    
    pdf.font "Helvetica" , :size => 8

      headers = []
      table_content = []

      Purchase::TABLE_HEADERS31.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

    pdf.table([["LOCAL :" ]], :column_widths => [540])
      pdf.text " "
    
      pdf.table([ ["Nombres y Apellidos: ", @autoviatico.employee.full_name2],
            ["Fecha: ",@autoviatico.fecha.strftime("%d/%m/%Y")],
            ["Tema:", @autoviatico.tema ] ,
            ["Clinica/C.Capacitacion :", @autoviatico.supplier.name  ] 
          ], :column_widths => [120, 420])

      if @autoviatico.asunto1 == "1"
          @asunto1 = "X"
      end
      if @autoviatico.asunto2 == "1"
          @asunto2 = "X"
      end 

      pdf.table([["Asunto:","Examen Medico:",@asunto1,"Capacitacion:",@asunto2 ]], :column_widths => [100,100,100,100,140])

      pdf.table([["MOVILIDAD:",@autoviatico.movilidad ,"Lugar:",@autoviatico.lugar1 ]], :column_widths => [100,100,100,240])
      pdf.table([["ALMUERZO:",@autoviatico.almuerzo ,"Lugar:",@autoviatico.lugar2 ]], :column_widths => [100,100,100,240])
      pdf.table([["OTROS:",@autoviatico.otros ,"Lugar:",@autoviatico.lugar3 ]], :column_widths => [100,100,100,240])

      pdf.table([["OBSERVACIONES:",@autoviatico.observa ]], :column_widths => [100,440])
       pdf.table([["HORA INGRESO:",@autoviatico.hora_ingreso ,"HORA SALIDA:",@autoviatico.hora_salida]], :column_widths => [100,100,100,240])
       pdf.text " "
       pdf.table([["SUCURSAL :" ]], :column_widths => [540])
       pdf.text " "

       pdf.table([ ["Nombres y Apellidos: ", @autoviatico.get_empleado(@autoviatico.employee_id2)]], :column_widths => [100,440])
       pdf.table([ ["Lugar Salida : ",@autoviatico.lugar_salida,"Fecha:",@autoviatico.fecha2.strftime("%d/%m/%Y")],
            ["Lugar Destino", @autoviatico.lugar_destino, "",""]], :column_widths => [100,100, 100,240])

  pdf.table([["HORA INGRESO:",@autoviatico.hora1 ,"HORA SALIDA:",@autoviatico.hora2 ]], :column_widths => [100,100,100,240])
      pdf.table([["OBSERVACIONES:",@autoviatico.observa2]], :column_widths => [100,440])
     
      pdf 

   
    end


    def build_pdf_footer(pdf)

        
        pdf.bounding_box([0, 80], :width => 540, :height => 90) do

      pdf.table([[" ","____________________" ,"","_____________________","" ]], :column_widths => [100,140,100,140,60],  :cell_style => {:border_width => 0})   
       pdf.table([[" ","Elaborado por." ,"","","" ]], :column_widths => [100,140,100,140,60],  :cell_style => {:border_width => 0})
       pdf.table([["","COORD.EXAM MEDICOS Y CAP." ,"","JEFE DE OPERACIONES",""]], :column_widths => [100,140,100,140,60],  :cell_style => {:border_width => 0})
      pdf.table([[" ","Irma Lobo." ,"","Juan Gabriel Erquinigo","" ]], :column_widths => [100,140,100,140,60],  :cell_style => {:border_width => 0})
   
      end
      pdf
      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_autoviatico
      @autoviatico = Autoviatico.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def autoviatico_params
      params.require(:autoviatico).permit(:code, :employee_id, :fecha, :tema, :supplier_id, :asunto, :movilidad, :almuerzo, :otros, :observa, :hora_ingreso, :hora_salida, :employee_id2, :lugar_salida, :lugar_destino, :hora1, :hora2, :observa2, :asunto1,
   :fecha2, :asunto2,:lugar1,:lugar2,:lugar3,:total)
    end
end
