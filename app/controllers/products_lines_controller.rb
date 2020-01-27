class ProductsLinesController < ApplicationController
  before_action :set_products_line, only: [:show, :edit, :update, :destroy]

  # GET /products_lines
  # GET /products_lines.json
  def index
    @products_lines = ProductsLine.all
  end

  # GET /products_lines/1
  # GET /products_lines/1.json
  def show
  end

  # GET /products_lines/new
  def new
    @products_line = ProductsLine.new
  end

  # GET /products_lines/1/edit
  def edit
  end

  # POST /products_lines
  # POST /products_lines.json
  def create
    @products_line = ProductsLine.new(products_line_params)
    @products_line[:user_id] = current_user.id 

    respond_to do |format|
      if @products_line.save
        format.html { redirect_to @products_line, notice: 'Products line was successfully created.' }
        format.json { render :show, status: :created, location: @products_line }
      else
        format.html { render :new }
        format.json { render json: @products_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products_lines/1
  # PATCH/PUT /products_lines/1.json
  def update
     @products_line[:user_id] = current_user.id 
    respond_to do |format|
      if @products_line.update(products_line_params)
        format.html { redirect_to @products_line, notice: 'Products line was successfully updated.' }
        format.json { render :show, status: :ok, location: @products_line }
      else
        format.html { render :edit }
        format.json { render json: @products_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products_lines/1
  # DELETE /products_lines/1.json
  def destroy
    
    @products_line.destroy
    respond_to do |format|
      format.html { redirect_to products_lines_url, notice: 'Products line was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_products_line
      @products_line = ProductsLine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def products_line_params
      params.require(:products_line).permit(:code, :name, :user_id)
    end
end
