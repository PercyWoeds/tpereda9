include UsersHelper
include CompaniesHelper
require 'peru_sunat_ruc'

class SuppliersController < ApplicationController
  before_filter :authenticate_user!
  

  def import
      Supplier.import(params[:file])
       redirect_to root_url, notice: "Proveedor  importadas."
  end 
  
 
 
  # Show suppliers for a company
  def list_suppliers
    @company = Company.find(params[:company_id])

    @id = params[:id]
  
    @pagetitle = "#{@company.name} - Suppliers"
  
    if(@company.can_view(current_user))

      if @id == "1" 

          puts "list suppliers ************************ "
         
         puts @id 

         if(params[:search] and params[:search] != "")                     
            
            @suppliers = Supplier.where(["company_id = ? and (ruc LIKE ? OR name LIKE ?) and tipo1 <> ? ", @company.id,"%" + params[:search] + "%", "%" + params[:search] + "%" , "4"]).order('name').paginate(:page => params[:page]) 
          else

            @suppliers = Supplier.where("company_id = ? and tipo1 <> ? ",@company.id , "4" ).order('name').paginate(:page => params[:page])
          end


      else 

         if(params[:search] and params[:search] != "")                     
            
            @suppliers = Supplier.where(["company_id = ? and (ruc LIKE ? OR name LIKE ?) ", @company.id,"%" + params[:search] + "%", "%" + params[:search] + "%" ]).order('name').paginate(:page => params[:page]) 
          else

            @suppliers = Supplier.where(company_id: @company.id).order('name').paginate(:page => params[:page])
          end

     end 

    else
      errPerms()
    end
  end
  
  # GET /suppliers
  # GET /suppliers.xml
  def index
    @pagetitle = "Suppliers"
    
    @path = 'suppliers'

    @customercsv = Supplier.all 
    respond_to do |format|
      format.html
      format.csv { send_data @customercsv.to_csv }
    
    end
  end

  # GET /suppliers/1
  # GET /suppliers/1.xml
  def show
    @company = Company.find(1)
    @supplier = Supplier.find(params[:id])
    @pagetitle = "Suppliers - #{@supplier.name}"
    @bancos = @company.get_banks()
    @supplier_detail = @supplier.supplier_details
 @tipoproveedor =@company.get_tipoproveedor()
  end

  # GET /suppliers/new
  # GET /suppliers/new.xml
  def new
    @pagetitle = "Nuevo proveedor"
    
    
      @company = Company.find(1)
      @bancos = @company.get_banks()
      @tipoproveedor =@company.get_tipoproveedor()
      @typeproveedor =@company.get_typeproveedor()
  
      @supplier = Supplier.new
      @supplier.company_id = @company.id
    
    if(params[:ajax])
      @ajax = true
      render :layout => false
    end
  end

  # GET /suppliers/1/edit
  def edit
    @company = Company.find(1)
    @bancos = @company.get_banks()
    @pagetitle = "Edit supplier"
     @tipoproveedor =@company.get_tipoproveedor()
      @typeproveedor =@company.get_typeproveedor()

    @supplier = Supplier.find(params[:id])
  end

  # POST /suppliers
  # POST /suppliers.xml
  def create
    @pagetitle = "New supplier"
    
    @company = Company.find(params[:supplier][:company_id])
  
    @supplier = Supplier.new(supplier_params)
   @tipoproveedor =@company.get_tipoproveedor()
  @bancos = @company.get_banks()
   @typeproveedor =@company.get_typeproveedor()

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to(@supplier, :notice => 'Supplier was successfully created.') }
        format.xml  { render :xml => @supplier, :status => :created, :location => @supplier }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @supplier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /suppliers/1
  # PUT /suppliers/1.xml
  def update
    @pagetitle = "Edit supplier"
     @company = Company.find(params[:supplier][:company_id])
    @bancos = @company.get_banks()
    @supplier = Supplier.find(params[:id])
 @tipoproveedor =@company.get_tipoproveedor()
  @typeproveedor =@company.get_typeproveedor()

    respond_to do |format|
      if @supplier.update_attributes(supplier_params)
        format.html { redirect_to(@supplier, :notice => 'Supplier was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @supplier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.xml
  def destroy
    
    
    @supplier = Supplier.find(params[:id])
    @bancos = @company.get_banks()
    
    @company = @supplier.company
     @tipoproveedor =@company.get_tipoproveedor()
    @typeproveedor =@company.get_typeproveedor()

   
    @ordens = Purchaseorder.find_by(supplier_id: @supplier.id)
    @services = Serviceorder.find_by(supplier_id: @supplier.id)
    @facturas = Purchase.find_by(supplier_id: @supplier.id)
    if @ordens || @services || @facturas 
      
    else  
      @supplier.destroy
    end 
    respond_to do |format|
      format.html { redirect_to "/companies/suppliers/#{@company.id}" }
      format.xml  { head :ok }
    end
  end

    # Create via ajax
  def create_ajax
    puts "create ajax "
    if(params[:name] and params[:name] != "" and params[:ruc] != "")
      params[:company_id]= 1
      @supplier = Supplier.new(:company_id => 1, :name => params[:name], :email => params[:email],
      :phone1 => params[:phone1], :phone2 => params[:phone2], :address1 => params[:address1],
      :address2 => params[:address2], :city => params[:city], :state => params[:state],
      :zip => params[:zip], :country => params[:country], :comments => params[:comments],:ruc=>params[:ruc])
      
      if @supplier.save
        render :text => "#{@supplier.id}|BRK|#{@supplier.name}"
      else
        render :text => "error"
      end
    else
      render :text => "error_empty"
    end
  end

 def search_ruc
  puts "search ajax "

    if params[:ruc]
        ruc_number  = params[:ruc]
        @supplier  = PeruSunatRuc.info_from ruc_number
        render :text => "#{@supplier.ruc_number}|BRK|#{@supplier.name}|BRK|#{@supplier.address}"

    

    else
        render :text => "error_empty"
    end 

  end



  def new2
     @pagetitle = "Nuevo Datos desde Sunat "
    
    @bancos = @company.get_banks()
      @company = Company.find(1)
    
      if(@company.can_view(current_user))
        @supplier = Supplier.new
        @supplier.company_id = @company.id
      else
        errPerms()
      end
    
    
    if(params[:ajax])
      @ajax = true
      render :layout => false
    end
  end

   def pdf

    @company = Company.find(1)
    
    @rpt_contactopms = Supplier.select("suppliers.*,supplier_details.name as contactos ,
      supplier_details.cargo as cargos,
      supplier_details.telefono as telefonos,
      supplier_details.correo as correos,
      supplier_details.area").joins(:supplier_details).where("tipoexm <> ?","4").order(:ruc)


    Prawn::Document.generate "app/pdf_output/rpt_supplier_exm.pdf", :page_layout => :landscape  ,:page_size=>"A4"   do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/rpt_supplier_exm.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')

   end 

  
   def build_pdf_header(pdf)

     pdf.font "Helvetica" , :size => 8
      image_path = "#{Dir.pwd}/public/images/tpereda2.png"

    
      
       table_content = ([ [{:image => image_path, :rowspan => 3 }, {:content =>"SISTEMA DE GESTION INTEGRADO ",:rowspan => 2},"CODIGO ","TP-EC-F-013"], 
          ["VERSION: ","2"], 
          ["BASE DE DATOS DE PROVEEDORES DE CLÍNICAS, EXÁMENES MÉDICOS Y CAPACITACIONES","Pagina: ","1 de 1 "] 
         
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

       Supplier::TABLE_HEADERS_EXM.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @rpt_contactopms 
             row = []
                 row << nroitem.to_s

                 row <<  product.name 

                 row <<  product.ruc 

                  row <<  product.contactos
                  row <<  product.cargos
                 row <<  product.telefonos
                 row <<  product.correos
                 row <<  product.get_banco(product.bank_id)
                 row <<  product.cuenta_corriente 
                 row <<  product.proyecto_minero 
                 row <<  product.comments 
                 row <<  product.lugar



    
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
                                          columns([4]).align=:center
                                          columns([5]).align=:left
                                          columns([6]).align=:left
                                          columns([7]).align=:left
                                          columns([8]).align=:center
                                          columns([9]).align=:left
                                          columns([10]).align=:left
                                          columns([11]).align=:left


                        
                                         
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
  


  def supplier_params
    params.require(:supplier).permit(:name, :email, :phone1, :phone2, :address1,:address2,:city, :state,:zip,
      :country,:comments,:ruc,:company_id,:taxable,:tipo1 ,:tipoexm, :bank_id,:cuenta_corriente,:proyecto_minero,:lugar )    
  end
  

end
