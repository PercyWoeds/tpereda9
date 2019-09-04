class EessesController < ApplicationController
  before_action :set_eess, only: [:show, :edit, :update, :destroy]

  # GET /eesses
  # GET /eesses.json
  def index
    @eesses = Eess.all
  end

  # GET /eesses/1
  # GET /eesses/1.json
  def show
  end

  # GET /eesses/new
  def new
    @eess = Eess.new
  end

  # GET /eesses/1/edit
  def edit
  end

  # POST /eesses
  # POST /eesses.json
  def create
    @eess = Eess.new(eess_params)

    respond_to do |format|
      if @eess.save
        format.html { redirect_to @eess, notice: 'Eess was successfully created.' }
        format.json { render :show, status: :created, location: @eess }
      else
        format.html { render :new }
        format.json { render json: @eess.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eesses/1
  # PATCH/PUT /eesses/1.json
  def update
    respond_to do |format|
      if @eess.update(eess_params)
        format.html { redirect_to @eess, notice: 'Eess was successfully updated.' }
        format.json { render :show, status: :ok, location: @eess }
      else
        format.html { render :edit }
        format.json { render json: @eess.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eesses/1
  # DELETE /eesses/1.json
  def destroy
    @eess.destroy
    respond_to do |format|
      format.html { redirect_to eesses_url, notice: 'Eess was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eess
      @eess = Eess.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def eess_params
      params.require(:eess).permit(:code, :nombre, :address)
    end
end
