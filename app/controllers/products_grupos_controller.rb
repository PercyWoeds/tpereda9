class ProductsGruposController < ApplicationController
  before_action :set_products_grupo, only: [:show, :edit, :update, :destroy]

  # GET /products_grupos
  # GET /products_grupos.json
  def index
    @products_grupos = ProductsGrupo.all
  end

  # GET /products_grupos/1
  # GET /products_grupos/1.json
  def show
  end

  # GET /products_grupos/new
  def new
    @products_grupo = ProductsGrupo.new
  end

  # GET /products_grupos/1/edit
  def edit
  end

  # POST /products_grupos
  # POST /products_grupos.json
  def create
    @products_grupo = ProductsGrupo.new(products_grupo_params)

    respond_to do |format|
      if @products_grupo.save
        format.html { redirect_to @products_grupo, notice: 'Products grupo was successfully created.' }
        format.json { render :show, status: :created, location: @products_grupo }
      else
        format.html { render :new }
        format.json { render json: @products_grupo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products_grupos/1
  # PATCH/PUT /products_grupos/1.json
  def update
    respond_to do |format|
      if @products_grupo.update(products_grupo_params)
        format.html { redirect_to @products_grupo, notice: 'Products grupo was successfully updated.' }
        format.json { render :show, status: :ok, location: @products_grupo }
      else
        format.html { render :edit }
        format.json { render json: @products_grupo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products_grupos/1
  # DELETE /products_grupos/1.json
  def destroy
    @products_grupo.destroy
    respond_to do |format|
      format.html { redirect_to products_grupos_url, notice: 'Products grupo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_products_grupo
      @products_grupo = ProductsGrupo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def products_grupo_params
      params.require(:products_grupo).permit(:code, :name, :user_id)
    end
end
