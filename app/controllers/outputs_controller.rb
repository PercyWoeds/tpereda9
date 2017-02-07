
include UsersHelper
include CustomersHelper
include ProductsHelper

class OutputsController < ApplicationController
  before_filter :authenticate_user!, :checkProducts
 
  
  # Export output to PDF
  def pdf
    @output = Output.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/outputs/pdf/#{@output.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an output
  def do_process
    @output = Output.find(params[:id])
    @output[:processed] = "1"
    
    @output.process
    
    flash[:notice] = "The output order has been processed."
    redirect_to @output
  end
  
  # Do send output via email
  def do_email
    @output = Output.find(params[:id])
    @email = params[:email]
    
    Notifier.output(@email, @output).deliver
    
    flash[:notice] = "The output has been sent successfully."
    redirect_to "/outputs/#{@output.id}"
  end

  
  # Send output via email
  def email
    @output = Output.find(params[:id])
    @company = @output.company
  end
  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0

    for item in items
      if item != ""
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]        
        
        product = Product.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_i
        product[:price] = price.to_f
                
        total = product[:price] * product[:quantity]
        
        
        product[:CurrTotal] = total
        
        @products.push(product)
      end
      
      i += 1
   end
    
    render :layout => false
  end
  
  
  # Autocomplete for products
  def ac_products
    @products = Product.where(["company_id = ? AND (code LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Autocomplete for users
  def ac_user
    company_users = CompanyUser.where(company_id: params[:company_id])
    user_ids = []
    
    for cu in company_users
      user_ids.push(cu.user_id)
    end
    
    @users = User.where(["id IN (#{user_ids.join(",")}) AND (email LIKE ? OR username LIKE ?)", "%" + params[:q] + "%", "%" + params[:q] + "%"])
    alr_ids = []
    
    for user in @users
      alr_ids.push(user.id)
    end
    
    if(not alr_ids.include?(getUserId()))
      @users.push(current_user)
    end
   
    render :layout => false
  end
  
  # Autocomplete for customers
  def ac_customers
    @customers = Customer.where(["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show outputs for a company
  def list_outputs
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - outputs"
    @filters_display = "block"
    
    @locations = Location.where(company_id: @company.id).order("name ASC")
    @divisions = Division.where(company_id: @company.id).order("name ASC")
    
    if(params[:location] and params[:location] != "")
      @sel_location = params[:location]
    end
    
    if(params[:division] and params[:division] != "")
      @sel_division = params[:division]
    end
  
    if(@company.can_view(current_user))
      if(params[:ac_customer] and params[:ac_customer] != "")
        @customer = Customer.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_customer].strip})
        
        if @customer
          @outputs = Output.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any outputs for that customer."
          redirect_to "/companies/outputs/#{@company.id}"
        end
      elsif(params[:customer] and params[:customer] != "")
        @customer = Customer.find(params[:customer])
        
        if @customer
          @outputs = Output.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any outputs for that customer."
          redirect_to "/companies/outputs/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @outputs = Output.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @outputs = Output.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @outputs = Output.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @outputs = Output.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @outputs = Output.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /outputs
  # GET /outputs.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'outputs'
    @pagetitle = "outputs"
  end

  # GET /outputs/1
  # GET /outputs/1.xml
  def show
    @output = Output.find(params[:id])
    @supplier = @output.supplier
    @employee = @output.employee
    @truck  = @output.truck
  end

  # GET /outputs/new
  # GET /outputs/new.xml

  
  
  def new
    @pagetitle = "New output"
    @action_txt = "Create"
    
    @output = Output.new
    @output[:code] = "#{generate_guid10()}"
    @output[:processed] = false
    
    @company = Company.find(params[:company_id])
    @output.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @suppliers = @company.get_suppliers()
    @employees = @company.get_employees()
    @trucks = @company.get_trucks()    
    
    @ac_user = getUsername()
    @output[:user_id] = getUserId()
  end


  # GET /outputs/1/edit
  def edit
    @pagetitle = "Edit output"
    @action_txt = "Update"
    
    @output = Output.find(params[:id])
    @company = @output.company
    @ac_customer = @output.customer.name
    @ac_user = @output.user.username
    
    @suppliers = @company.get_suppliers()
    @employees = @company.get_employees()
    @trucks = @company.get_trucks()    
    
    @products_lines = @output.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /outputs
  # POST /outputs.xml
  def create
    @pagetitle = "New output"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @output = Output.new(output_params)
    
    @company = Company.find(params[:output][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @suppliers = @company.get_suppliers()
    @employees = @company.get_employees()
    @trucks = @company.get_trucks()    
    
    
    @output[:subtotal] = @output.get_subtotal(items)
    
    begin
      @output[:tax] = @output.get_tax(items)
    rescue
      @output[:tax] = 0
    end
    
    @output[:total] = @output[:subtotal] + @output[:tax]
    
    if(params[:output][:user_id] and params[:output][:user_id] != "")
      curr_seller = User.find(params[:output][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @output.save
        # Create products for kit
        @output.add_products(items)
        
        # Check if we gotta process the output
        @output.process()
        @output.correlativo

        
        format.html { redirect_to(@output, :notice => 'output was successfully created.') }
        format.xml  { render :xml => @output, :status => :created, :location => @output }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @output.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /outputs/1
  # PUT /outputs/1.xml
  def update
    @pagetitle = "Edit output"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @output = Output.find(params[:id])
    @company = @output.company
    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @output.customer.name
    end
    
    @products_lines = @output.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @output[:subtotal] = @output.get_subtotal(items)
    @output[:tax] = @output.get_tax(items)
    @output[:total] = @output[:subtotal] + @output[:tax]



    respond_to do |format|
      if @output.update_attributes(params[:output])
        # Create products for kit
        @output.delete_products()
        @output.add_products(items)
        
        # Check if we gotta process the output
        @output.process()

        
        format.html { redirect_to(@output, :notice => 'output was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @output.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /outputs/1
  # DELETE /outputs/1.xml
  def destroy
    @output = Output.find(params[:id])
    company_id = @output[:company_id]
    @output.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/outputs/" + company_id.to_s) }
    end
  end

  private
  def output_params
    params.require(:output).permit(:company_id,:location_id,:division_id,:supplier_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:employee_id,:truck_id)
  end

end



