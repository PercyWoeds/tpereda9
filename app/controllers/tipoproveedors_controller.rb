class TipoproveedorsController < ApplicationController
  before_action :set_tipoproveedor, only: [:show, :edit, :update, :destroy]

  # GET /tipoproveedors
  # GET /tipoproveedors.json
  def index
    @tipoproveedors = Tipoproveedor.all
  end

  # GET /tipoproveedors/1
  # GET /tipoproveedors/1.json
  def show
  end

  # GET /tipoproveedors/new
  def new
    @tipoproveedor = Tipoproveedor.new
  end

  # GET /tipoproveedors/1/edit
  def edit
  end

  # POST /tipoproveedors
  # POST /tipoproveedors.json
  def create
    @tipoproveedor = Tipoproveedor.new(tipoproveedor_params)

    respond_to do |format|
      if @tipoproveedor.save
        format.html { redirect_to @tipoproveedor, notice: 'Tipoproveedor was successfully created.' }
        format.json { render :show, status: :created, location: @tipoproveedor }
      else
        format.html { render :new }
        format.json { render json: @tipoproveedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipoproveedors/1
  # PATCH/PUT /tipoproveedors/1.json
  def update
    respond_to do |format|
      if @tipoproveedor.update(tipoproveedor_params)
        format.html { redirect_to @tipoproveedor, notice: 'Tipoproveedor was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipoproveedor }
      else
        format.html { render :edit }
        format.json { render json: @tipoproveedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipoproveedors/1
  # DELETE /tipoproveedors/1.json
  def destroy
    @tipoproveedor.destroy
    respond_to do |format|
      format.html { redirect_to tipoproveedors_url, notice: 'Tipoproveedor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipoproveedor
      @tipoproveedor = Tipoproveedor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipoproveedor_params
      params.require(:tipoproveedor).permit(:code, :name)
    end
end
