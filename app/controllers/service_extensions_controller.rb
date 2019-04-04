class ServiceExtensionsController < ApplicationController
  before_action :set_service_extension, only: [:show, :edit, :update, :destroy]

  # GET /service_extensions
  # GET /service_extensions.json
  def index
    @service_extensions = ServiceExtension.all
  end

  # GET /service_extensions/1
  # GET /service_extensions/1.json
  def show
  end

  # GET /service_extensions/new
  def new
    @service_extension = ServiceExtension.new
    
  end

  # GET /service_extensions/1/edit
  def edit
  end

  # POST /service_extensions
  # POST /service_extensions.json
  def create
    @service_extension = ServiceExtension.new(service_extension_params)

    respond_to do |format|
      if @service_extension.save
        format.html { redirect_to @service_extension, notice: 'Service extension was successfully created.' }
        format.json { render :show, status: :created, location: @service_extension }
      else
        format.html { render :new }
        format.json { render json: @service_extension.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_extensions/1
  # PATCH/PUT /service_extensions/1.json
  def update
    respond_to do |format|
      if @service_extension.update(service_extension_params)
        format.html { redirect_to @service_extension, notice: 'Service extension was successfully updated.' }
        format.json { render :show, status: :ok, location: @service_extension }
      else
        format.html { render :edit }
        format.json { render json: @service_extension.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_extensions/1
  # DELETE /service_extensions/1.json
  def destroy
    @service_extension.destroy
    respond_to do |format|
      format.html { redirect_to service_extensions_url, notice: 'Service extension was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_extension
      @service_extension = ServiceExtension.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_extension_params
      params.require(:service_extension).permit(:code, :name, :servicebuy_id)
    end
end
