class ProgramExamenController < ApplicationController
  before_action :set_program_examan, only: [:show, :edit, :update, :destroy]

  # GET /program_examen
  # GET /program_examen.json
  def index
    @program_examen = ProgramExaman.all
  end

  # GET /program_examen/1
  # GET /program_examen/1.json
  def show
  end

  # GET /program_examen/new
  def new
    @program_examan = ProgramExaman.new
  end

  # GET /program_examen/1/edit
  def edit
  end

  # POST /program_examen
  # POST /program_examen.json
  def create
    @program_examan = ProgramExaman.new(program_examan_params)

    respond_to do |format|
      if @program_examan.save
        format.html { redirect_to @program_examan, notice: 'Program examan was successfully created.' }
        format.json { render :show, status: :created, location: @program_examan }
      else
        format.html { render :new }
        format.json { render json: @program_examan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /program_examen/1
  # PATCH/PUT /program_examen/1.json
  def update
    respond_to do |format|
      if @program_examan.update(program_examan_params)
        format.html { redirect_to @program_examan, notice: 'Program examan was successfully updated.' }
        format.json { render :show, status: :ok, location: @program_examan }
      else
        format.html { render :edit }
        format.json { render json: @program_examan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /program_examen/1
  # DELETE /program_examen/1.json
  def destroy
    @program_examan.destroy
    respond_to do |format|
      format.html { redirect_to program_examen_url, notice: 'Program examan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program_examan
      @program_examan = ProgramExaman.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def program_examan_params
      params.require(:program_examan).permit(:fecha, :code, :processed, :date_processed)
    end
end
