class HorasMesController < ApplicationController
  before_action :set_horas_me, only: [:show, :edit, :update, :destroy]

  # GET /horas_mes
  # GET /horas_mes.json
  def index
    @horas_mes = HorasMe.all
  end

  # GET /horas_mes/1
  # GET /horas_mes/1.json
  def show
  end

  # GET /horas_mes/new
  def new
    @horas_me = HorasMe.new
    @payrolls = Payroll.all 
    @employees = Employee.where(:planilla=> "1").order(:lastname)
    @horas_me[:tot] = 0
    @horas_me[:dt] = 0
    @horas_me[:fal] = 0
    @horas_me[:sub] = 0
    @horas_me[:dm] = 0
    @horas_me[:pat] = 0  
    @horas_me[:vac] = 0
  end

  # GET /horas_mes/1/edit
  def edit
    @payrolls = Payroll.all 
    @employees = Employee.where(:planilla=> "1").order(:lastname)
    
  end

  # POST /horas_mes
  # POST /horas_mes.json
  def create
    @payrolls = Payroll.all 
    @employees = Employee.where(:planilla=> "1").order(:lastname)
    
    @horas_me = HorasMe.new(horas_me_params)
    @horas_me[:tot] = @horas_me[:dt]+ @horas_me[:fal]+@horas_me[:sub]+@horas_me[:dm]+@horas_me[:pat]  +@horas_me[:vac] 
    

    respond_to do |format|
      if @horas_me.save
        format.html { redirect_to @horas_me, notice: 'Horas me was successfully created.' }
        format.json { render :show, status: :created, location: @horas_me }
      else
        format.html { render :new }
        format.json { render json: @horas_me.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /horas_mes/1
  # PATCH/PUT /horas_mes/1.json
  def update
    respond_to do |format|
      if @horas_me.update(horas_me_params)
        format.html { redirect_to @horas_me, notice: 'Horas me was successfully updated.' }
        format.json { render :show, status: :ok, location: @horas_me }
      else
        format.html { render :edit }
        format.json { render json: @horas_me.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /horas_mes/1
  # DELETE /horas_mes/1.json
  def destroy
    @horas_me.destroy
    respond_to do |format|
      format.html { redirect_to horas_mes_url, notice: 'Horas me was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_horas_me
      @horas_me = HorasMe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def horas_me_params
      params.require(:horas_me).permit(:dt, :fal, :sub, :dm, :pat, :vac, :tot, :payroll_id, :employee_id)
    end
end
