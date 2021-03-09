include UsersHelper
include ServicesHelper

class ContactopmsController < ApplicationController
  before_action :set_contactopm, only: [:show, :edit, :update, :destroy ]

  # GET /contactopms
  # GET /contactopms.json
  def index
    @contactopms = Contactopm.all
  end

  # GET /contactopms/1
  # GET /contactopms/1.json
  def show

  end

  # GET /contactopms/new
  def new
    @company = Company.find(1)
    @proyecto_minero = @company.get_proyecto_minero()
    @contactopm = Contactopm.new
   

    10.times {@contactopm.contactopmdetails.build }
    

  end

  # GET /contactopms/1/edit
  def edit
     @company = Company.find(1) 
     @proyecto_minero = @company.get_proyecto_minero()
      10.times {@contactopm.contactopmdetails.build }

  end

  # POST /contactopms
  # POST /contactopms.json
  def create
 @company = Company.find(1)
     @proyecto_minero = @company.get_proyecto_minero()
    @contactopm = Contactopm.new(contactopm_params)

    
    respond_to do |format|

      if @contactopm.save

        format.html { redirect_to @contactopm, notice: 'Contacto was successfully created.' }
        format.json { render :show, status: :created, location: @contactopm }
      else
        format.html { render :new }
        format.json { render json: @contactopm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contactopms/1
  # PATCH/PUT /contactopms/1.json
  def update

  @company = Company.find(1)
  @proyecto_minero = @company.get_proyecto_minero()

    respond_to do |format|
      if @contactopm.update(contactopm_params)
        format.html { redirect_to @contactopm, notice: 'Contacto was successfully updated.' }
        format.json { render :show, status: :ok, location: @contactopm }
      else
        format.html { render :edit }
        format.json { render json: @contactopm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contactopms/1
  # DELETE /contactopms/1.json
  def destroy
    @contactopm.destroy
    respond_to do |format|
      format.html { redirect_to contactopms_url, notice: 'Contacto  was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


 
   def pdf

    @company = Company.find(1)
    
    @rpt_contactopms = Contactopm.select("contactopms.*, 
      contactopmdetails.contacto,contactopmdetails.email, contactopmdetails.telefono").joins(:contactopmdetails).order(:proyecto_minero_id)


    Prawn::Document.generate "app/pdf_output/rpt_contactopms.pdf", :page_layout => :landscape  ,:page_size=>"A4"   do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/rpt_contactopms.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')

   end 

  
   def build_pdf_header(pdf)

     pdf.font "Helvetica" , :size => 8
      image_path = "#{Dir.pwd}/public/images/tpereda2.png"

    
      
       table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION INTEGRADO ",:rowspan => 2},"CODIGO ","TP-EC-F-011"], 
          ["VERSION: ","2"], 
          ["BASE DE DATOS DE CONTACTO A MINAS","Pagina: ","1 de 1 "] 
         
          ])
      



       pdf.table(table_content  ,{
           :position => :center,
           :width => pdf.bounds.width
         })do
           columns([1,2]).font_style = :bold
            columns([0]).width = 118.55
            columns([1]).width = 451.34
            columns([1]).align = :center
            
            columns([2]).width = 100
          
            columns([3]).width = 100
      
         end
        
         table_content2 = ([["Fecha : ",Date.today.strftime("%d/%m/%Y")]])

         pdf.table(table_content2,{:position=>:right }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 100
            
         end 

         pdf.move_down 2
      
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 8

      headers = []
      table_content = []

      Contactopm::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @rpt_contactopms 
             row = []
                 row << nroitem.to_s

                 row <<  product.proyecto_minero.descrip

                 row <<  product.contacto 
                 row <<  product.email 
                 row <<  product.telefono 


    
            table_content << row



            nroitem=nroitem + 1
             
        end

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                
                                          columns([2]).align=:left
                                  
                                          columns([3]).align=:left
                        
                                         
                                        end                                          
      pdf.move_down 10      
      pdf



  end


    def build_pdf_footer(pdf)

        table_content3 =[]
      row = []
      row << "--------------------------------------------"
      row << "--------------------------------------------"
      row << "--------------------------------------------"
      
      table_content3 << row 
      row = []
      row << "V.B.EXM.MEDICOS Y CAP. "
      row << "V.B.ADMINISTRACION"
      row << "V.B.GERENCIA"
      
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
  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contactopm
      @contactopm = Contactopm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contactopm_params
      params.require(:contactopm).permit(:proyecto_minero_id,:code, 
        :contactopmdetails_attributes => [:id,:contactopm_id, :contacto ,:email, :telefono, :destroy]  )
    end
end
