class ClaseCatsController < ApplicationController
  before_action :set_clase_cat, only: [:show, :edit, :update, :destroy]

  # GET /clase_cats
  # GET /clase_cats.json
  def index
    @clase_cats = ClaseCat.all
  end

  # GET /clase_cats/1
  # GET /clase_cats/1.json
  def show
  end

  # GET /clase_cats/new
  def new
    @clase_cat = ClaseCat.new
  end

  # GET /clase_cats/1/edit
  def edit
  end

  # POST /clase_cats
  # POST /clase_cats.json
  def create
    @clase_cat = ClaseCat.new(clase_cat_params)

    respond_to do |format|
      if @clase_cat.save
        format.html { redirect_to @clase_cat, notice: 'Clase cat was successfully created.' }
        format.json { render :show, status: :created, location: @clase_cat }
      else
        format.html { render :new }
        format.json { render json: @clase_cat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clase_cats/1
  # PATCH/PUT /clase_cats/1.json
  def update
    respond_to do |format|
      if @clase_cat.update(clase_cat_params)
        format.html { redirect_to @clase_cat, notice: 'Clase cat was successfully updated.' }
        format.json { render :show, status: :ok, location: @clase_cat }
      else
        format.html { render :edit }
        format.json { render json: @clase_cat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clase_cats/1
  # DELETE /clase_cats/1.json
  def destroy
    @clase_cat.destroy
    respond_to do |format|
      format.html { redirect_to clase_cats_url, notice: 'Clase cat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clase_cat
      @clase_cat = ClaseCat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clase_cat_params
      params.require(:clase_cat).permit(:code, :name, :user_id, :company_id)
    end
end
