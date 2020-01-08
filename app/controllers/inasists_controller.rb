class InasistsController < ApplicationController
  before_action :set_inasist, only: [:show, :edit, :update, :destroy]

  # GET /inasists
  # GET /inasists.json
  def index
    @inasists = Inasist.all
  end

  # GET /inasists/1
  # GET /inasists/1.json
  def show
  end

  # GET /inasists/new
  def new
    @inasist = Inasist.new
  end

  # GET /inasists/1/edit
  def edit
  end

  # POST /inasists
  # POST /inasists.json
  def create
    @inasist = Inasist.new(inasist_params)

    respond_to do |format|
      if @inasist.save
        format.html { redirect_to @inasist, notice: 'Inasist was successfully created.' }
        format.json { render :show, status: :created, location: @inasist }
      else
        format.html { render :new }
        format.json { render json: @inasist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inasists/1
  # PATCH/PUT /inasists/1.json
  def update
    respond_to do |format|
      if @inasist.update(inasist_params)
        format.html { redirect_to @inasist, notice: 'Inasist was successfully updated.' }
        format.json { render :show, status: :ok, location: @inasist }
      else
        format.html { render :edit }
        format.json { render json: @inasist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inasists/1
  # DELETE /inasists/1.json
  def destroy
    @inasist.destroy
    respond_to do |format|
      format.html { redirect_to inasists_url, notice: 'Inasist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inasist
      @inasist = Inasist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inasist_params
      params.require(:inasist).permit(:name, :code)
    end
end
