class Proyectominero2sController < ApplicationController
  before_action :set_proyectominero2, only: [:show, :edit, :update, :destroy]

  # GET /proyectominero2s
  # GET /proyectominero2s.json
  def index
    @proyectominero2s = Proyectominero2.all
  end

  # GET /proyectominero2s/1
  # GET /proyectominero2s/1.json
  def show
  end

  # GET /proyectominero2s/new
  def new
    @proyectominero2 = Proyectominero2.new
    @user_id = @current_user.id  
  end

  # GET /proyectominero2s/1/edit
  def edit
  end

  # POST /proyectominero2s
  # POST /proyectominero2s.json
  def create

    @proyectominero2 = Proyectominero2.new(proyectominero2_params)
    @proyectominero2[:user_id] = @user_id 
   puts @proyectominero2[:user_id]
    respond_to do |format|
      if @proyectominero2.save
        format.html { redirect_to @proyectominero2, notice: 'Proyectominero2 was successfully created.' }
        format.json { render :show, status: :created, location: @proyectominero2 }
      else
        format.html { render :new }
        format.json { render json: @proyectominero2.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proyectominero2s/1
  # PATCH/PUT /proyectominero2s/1.json
  def update
    respond_to do |format|
      if @proyectominero2.update(proyectominero2_params)
        format.html { redirect_to @proyectominero2, notice: 'Proyectominero2 was successfully updated.' }
        format.json { render :show, status: :ok, location: @proyectominero2 }
      else
        format.html { render :edit }
        format.json { render json: @proyectominero2.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proyectominero2s/1
  # DELETE /proyectominero2s/1.json
  def destroy
    @proyectominero2.destroy
    respond_to do |format|
      format.html { redirect_to proyectominero2s_url, notice: 'Proyectominero2 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proyectominero2
      @proyectominero2 = Proyectominero2.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proyectominero2_params
      params.require(:proyectominero2).permit(:code, :name, :user_id)
    end
end
