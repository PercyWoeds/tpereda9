class TecnicRevisionsController < ApplicationController
  before_action :set_tecnic_revision, only: [:show, :edit, :update, :destroy]

  # GET /tecnic_revisions
  # GET /tecnic_revisions.json
  def index
    @tecnic_revisions = TecnicRevision.all
  end

  # GET /tecnic_revisions/1
  # GET /tecnic_revisions/1.json
  def show
  end

  # GET /tecnic_revisions/new
  def new
    @tecnic_revision = TecnicRevision.new
  end

  # GET /tecnic_revisions/1/edit
  def edit
  end

  # POST /tecnic_revisions
  # POST /tecnic_revisions.json
  def create
    @tecnic_revision = TecnicRevision.new(tecnic_revision_params)

    respond_to do |format|
      if @tecnic_revision.save
        format.html { redirect_to @tecnic_revision, notice: 'Tecnic revision was successfully created.' }
        format.json { render :show, status: :created, location: @tecnic_revision }
      else
        format.html { render :new }
        format.json { render json: @tecnic_revision.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tecnic_revisions/1
  # PATCH/PUT /tecnic_revisions/1.json
  def update
    respond_to do |format|
      if @tecnic_revision.update(tecnic_revision_params)
        format.html { redirect_to @tecnic_revision, notice: 'Tecnic revision was successfully updated.' }
        format.json { render :show, status: :ok, location: @tecnic_revision }
      else
        format.html { render :edit }
        format.json { render json: @tecnic_revision.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tecnic_revisions/1
  # DELETE /tecnic_revisions/1.json
  def destroy
    @tecnic_revision.destroy
    respond_to do |format|
      format.html { redirect_to tecnic_revisions_url, notice: 'Tecnic revision was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tecnic_revision
      @tecnic_revision = TecnicRevision.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tecnic_revision_params
      params.require(:tecnic_revision).permit(:code, :name)
    end
end
