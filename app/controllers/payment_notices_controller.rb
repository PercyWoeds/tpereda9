include UsersHelper 
include CustomersHelper
include ServicesHelper
require "open-uri"
 



class PaymentNoticesController < ApplicationController
  before_action :set_payment_notice, only: [:show, :edit, :update, :destroy ]

  # GET /payment_notices
  # GET /payment_notices.json
  def index
    @payment_notices = PaymentNotice.all
  end

  # GET /payment_notices/1
  # GET /payment_notices/1.json
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
    @payment_notice[:company_id] = @company.id 
  end

  # GET /payment_notices/new
  def new
    @payment_notice = PaymentNotice.new
    @payment_notice[:fecha] = Date.today 


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
    @payment_notice[:company_id] = @company.id 


  end

  # GET /payment_notices/1/edit
  def edit
  end

  # POST /payment_notices
  # POST /payment_notices.json
  def create

    @pagetitle = "Nueva factura "
    @action_txt = "Create"
    
    items = params[:items].split(",")
    @anio =  Date.current.year
    puts @anio 

    @payment_notice = PaymentNotice.new(payment_notice_params)

    @payment_notice[:code]  =  @payment_notice.generate_rq_number(@anio)

    @payment_notice[:total] = @payment_notice.get_total(items)

    respond_to do |format|
      if @payment_notice.save
   

         @payment_notice.add_products(items)
         
               # Check if we gotta process the invoice
         @payment_notice.process()


        format.html { redirect_to @payment_notice, notice: 'Payment notice was successfully created.' }
        format.json { render :show, status: :created, location: @payment_notice }
      else
        format.html { render :new }
        format.json { render json: @payment_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_notices/1
  # PATCH/PUT /payment_notices/1.json
  def update
    respond_to do |format|
      if @payment_notice.update(payment_notice_params)
        format.html { redirect_to @payment_notice, notice: 'Payment notice was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_notice }
      else
        format.html { render :edit }
        format.json { render json: @payment_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_notices/1
  # DELETE /payment_notices/1.json
  def destroy
    @payment_notice.destroy
    respond_to do |format|
      format.html { redirect_to payment_notices_url, notice: 'Payment notice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end




  
  # List items
  def list_items
    
    @company = Company.find(1)
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0



    for item in items
      if item != ""
        parts = item.split("|BRK|")
        
        fecha_inicio = parts[0]
        fecha_culmina = parts[1]
        qty  = parts[2]
        descrip  = parts[3]
        lugar = parts[4]
        price_unit = parts[5]
        pm = parts[6]
        nro_compro  = parts[7]
        nro_documento   = parts[8]
        observa  = parts[9]

        total = price_unit.to_f * qty.to_f


        product = PaymentnoticeDetail.new 
        product[:fecha_inicio] = fecha_inicio
        product[:fecha_culmina] = fecha_culmina
        product[:qty] = qty.to_f
        product[:descrip] = descrip
        product[:lugar] = lugar
        product[:price_unit] = price_unit.to_f
        product[:total] = total.to_f
        product[:igv] = total.to_f / 1.18
        product[:sub_total] = product[:total] - product[:igv]
        product[:nro_compro] = nro_compro
        product[:nro_documento] = nro_documento
        product[:observa] = observa 
  
        
        @products.push(product)
      end
      
      i += 1
   end
    
    render :layout => false
  end


   def do_anular
      @payment_notice  = PaymentNotice.find(params[:id])
      @payment_notice[:processed] = "2"
      
      @payment_notice.anular 
      
      flash[:notice] = "Documento a sido anulado."
      redirect_to @payment_notice
  end


 def do_process
    @payment_notice  = PaymentNotice.find(params[:id])
    @payment_notice[:processed] = "1"


    @payment_notice.process
    
    flash[:notice] = "El documento ha sido procesado."
    redirect_to @payment_notice
  end



  def pdf
    @payment_notice = PaymentNotice.find(params[:id])
  
    @company =Company.find(1) 
    


    Prawn::Document.generate("app/pdf_output/#{@payment_notice.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        @lcFileName =  "app/pdf_output/#{@payment_notice.id}.pdf"      
        
    end     

    @lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+@lcFileName      
              send_file("#{@lcFileName1}", :type => 'application/pdf',
    :disposition => 'inline')
  
  end
  
  
def build_pdf_header(pdf)

      pdf.font "Helvetica"  , :size => 8

     image_path = "#{Dir.pwd}/public/images/tpereda2.png"
      
       table_content = ([ [{:image => image_path, :rowspan => 3 , position: :center, vposition: :center}, {:content =>"SISTEMA DE GESTIÓN INTEGRADO",:rowspan => 2},"CODIGO ","TP-ADM-F-002"], 
          ["VERSION: ","3"], 
          ["AVISO DE PAGO ","Pagina: ","1 de 1 "] 
         
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
      # detalle 2

        table_content_t2 = ([[" Mediante la presente se solicita realizar el pago por concepto de: " + @payment_notice.concepto]])

         pdf.table(table_content_t2,{:position=>:right, :cell_style => {:border_width => 0},
          :width => pdf.bounds.width  }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 540
            
         end 


         table_content_t1 = ([["DETALLE  "]])

         pdf.table(table_content_t1,{:position=>:right, :cell_style => {:border_width => 1},
          :width => pdf.bounds.width  }) do

            columns([0, 1]).font_style = :bold
            columns([0, 1]).width = 540
            columns([0 ]).background_color = "FFFFCC"
            columns([0 ]).align = :center 
         end 



       pdf.font "Helvetica" , :size => 5

         headers = []
      table_content = []

      PaymentNotice::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers



        nro_item = 1
        total_valor = 0 


       for product in @payment_notice.get_products

          row = []   
           row << nro_item.to_s 

           row <<  product.fecha_inicio.strftime("%d/%m/%Y")

           row << product.fecha_culmina.strftime("%d/%m/%Y")

           row << product.qty
           row <<  product.descrip
           row << product.lugar
           row << sprintf("%.2f",product.price_unit.to_s)
           row << sprintf("%.2f",product.sub_total.to_s)
           row << sprintf("%.2f",product.igv.to_s)
           row << sprintf("%.2f",product.total.to_s)
           row << product.nro_compro 
           row << product.nro_documento
           row << product.observa 

           table_content << row

          nro_item += 1
            
          total_valor += product.total.round(2)

       end 

   
           row = []

           row << ""

           row << ""

           row << ""
           row << ""
           row << ""
           row << ""
           row << ""
           row << ""
           row << ""
           row << sprintf("%.2f",total_valor.to_s)
          
           row << ""
           row << ""

           table_content << row

       result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align =:center
                                          columns([1]).align =:left
                                          columns([2]).align =:left
                                          columns([3]).align =:left
                                          columns([4]).align =:left
                                          columns([4]).width = 100
                                          columns([5]).align =:center  
                                          columns([6]).align =:right
                                          columns([7]).align =:right
                                          columns([8]).align =:right
                                          columns([9]).align =:right
                                          columns([10]).align =:left
                                          columns([10]).width = 50
                                          columns([11]).align =:left
                                          columns([11]).width = 50
                                          columns([12]).align =:left
                                          columns([12]).width = 50
                                        end                                          
      pdf.move_down 10 



   pdf.font "Helvetica" , :size => 5
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
          :cell_style => {:border_width => 1},
          :width => pdf.bounds.width * 0.75
        }) do
          columns([0, 2  ]).font_style = :bold
          columns([0 ]).background_color = "FFFFCC"
        end
      

      end


      pdf.move_down 5 
      
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
          :cell_style => {:border_width => 1},
          :width => pdf.bounds.width * 0.75
        }) do
          columns([0]).font_style = :bold
          columns([0]).width = 100
          columns([0 ]).background_color = "FFFFCC"

        end
      

      end

####


 pdf.move_down 5 

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
          :cell_style => {:border_width => 1},
          :width => pdf.bounds.width * 0.75
        }) do
          columns([0  ]).font_style = :bold
          columns([0 ]).background_color = "FFFFCC"
        end
      

      end


      pdf.move_down 5 
      
       max_rows = [exm_7.length,exm_7.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (exm_7.length >= row ? exm_7[rows_index] : ['',''])
        
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 1},
          :width => pdf.bounds.width * 0.75
        }) do
         columns([0]).font_style = :bold
          columns([0]).width = 100
           columns([0 ]).background_color = "FFFFCC"
        end
      

      end
      
      pdf

    end


    def build_pdf_footer(pdf)


        pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom+110], :width  => pdf.bounds.width ) do
            
            pdf.stroke_horizontal_rule
        
        
        data =[ ["  Elaborado por: ","Autorizado por:","Recibido por: "],
               [" "," "," "],
               ["_" * 50,"_" * 50,"_" * 50],
               ["Cargo ","Gerencia Administrativa/ Administración","Área de Finanzas"],
               ["Nombre:","Nombre:","Nombre:"]
                ]

           
            pdf.text " "
           
          pdf.table(data) do  
    
              cells.borders =[] 
             
              row(0).font_style   =:bold 
             columns([0,1,2]).align = :center
              
              
           end 
               

      end
      pdf
      
  end



 def client_data_headers
  
      client_headers  = [["PARA : ",@payment_notice.employee.full_name ]] 
      client_headers << ["ASUNTO : ",@payment_notice.asunto   ] 

      client_headers << ["FECHA : ",@payment_notice.fecha.strftime("%d/%m/%Y")   ]  
      client_headers 

  end

def invoice_headers   
    
      invoice_headers  = [["NRO.: ",@payment_notice.code   ]]
      invoice_headers <<  ["Estado  : ",@payment_notice.get_processed ]  

      invoice_headers
  end


  def exm_2
     
   
      exm_2   = [[ "PARA : ",@payment_notice.employee.full_name  ]]
      exm_2 <<  ["ASUNTO : ",@payment_notice.asunto   ]
      exm_2 <<  ["FECHA : ",@payment_notice.fecha.strftime("%d/%m/%Y")   ]  


      exm_2 


  end

  def exm_3

      exm_3   = [[@payment_notice.concepto  ]]
      exm_3 

    
  end

  def exm_4

      exm_4   = [["DATOS DE LA CUENTA " ,  ]]
      exm_4   

    
  end

  def exm_5

      exm_5   = [["RAZON SOCIAL: " , @payment_notice.supplier.name  ]]
      exm_5 << ["R.U.C/D.N.I:",""]
      exm_5 << ["(CTA CTE/CTA DE AHORROS EN SOLES/DOLARES)",""]
      exm_5 << ["BANCO:",""]
      exm_5 << ["FORMA DE PAGO:",""]
      exm_5 << ["TIEMPO DE CRÉDITO:",""]
      exm_5 << ["FECHA DE VENCIMIENTO:",""]

    
  end


  def exm_6

      exm_6   = [["DATOS DE LA DETRACCION" ,  ]]
      exm_6 

    
  end

  def exm_7

      exm_7   = [["BANCO: " , ""  ]]
      exm_7 << ["CTA CTE EN SOLES:",""]
      exm_7 << ["MONTO:",""]
      exm_7

    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_notice
      @payment_notice = PaymentNotice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_notice_params
      params.require(:payment_notice).permit(:code, :employee_id, :asunto, :fecha, :concepto, :total, :processed, :date_processed,:supplier_id )
    end
end


