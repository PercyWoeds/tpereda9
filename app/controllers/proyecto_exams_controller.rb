class ProyectoExamsController < ApplicationController
  before_action :set_proyecto_exam, only: [:show, :edit, :update, :destroy]

  # GET /proyecto_exams
  # GET /proyecto_exams.json
  def index
    @proyecto_exams = ProyectoExam.all

  end

  # GET /proyecto_exams/1
  # GET /proyecto_exams/1.json
  def show
    @company = Company.find(1)
    @employees = @company.get_employees2()
    @proyecto_examen  = @company.get_proyecto_exams

    @proyecto_examen_empleado = @company.get_proyecto_exam_empleado(@proyecto_exam.id)
    

    @proyectoexam_details= @proyecto_exam.proyectoexam_details


    @rows = 2

    @pumps = ProyectoMineroExam.where(proyecto_minero_id: @proyecto_exam.proyecto_minero_id).order(:orden)
    
    @cols = @pumps.count 

    @valor  = Array.new(2) { Array.new(@cols) { "" } }
    
    for i in 0..0 do

       for pumps in @pumps do

        @valor[i].push(pumps.proyectominero2.name)

       end 

    end 
   
    for i in 1..1 do
      
      for pumps in @pumps do

        @valor[i].push(pumps.proyectominero3.name )

       end 

    end 


    @proyecto_minero_id = @proyecto_exam.proyecto_minero_id 
    @proyecto_exam_id = @proyecto_exam.id

    puts "show"
    puts  @proyecto_minero_id
    

  end

  # GET /proyecto_exams/new
  def new

    @company = Company.find(1)
    @proyecto_exam = ProyectoExam.new
    @employees = @company.get_employees2()
    @proyecto_examen = @company.get_pm()
    

  end

  # GET /proyecto_exams/1/edit
  def edit

    @company = Company.find(1)
    @employees = @company.get_employees2()
    @proyecto_examen   = @company.get_pm()
    @employees = @company.get_employees()
    
  end

  # POST /proyecto_exams
  # POST /proyecto_exams.json
  def create
    @proyecto_exam = ProyectoExam.new(proyecto_exam_params)
     @company = Company.find(1)
    @employees = @company.get_employees()
    @proyecto_examen  = @company.get_pm()

    respond_to do |format|
      if @proyecto_exam.save
        format.html { redirect_to @proyecto_exam, notice: 'Proyecto exam was successfully created.' }
        format.json { render :show, status: :created, location: @proyecto_exam }
      else
        format.html { render :new }
        format.json { render json: @proyecto_exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proyecto_exams/1
  # PATCH/PUT /proyecto_exams/1.json
  def update

    @company = Company.find(1)
    @employees = @company.get_employees()
    @proyecto_examen   = @company.get_proyecto_exams


    respond_to do |format|
      if @proyecto_exam.update(proyecto_exam_params)
        format.html { redirect_to @proyecto_exam, notice: 'Proyecto exam was successfully updated.' }
        format.json { render :show, status: :ok, location: @proyecto_exam }
      else
        format.html { render :edit }
        format.json { render json: @proyecto_exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proyecto_exams/1
  # DELETE /proyecto_exams/1.json
  def destroy


    @proyecto_exam.destroy
    respond_to do |format|
      format.html { redirect_to proyecto_exams_url, notice: 'Proyecto exam was successfully destroyed.' }
      format.json { head :no_content }
    end
  end




  
  def do_grabar 

    proyecto_minero_id = params[:proyecto_minero_id]
    proyecto_exam_id = params[:proyecto_exam_id]
    empleado_id = params[:empleado_id]

    items = params[:items]


    @pumps = ProyectoMineroExam.where(proyecto_minero_id: proyecto_minero_id)
    items_arr = []
    @products = []
    i = 0
    qty = 0 
    total_qty   = 0

    totales_qty = 0
    totales_gln = 0
    puts "empleado.+++++++++"
    puts empleado_id

      
     i = 0
     parts = items.split("|BRK|")
    


      for pumps in @pumps do

        
       a = pumps.proyectominero3_id

       @blanco  = " "

       proyecto_minero_exam_detail_id = pumps.id 

        if pumps.get_formato_fecha(a) 

          puts "graba detalle fecha "
          puts parts[i]
          puts @blanco


          proyectoexam_details =  ProyectoexamDetail.new(
                  proyecto_minero_exam_id:proyecto_minero_exam_detail_id ,
                  fecha: parts[i], 
                  observacion: @blanco,  
                  employee_id: empleado_id  , 
                  proyecto_exam_id: proyecto_exam_id,
                  proyecto_minero_id: proyecto_minero_id )
        else 


          puts "graba detalle observacion "
          puts parts[i]
          puts @blanco 

         proyectoexam_details =  ProyectoexamDetail.new(
                    proyecto_minero_exam_id: proyecto_minero_exam_detail_id,
                    fecha: nil, 
                    observacion: parts[i] , 
                    employee_id: empleado_id  ,
                    proyecto_exam_id: proyecto_exam_id,
                    proyecto_minero_id: proyecto_minero_id )

        end 

         proyectoexam_details.save
       i += 1

       end 


    
    #   respond_to do |format|

    #     puts "rutaaaaa"
    #   format.html { redirect_to  "/proyecto_exams/#{proyecto_exam_id}", notice: 'Proyecto exam was successfully destroyed.' }
     
    # end


     

     # ventaislacab = Ventaisla.find(ventaisla_id)
     #ventaislacab.update_attributes(importe: totales_qty , galones: totales_gln )
      # render :layout => false
  end

  

 def pdf


   @proyecto_exam  = ProyectoExam.find(params[:id])
    company = Company.find(1)
    @company =Company.find(company)
    @cabecera ="Facturacion"
    @abajo    ="Examen "

    @pumps = ProyectoMineroExam.where(proyecto_minero_id: @proyecto_exam.proyecto_minero_id).order(:orden)


   @proyecto_examen_empleado = @company.get_proyecto_exam_empleado(@proyecto_exam.proyecto_minero_id) 

    @cols = @pumps.count 
     
      begin 
        
        render  pdf: "rpt_proyecto_exam_01",template: "proyecto_exams/rpt_proyecto_exam_01.pdf.erb",
        locals: {:proyecto_exam => @proyecto_exam} ,
         :orientation => 'Landscape',
           :page_size => 'A3', 
           :header => {
           :spacing => 5,
                           :html => {
                           :template => 'layouts/pdf-header10.html', 
                           right: '[page] of [topage]'
                  }
               },

               :footer => { :html => { template: 'layouts/pdf-footers.html' }       }  ,   
               :margin => {bottom: 35} 
                
       end   

    
  end




 def pdf2



   @proyecto_exam  = ProyectoExam.find(params[:id])
    company = Company.find(1)
    @company =Company.find(company)
    @cabecera ="Facturacion"
    @abajo    ="Examen "

    @pumps = ProyectoMineroExam.where(proyecto_minero_id: @proyecto_exam.proyecto_minero_id).order(:orden)


   @proyecto_examen_empleado = @company.get_proyecto_exam_empleado_pdf(@proyecto_exam.proyecto_minero_id) 

    @cols = @pumps.count 


      Prawn::Document.generate "app/pdf_output/rpt_examen01.pdf" , :page_layout => :landscape , :page_size=> "A4" do |pdf|      
                pdf.font "Helvetica"
                pdf = build_pdf_header_1(pdf)
                pdf = build_pdf_body_1(pdf)
                build_pdf_footer_1(pdf)
                $lcFileName =  "app/pdf_output/rpt_examen01.pdf"      
                
            end     
            #send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
            send_file("app/pdf_output/rpt_examen01.pdf", :type => 'application/pdf', :disposition => 'inline')


    
  end





##-----------------------------------------------------------------------------------
## REPORTE 2
##-----------------------------------------------------------------------------------
  def build_pdf_header_1(pdf)

       pdf.font "Helvetica"  , :size => 8
     image_path = "#{Dir.pwd}/public/images/tpereda2.png"

      @fecha_hoy = Date.today + 30 

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
            columns([1]).width = 531.34
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



  end  

    def build_pdf_body_1(pdf)
    
    pdf.text ""
    pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size => 5

      headers = []
      headers0 = []
      table_content = []


    pdf.text "PROYECTO MINERO : " + @proyecto_exam.proyecto_minero.descrip 
    @pumps = ProyectoMineroExam.where(proyecto_minero_id: @proyecto_exam.proyecto_minero_id).order(:orden)
    
    @cols = @pumps.count + 1
   puts "col "
   puts @cols 

     @valor  = Array.new(2) { Array.new(@cols) }

        @valor[0].insert(0, " ")

        @valor[1].insert(0, "EMPLEADO ")
        i = 1
       for pumps in @pumps do
          @valor[0].insert(i, pumps.proyectominero2.name)
          i += 1
       end 

        i =  1
   
      for pumps in @pumps do

          @valor[1].insert(i, pumps.proyectominero3.name)
              i += 1  

       end 


     @valor[0].compact.each do |header|605
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end


     @valor[1].compact.each do |header|605
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers0 << cell
      end

      table_content << headers
       table_content << headers0

      nroitem = 1


      for proyectoitem in @proyecto_examen_empleado                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
        
        

               @detalle = proyectoitem.get_detalle(proyectoitem.employee_id, 
                                                    @proyecto_exam.proyecto_minero_id ) 


                   row  = []
                   row << proyectoitem.employee.full_name2  

                 for detalle in @detalle  

                
                   if detalle.proyecto_minero_exam.proyectominero2_id == 8

                       
                    

                      a =  detalle.proyecto_minero_exam.get_brevete(proyectoitem.employee_id)
                       if a  != "" 
                        puts   "fecha.-..********************************************************..." 
                        puts a 
                        row << a.strftime("%d/%m/%Y")
                       else 

                          row << "" 
                       end 
                   

                   else 
                    if detalle.proyecto_minero_exam.proyectominero3.formatofecha == "1" 

                         if detalle.fecha ==  nil 

                            row << "" 


                         else
                          
                            if detalle.proyecto_minero_exam.proyectominero3.alert == "1"  

                              if Date.today.to_date  >=  detalle.fecha.to_date

                              row << pdf.make_cell(:content =>detalle.fecha.strftime("%d/%m/%Y") ,
                                :background_color => 'FF0000', :text_color => "FFFFFF")  

                              else

                                 row << detalle.fecha.strftime("%d/%m/%Y") 

                              end

                            else 

                                row << detalle.fecha.strftime("%d/%m/%Y") 

                            end 
                           

                         end


                     else 

                          
                           row <<  detalle.observacion 
              
                     end 
                   end 

                  
             end      

                  


                table_content << row 
    
    end




       

              result = pdf.table table_content, {:position => :center,
                                                :header => true,
                                                :width => pdf.bounds.width
                                                } do 
                                                  columns([0]).align=:center
                                                  columns([1]).align=:center 
                                                  columns([2]).align=:left
                                                  columns([3]).align=:left
                                                  columns([4]).align=:left  
                                                  columns([5]).align=:left 
                                                  columns([6]).align=:left
                                                  columns([7]).align=:left 
                                                  columns([8]).align=:left
                                                  columns([9]).align=:left
                                                  columns([10]).align=:left
                                                  columns([11]).align=:left
                                                  columns([12]).align=:left  
                                                
                                                  



                                                end                                          
              pdf.move_down 10      
              pdf

    end


    def build_pdf_footer_1(pdf)

      table_content3 =[]
            row = []
            row << "--------------------------------------------"
            row << "--------------------------------------------"
            row << "--------------------------------------------"
            
            table_content3 << row 
            row = []
            row << "V.B.VENTAS "
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

#############################################################################################

##### PEX 

#############################################################################################




  def import
      ProyectoExam.import(params[:file])
       redirect_to root_url, notice: "Informacion importadas."
  end 
  



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proyecto_exam
      @proyecto_exam = ProyectoExam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proyecto_exam_params
      params.require(:proyecto_exam).permit(:employee_id, :proyecto_minero_id,:proyecto_minero_exam_id ,:observacion)
    end
end
