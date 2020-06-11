class CdocumentsController < ApplicationController
  before_action :set_cdocument, only: [:show, :edit, :update, :destroy]

  # GET /cdocuments
  # GET /cdocuments.json
  def index
    @cdocuments = Cdocument.all
  end

  # GET /cdocuments/1
  # GET /cdocuments/1.json
  def show
  end

  # GET /cdocuments/new
  def new
    @company = Company.find(1)
    @cdocument = Cdocument.new
    @employees = @company.get_employees
  end

  # GET /cdocuments/1/edit
  def edit
  end

  # POST /cdocuments
  # POST /cdocuments.json
  def create
    @cdocument = Cdocument.new(cdocument_params)

    respond_to do |format|
      if @cdocument.save
        format.html { redirect_to @cdocument, notice: 'Cdocument was successfully created.' }
        format.json { render :show, status: :created, location: @cdocument }
      else
        format.html { render :new }
        format.json { render json: @cdocument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cdocuments/1
  # PATCH/PUT /cdocuments/1.json
  def update
    respond_to do |format|
      if @cdocument.update(cdocument_params)
        format.html { redirect_to @cdocument, notice: 'Cdocument was successfully updated.' }
        format.json { render :show, status: :ok, location: @cdocument }
      else
        format.html { render :edit }
        format.json { render json: @cdocument.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cdocuments/1
  # DELETE /cdocuments/1.json
  def destroy
    @cdocument.destroy
    respond_to do |format|
      format.html { redirect_to cdocuments_url, notice: 'Cdocument was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cdocument
      @cdocument = Cdocument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cdocument_params
      params.require(:cdocument).permit(:employee_id, :lugar, :experiencia, :dni, :categoria, :exp_licencia, :rev_licencia, :categoria_especial, :exp_licencia2, :rev_licencia, :iqbf, :dni_emision, :dni_caducidad, :ap_emision, :ap_caducidad, :app_emision, :app_caducidad, :cv_documentado, :nivel_educativo)
    end
end
