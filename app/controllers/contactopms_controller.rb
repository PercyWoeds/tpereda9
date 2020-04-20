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
     @proyecto_minero = @company.get_proyecto_minero()
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contactopm
      @contactopm = Contactopm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contactopm_params
      params.require(:contactopm).permit(:proyecto_minero_id,:code, 
        :contactopmdetails_attributes => [:id,:contactopm_id, :contacto , :telefono, :_destroy]  )
    end
end
