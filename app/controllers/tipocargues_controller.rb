class TipocarguesController < ApplicationController
  before_action :set_tipocargue, only: [:show, :edit, :update, :destroy]

  # GET /tipocargues
  # GET /tipocargues.json
  def index
    @tipocargues = Tipocargue.all
  end

  # GET /tipocargues/1
  # GET /tipocargues/1.json
  def show
  end

  # GET /tipocargues/new
  def new
    @tipocargue = Tipocargue.new
  end

  # GET /tipocargues/1/edit
  def edit
  end

  # POST /tipocargues
  # POST /tipocargues.json
  def create
    @tipocargue = Tipocargue.new(tipocargue_params)

    respond_to do |format|
      if @tipocargue.save
        format.html { redirect_to @tipocargue, notice: 'Tipocargue was successfully created.' }
        format.json { render :show, status: :created, location: @tipocargue }
      else
        format.html { render :new }
        format.json { render json: @tipocargue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipocargues/1
  # PATCH/PUT /tipocargues/1.json
  def update
    respond_to do |format|
      if @tipocargue.update(tipocargue_params)
        format.html { redirect_to @tipocargue, notice: 'Tipocargue was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipocargue }
      else
        format.html { render :edit }
        format.json { render json: @tipocargue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipocargues/1
  # DELETE /tipocargues/1.json
  def destroy
    @tipocargue.destroy
    respond_to do |format|
      format.html { redirect_to tipocargues_url, notice: 'Tipocargue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipocargue
      @tipocargue = Tipocargue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipocargue_params
      params.require(:tipocargue).permit(:code, :name)
    end
end
