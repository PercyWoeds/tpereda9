class ContactopmdetailsController < ApplicationController
  before_action :set_contactopmdetail, only: [:show, :edit, :update, :destroy]

  # GET /contactopmdetails
  # GET /contactopmdetails.json
  def index
    @contactopmdetails = Contactopmdetail.all
  end

  # GET /contactopmdetails/1
  # GET /contactopmdetails/1.json
  def show
  end

  # GET /contactopmdetails/new
  def new
    @contactopmdetail = Contactopmdetail.new
  end

  # GET /contactopmdetails/1/edit
  def edit
  end

  # POST /contactopmdetails
  # POST /contactopmdetails.json
  def create
    @contactopmdetail = Contactopmdetail.new(contactopmdetail_params)

    respond_to do |format|
      if @contactopmdetail.save
        format.html { redirect_to @contactopmdetail, notice: 'Contactopmdetail was successfully created.' }
        format.json { render :show, status: :created, location: @contactopmdetail }
      else
        format.html { render :new }
        format.json { render json: @contactopmdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contactopmdetails/1
  # PATCH/PUT /contactopmdetails/1.json
  def update
    respond_to do |format|
      if @contactopmdetail.update(contactopmdetail_params)
        format.html { redirect_to @contactopmdetail, notice: 'Contactopmdetail was successfully updated.' }
        format.json { render :show, status: :ok, location: @contactopmdetail }
      else
        format.html { render :edit }
        format.json { render json: @contactopmdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contactopmdetails/1
  # DELETE /contactopmdetails/1.json
  def destroy
    @contactopmdetail.destroy
    respond_to do |format|
      format.html { redirect_to contactopmdetails_url, notice: 'Contactopmdetail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contactopmdetail
      @contactopmdetail = Contactopmdetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contactopmdetail_params
      params.require(:contactopmdetail).permit(:contacto, :email, :telefono, :contactopm_id)
    end
end
