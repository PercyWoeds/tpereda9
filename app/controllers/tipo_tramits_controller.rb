class TipoTramitsController < ApplicationController
  before_action :set_tipo_tramit, only: [:show, :edit, :update, :destroy]

  # GET /tipo_tramits
  # GET /tipo_tramits.json
  def index
    @tipo_tramits = TipoTramit.all
  end

  # GET /tipo_tramits/1
  # GET /tipo_tramits/1.json
  def show
  end

  # GET /tipo_tramits/new
  def new
    @tipo_tramit = TipoTramit.new
  end

  # GET /tipo_tramits/1/edit
  def edit
  end

  # POST /tipo_tramits
  # POST /tipo_tramits.json
  def create
    @tipo_tramit = TipoTramit.new(tipo_tramit_params)

    respond_to do |format|
      if @tipo_tramit.save
        format.html { redirect_to @tipo_tramit, notice: 'Tipo tramit was successfully created.' }
        format.json { render :show, status: :created, location: @tipo_tramit }
      else
        format.html { render :new }
        format.json { render json: @tipo_tramit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_tramits/1
  # PATCH/PUT /tipo_tramits/1.json
  def update
    respond_to do |format|
      if @tipo_tramit.update(tipo_tramit_params)
        format.html { redirect_to @tipo_tramit, notice: 'Tipo tramit was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipo_tramit }
      else
        format.html { render :edit }
        format.json { render json: @tipo_tramit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_tramits/1
  # DELETE /tipo_tramits/1.json
  def destroy
    @tipo_tramit.destroy
    respond_to do |format|
      format.html { redirect_to tipo_tramits_url, notice: 'Tipo tramit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_tramit
      @tipo_tramit = TipoTramit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_tramit_params
      params.require(:tipo_tramit).permit(:code, :name)
    end
end
