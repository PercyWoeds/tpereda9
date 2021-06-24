class MntosController < ApplicationController
  before_action :set_mnto, only: [:show, :edit, :update, :destroy]

  # GET /mntos
  # GET /mntos.json
  def index
    @mntos = Mnto.all
  end

  # GET /mntos/1
  # GET /mntos/1.json
  def show

 @company =  Company.find(1)
      @trucks = @company.get_trucks
    @divisions  = @company.get_divisions()

    @mnto_detail =  @mnto.mnto_details.order("mnto_details.activity_id")
      
  end

  # GET /mntos/new

  def new
    @company =  Company.find(1)
    @mnto = Mnto.new

    @mnto[:fecha]  = Date.today 

    @mnto[:fecha2]  = Date.today 
    @trucks = @company.get_trucks
    @divisions  = @company.get_divisions()
     @mnto[:division_id]  = 7

     

  end

  # GET /mntos/1/edit
  def edit
    @company =  Company.find(1)
    @trucks = @company.get_trucks
    @divisions  = @company.get_divisions()

  end

  # POST /mntos
  # POST /mntos.json
  def create
    @mnto = Mnto.new(mnto_params)
    @company =  Company.find(1)
    @trucks = @company.get_trucks
    @divisions  = @company.get_divisions()

   if  params[:tipo] == "1"
      @lcSerie =  1
   end 
   if  params[:tipo] == "2"
      @lcSerie =  2
   end 
   if  params[:tipo] == "3"
      @lcSerie =  3
   end 
   

   @mnto[:code] = @mnto.generate_mnto_number(@lcSerie)  
  
   @mnto[:user_id]   = @current_user.id 
   @mnto[:tipo] = params[:tipo] 


    respond_to do |format|
      if @mnto.save

             @detalle =  @mnto.get_activity( @mnto[:tipo])  
         for actividad in @detalle 

               mnto_detail =  MntoDetail.new( activity_id: actividad.id, process: "0", mnto_id: @mnto.id) 
               begin 
                 mnto_detail.save
               rescue
               end 



         end 

        format.html { redirect_to @mnto, notice: 'Mnto was successfully created.' }
        format.json { render :show, status: :created, location: @mnto }
      else
        format.html { render :new }
        format.json { render json: @mnto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mntos/1
  # PATCH/PUT /mntos/1.json
  def update
    @company =  Company.find(1)
    @trucks = @company.get_trucks
    @divisions  = @company.get_divisions()

    respond_to do |format|
      if @mnto.update(mnto_params)
        format.html { redirect_to @mnto, notice: 'Mnto was successfully updated.' }
        format.json { render :show, status: :ok, location: @mnto }
      else
        format.html { render :edit }
        format.json { render json: @mnto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mntos/1
  # DELETE /mntos/1.json
  def destroy
    @mnto.destroy
    respond_to do |format|
      format.html { redirect_to mntos_url, notice: 'Mnto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end




  def do_anular
    @invoice = Mnto.find(params[:id])


    @invoice[:processed] = "2"
    @invoice.anular 
    
    flash[:notice] = "Documento a sido anulado."
   

    redirect_to @invoice 



  end


  def sendcancelar 
    
    @company  = Company.find(1)
    @mnto = Mnto.find(params[:id])

  end


  def do_cancelar


    @company =  Company.find(1)
    @mnto = Mnto.find(params[:id])
    @observa  = params[:motivo]
  
    @mnto[:processed] = "3"

     @mnto.update_attributes(:motivo => @observa,:processed =>"3") 
     @mnto.cancelar
    
    
    flash[:notice] = "Motivo grabado."
    redirect_to "/mntos/#{@mnto.id}"

  end

  # Send invoice via email
  def cancela
    @mnto = Mnto.find(params[:id])
    @company = @mnto.company
  end

   def do_process
    @mnto  = Mnto.find(params[:id])
    @mnto[:processed] = "1"


    @mnto.process
    
    flash[:notice] = "El documento ha sido procesado."
    redirect_to @mnto 
  end

  def self.search(search)
      where("code LIKE ?", "%#{search}%") 
        
  end


  def pdf
    @mnto  = Mnto.find(params[:id])
    @company = Company.find(1)
  
@mnto_detail =  @mnto.mnto_details.order("mnto_details.activity_id")

    Prawn::Document.generate("app/pdf_output/#{@mnto.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@mnto.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end
  
def build_pdf_header(pdf)

      pdf.font "Helvetica"  , :size => 8

     image_path = "#{Dir.pwd}/public/images/tpereda2.png"

       @fecha_hoy = Date.today  
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
            columns([1]).width = 301.45 
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
      pdf.move_down 2


      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 7

    @texto_ost = " "
    table_content = []
    row  = []
    row << "Fecha Inicio: "
    row << "Placa : "
    row << "Tipo : "
    row << "Modelo: "
    row << "Km. Programado : "
    row << "Km. Actual : " 
    row << "Fecha Termino : "

    table_content << row 

    row  = []
    row <<  @mnto.fecha.strftime("%Y-%m-%d")
    row << @mnto.truck.placa
    row << @mnto.truck.tipo_unidad.name 
    row << @mnto.truck.modelo.descrip
    row << @mnto.km_actual.to_s 
    row << @mnto.km_programado.to_s
    row << @mnto.fecha2.strftime("%Y-%m-%d")
    table_content << row 


     result = pdf.table table_content, {:position => :center,
                                                :width => pdf.bounds.width
                                                } do 
                                                  columns([0]).align=:center
                                                  columns([1]).align=:center 
                                                  columns([2]).align=:left
                                                  columns([3]).align=:left
                                                  columns([4]).align=:left  
                                                  columns([5]).align=:left 
                                                  columns([6]).align=:left

                                                end                                          
      pdf.move_down 10      
      pdf
       table_content = []
       nroitem = 1

    @mnto_detail.each do |product| 
    
     
            row  = []
            row << nroitem.to_s 
            row <<   product.activity.name 
            row <<   " " 
            row <<   product.get_estado  
            table_content << row 

            nroitem += 1

         # pdf.text @manifest.observa
      
    end

result = pdf.table table_content, {:position => :center,
                                                :width => pdf.bounds.width
                                                } do 
                                                  columns([0]).align=:left
                                                  columns([1]).align=:left 
                                                  columns([2]).align=:left

                                                
                                                  columns([1]).width = 400
                                                  columns([2]).width = 59.169
                                                  columns([3]).width = 65
                                                end                                          
      pdf.move_down 10      
      pdf


  end 



    def build_pdf_footer(pdf)

        
        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        
        pdf.text "_________________               _____________________         ____________________      ", :size => 13, :spacing => 4
        pdf.text ""
        pdf.text "                  Mecanico                                                                                                                    Supervisor de mantenimiento           ", :size => 10, :spacing => 4
     
      end
      pdf
      
  end
  
  
 def client_data_headers
  
      client_headers  = [["Area  ", @mnto.division_id  ]] 
      client_headers << ["Fecha Inicio : ", @manifest.customer.name ]    
      client_headers << ["Fecha Termino: ", @manifest.solicitante+ @texto_ost]
      
      
      client_headers
  end

  def invoice_headers   
    
      invoice_headers  = [["Placa : ","Supervisor de MANTENIMIENTO "  ]]
      invoice_headers <<  ["Estado  : ",@manifest.get_processed ]    
      

      invoice_headers
  end
  
  def invoice_summary
      invoice_summary = []
      invoice_summary << ["Importe",  "0.00"]
      invoice_summary
  end
  



  def manifest_3   
      manifest_3   = [[ "Fecha Inicio: ","Placa : ","Tipo : ","Modelo: ","Km. Programado : ","Km. Actual : " ,"Fecha Termino : "  ]]

      manifest_3 <<  [ @mnto.fecha.strftime("%Y-%m-%d"), @mnto.truck.placa, @mnto.truck.config,@mnto.truck.modelo ,  @mnto.km_actual,@mnto.km_programado,@mnto.fecha2.strftime("%Y-%m-%d") ]

     

      manifest_3
  end
    

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mnto
      @mnto = Mnto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mnto_params
      params.require(:mnto).permit(:code, :division_id, :ocupacion_id, :fecha, :truck_id, :km_programado,
       :km_actual, :fecha2, :user_id, :processed, :date_processed,:tipo)
    end
end
