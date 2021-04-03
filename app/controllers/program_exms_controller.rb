class ProgramExmsController < ApplicationController
  before_action :set_program_exm, only: [:show, :edit, :update, :destroy]

  # GET /program_exms
  # GET /program_exms.json
  def index
    @program_exms = ProgramExm.all
  end

  # GET /program_exms/1
  # GET /program_exms/1.json
  def show
  end

  # GET /program_exms/new
  def new
    @program_exm = ProgramExm.new
  end

  # GET /program_exms/1/edit
  def edit
  end

  # POST /program_exms
  # POST /program_exms.json
  def create
    @program_exm = ProgramExm.new(program_exm_params)

    respond_to do |format|
      if @program_exm.save
        format.html { redirect_to @program_exm, notice: 'Program exm was successfully created.' }
        format.json { render :show, status: :created, location: @program_exm }
      else
        format.html { render :new }
        format.json { render json: @program_exm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /program_exms/1
  # PATCH/PUT /program_exms/1.json
  def update
    respond_to do |format|
      if @program_exm.update(program_exm_params)
        format.html { redirect_to @program_exm, notice: 'Program exm was successfully updated.' }
        format.json { render :show, status: :ok, location: @program_exm }
      else
        format.html { render :edit }
        format.json { render json: @program_exm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /program_exms/1
  # DELETE /program_exms/1.json
  def destroy
    @program_exm.destroy
    respond_to do |format|
      format.html { redirect_to program_exms_url, notice: 'Program exm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program_exm
      @program_exm = ProgramExm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def program_exm_params
      params.require(:program_exm).permit(:employee_id, :ind, :tr, :em, :lo, :tema, :fecha, :inicio, :termino, :totalhora, :horaingbase, :observa)
    end
end
