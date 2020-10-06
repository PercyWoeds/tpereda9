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
  
    @pagetitle = "#{@company.name} - Suppliers"
  
    if(@company.can_view(current_user))

     if(params[:search] and params[:search] != "")                     
        
        @suppliers = Supplier.where(["company_id = ? and (ruc LIKE ? OR name LIKE ?) ", @company.id,"%" + params[:search] + "%", "%" + params[:search] + "%" ]).order('name').paginate(:page => params[:page]) 
      else

        @suppliers = Supplier.where(company_id: @company.id,tipo1: @tipo ).order('name').paginate(:page => params[:page])
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
    @supplier = Supplier.find(params[:id])
    @pagetitle = "Suppliers - #{@supplier.name}"

    @supplier_detail = @supplier.supplier_details

  end

  # GET /suppliers/new
  # GET /suppliers/new.xml
  def new
    @pagetitle = "Nuevo proveedor"
    
    
      @company = Company.find(1)
      @bancos = @company.get_banks()
      @tipoproveedor =@company.get_tipoproveedor()

  
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

    @supplier = Supplier.find(params[:id])
  end

  # POST /suppliers
  # POST /suppliers.xml
  def create
    @pagetitle = "New supplier"
    
    @company = Company.find(params[:supplier][:company_id])
  
    @supplier = Supplier.new(supplier_params)
  
  
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
    
    @supplier = Supplier.find(params[:id])

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
    
    
    @company = @supplier.company
    
   
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

  def supplier_params
    params.require(:supplier).permit(:name, :email, :phone1, :phone2, :address1,:address2,:city, :state,:zip,
      :country,:comments,:ruc,:company_id,:taxable,:tipo1 ,:bank_id,:cuenta_corriente,:proyecto_minero)    
  end
  

end
