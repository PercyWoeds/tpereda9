class Proyectominero3sController < ApplicationController
  before_action :set_proyectominero3, only: [:show, :edit, :update, :destroy]

  # GET /proyectominero3s
  # GET /proyectominero3s.json
  def index
    @proyectominero3s = Proyectominero3.all
  end

  # GET /proyectominero3s/1
  # GET /proyectominero3s/1.json
  def show
  end

  # GET /proyectominero3s/new
  def new
    @proyectominero3 = Proyectominero3.new
      @user_id = @current_user.id  
  end

  # GET /proyectominero3s/1/edit
  def edit
  end

  # POST /proyectominero3s
  # POST /proyectominero3s.json
  def create
    @proyectominero3 = Proyectominero3.new(proyectominero3_params)
    @proyectominero3[:user_id] = @user_id 

    respond_to do |format|
      if @proyectominero3.save
        format.html { redirect_to @proyectominero3, notice: 'Proyectominero3 was successfully created.' }
        format.json { render :show, status: :created, location: @proyectominero3 }
      else
        format.html { render :new }
        format.json { render json: @proyectominero3.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proyectominero3s/1
  # PATCH/PUT /proyectominero3s/1.json
  def update
    respond_to do |format|
      if @proyectominero3.update(proyectominero3_params)
        format.html { redirect_to @proyectominero3, notice: 'Proyectominero3 was successfully updated.' }
        format.json { render :show, status: :ok, location: @proyectominero3 }
      else
        format.html { render :edit }
        format.json { render json: @proyectominero3.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proyectominero3s/1
  # DELETE /proyectominero3s/1.json
  def destroy
    @proyectominero3.destroy
    respond_to do |format|
      format.html { redirect_to proyectominero3s_url, notice: 'Proyectominero3 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proyectominero3
      @proyectominero3 = Proyectominero3.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proyectominero3_params
      params.require(:proyectominero3).permit(:code, :name, :user_id,:formatotexto,:formatofecha )
    end
end
