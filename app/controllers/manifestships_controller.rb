class ManifestshipsController < ApplicationController
  before_action :set_manifestship, only: [:show, :edit, :update, :destroy]

  # GET /manifestships
  # GET /manifestships.json
  def index
    @manifestships = Manifestship.all
  end

  # GET /manifestships/1
  # GET /manifestships/1.json
  def show
  end

  # GET /manifestships/new
  def new
    @manifestship = Manifestship.new
  end

  # GET /manifestships/1/edit
  def edit
  end

  # POST /manifestships
  # POST /manifestships.json
  def create
    @manifestship = Manifestship.new(manifestship_params)

    respond_to do |format|
      if @manifestship.save
        format.html { redirect_to @manifestship, notice: 'Manifestship was successfully created.' }
        format.json { render :show, status: :created, location: @manifestship }
      else
        format.html { render :new }
        format.json { render json: @manifestship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manifestships/1
  # PATCH/PUT /manifestships/1.json
  def update
    respond_to do |format|
      if @manifestship.update(manifestship_params)
        format.html { redirect_to @manifestship, notice: 'Manifestship was successfully updated.' }
        format.json { render :show, status: :ok, location: @manifestship }
      else
        format.html { render :edit }
        format.json { render json: @manifestship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manifestships/1
  # DELETE /manifestships/1.json
  def destroy
    @manifestship.destroy
    respond_to do |format|
      format.html { redirect_to manifestships_url, notice: 'Manifestship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manifestship
      @manifestship = Manifestship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manifestship_params
      params.require(:manifestship).permit(:tranportorder_id, :manifest_id)
    end
end
