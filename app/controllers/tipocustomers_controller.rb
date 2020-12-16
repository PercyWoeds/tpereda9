class TipocustomersController < ApplicationController
  before_action :set_tipocustomer, only: [:show, :edit, :update, :destroy]

  # GET /tipocustomers
  # GET /tipocustomers.json
  def index
    @tipocustomers = Tipocustomer.all
  end

  # GET /tipocustomers/1
  # GET /tipocustomers/1.json
  def show
  end

  # GET /tipocustomers/new
  def new
    @tipocustomer = Tipocustomer.new
  end

  # GET /tipocustomers/1/edit
  def edit
  end

  # POST /tipocustomers
  # POST /tipocustomers.json
  def create
    @tipocustomer = Tipocustomer.new(tipocustomer_params)

    respond_to do |format|
      if @tipocustomer.save
        format.html { redirect_to @tipocustomer, notice: 'Tipocustomer was successfully created.' }
        format.json { render :show, status: :created, location: @tipocustomer }
      else
        format.html { render :new }
        format.json { render json: @tipocustomer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipocustomers/1
  # PATCH/PUT /tipocustomers/1.json
  def update
    respond_to do |format|
      if @tipocustomer.update(tipocustomer_params)
        format.html { redirect_to @tipocustomer, notice: 'Tipocustomer was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipocustomer }
      else
        format.html { render :edit }
        format.json { render json: @tipocustomer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipocustomers/1
  # DELETE /tipocustomers/1.json
  def destroy
    @tipocustomer.destroy
    respond_to do |format|
      format.html { redirect_to tipocustomers_url, notice: 'Tipocustomer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipocustomer
      @tipocustomer = Tipocustomer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipocustomer_params
      params.require(:tipocustomer).permit(:code, :name, :user_id, :co, :company_id)
    end
end
