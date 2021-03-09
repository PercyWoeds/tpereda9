class TramitsController < ApplicationController
  before_action :set_tramit, only: [:show, :edit, :update, :destroy]

  # GET /tramits
  # GET /tramits.json
  def index
    @tramits = Tramit.all
  end

  # GET /tramits/1
  # GET /tramits/1.json
  def show
  end

  # GET /tramits/new
  def new
    @tramit = Tramit.new
  end

  # GET /tramits/1/edit
  def edit
  end

  # POST /tramits
  # POST /tramits.json
  def create
    @tramit = Tramit.new(tramit_params)

    respond_to do |format|
      if @tramit.save
        format.html { redirect_to @tramit, notice: 'Tramit was successfully created.' }
        format.json { render :show, status: :created, location: @tramit }
      else
        format.html { render :new }
        format.json { render json: @tramit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tramits/1
  # PATCH/PUT /tramits/1.json
  def update
    respond_to do |format|
      if @tramit.update(tramit_params)
        format.html { redirect_to @tramit, notice: 'Tramit was successfully updated.' }
        format.json { render :show, status: :ok, location: @tramit }
      else
        format.html { render :edit }
        format.json { render json: @tramit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tramits/1
  # DELETE /tramits/1.json
  def destroy
    @tramit.destroy
    respond_to do |format|
      format.html { redirect_to tramits_url, notice: 'Tramit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tramit
      @tramit = Tramit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tramit_params
      params.require(:tramit).permit(:code, :name)
    end
end
