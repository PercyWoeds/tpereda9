class AntecedentsController < ApplicationController
  before_action :set_antecedent, only: [:show, :edit, :update, :destroy]

  # GET /antecedents
  # GET /antecedents.json
  def index
    @antecedents = Antecedent.all
  end

  # GET /antecedents/1
  # GET /antecedents/1.json
  def show
  end

  # GET /antecedents/new
  def new
    @antecedent = Antecedent.new
  end

  # GET /antecedents/1/edit
  def edit
  end

  # POST /antecedents
  # POST /antecedents.json
  def create
    @antecedent = Antecedent.new(antecedent_params)

    respond_to do |format|
      if @antecedent.save
        format.html { redirect_to @antecedent, notice: 'Antecedent was successfully created.' }
        format.json { render :show, status: :created, location: @antecedent }
      else
        format.html { render :new }
        format.json { render json: @antecedent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /antecedents/1
  # PATCH/PUT /antecedents/1.json
  def update
    respond_to do |format|
      if @antecedent.update(antecedent_params)
        format.html { redirect_to @antecedent, notice: 'Antecedent was successfully updated.' }
        format.json { render :show, status: :ok, location: @antecedent }
      else
        format.html { render :edit }
        format.json { render json: @antecedent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /antecedents/1
  # DELETE /antecedents/1.json
  def destroy
    @antecedent.destroy
    respond_to do |format|
      format.html { redirect_to antecedents_url, notice: 'Antecedent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_antecedent
      @antecedent = Antecedent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def antecedent_params
      params.require(:antecedent).permit(:code, :name)
    end
end
