class Mntos::MntoDetailsController < ApplicationController

  before_action :set_mnto
  before_action :set_mnto_detail, only: [:show, :edit, :update, :destroy]

  # GET /mnto_details
  # GET /mnto_details.json
  def index
    @mnto_details = MntoDetail.order(:activity_id)
  end

  # GET /mnto_details/1
  # GET /mnto_details/1.json
  def show
  end

  # GET /mnto_details/new
  def new
    @mnto_detail = MntoDetail.new
  end

  # GET /mnto_details/1/edit
  def edit
  end

  # POST /mnto_details
  # POST /mnto_details.json
  def create
    @mnto_detail = MntoDetail.new(mnto_detail_params)

    respond_to do |format|
      if @mnto_detail.save
        format.html { redirect_to @mnto_detail, notice: 'Mnto detail was successfully created.' }
        format.json { render :show, status: :created, location: @mnto_detail }
      else
        format.html { render :new }
        format.json { render json: @mnto_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mnto_details/1
  # PATCH/PUT /mnto_details/1.json
  def update
    respond_to do |format|
      if @mnto_detail.update(mnto_detail_params)
        format.html { redirect_to @mnto_detail, notice: 'Mnto detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @mnto_detail }
      else
        format.html { render :edit }
        format.json { render json: @mnto_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mnto_details/1
  # DELETE /mnto_details/1.json
  def destroy
    @mnto_detail.destroy
    respond_to do |format|
      format.html { redirect_to mnto_details_url, notice: 'Mnto detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  def editmultiple

    if params[:products_ids] != nil 
      
        @mnto_select = MntoDetail.find(params[:products_ids])      
    end     
    
  end

  def updatemultiple
 
       MntoDetail.where(id: params[:products_ids]).update_all(params[:mnto_detail])
      
      
      flash[:notice] = "Datos  modificados"
      redirect_to  mntos_path
      
  end


  private

  def set_mnto
      @mnto = Mnto.find(params[:mnto_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_mnto_detail
      @mnto_detail = MntoDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mnto_detail_params
      params.require(:mnto_detail).permit(:activity_id, :process, :mnto_id)
    end
end
