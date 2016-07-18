class FinancesController < ApplicationController
  before_action :set_finance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /finances
  # GET /finances.json
  def index
    @finances = Finance.all
    authorize @finances
  end

  # GET /finances/1
  # GET /finances/1.json
  def show
    authorize @finance
  end

  # GET /finances/new
  def new
    @finance = Finance.new
    authorize @finance
  end

  # GET /finances/1/edit
  def edit
    authorize @finance
  end

  # POST /finances
  # POST /finances.json
  def create
    @finance = Finance.new(finance_params)
    authorize @finance

    respond_to do |format|
      if @finance.save
        format.html { redirect_to @finance, notice: 'Caja creada con exito.' }
        format.json { render :show, status: :created, location: @finance }
      else
        format.html { render :new }
        format.json { render json: @finance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /finances/1
  # PATCH/PUT /finances/1.json
  def update
    authorize @finance
    respond_to do |format|
      if @finance.update(finance_params)
        format.html { redirect_to @finance, notice: 'Caja modificada con exito.' }
        format.json { render :show, status: :ok, location: @finance }
      else
        format.html { render :edit }
        format.json { render json: @finance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /finances/1
  # DELETE /finances/1.json
  def destroy
    authorize @finance
    @finance.destroy
    respond_to do |format|
      format.html { redirect_to finances_url, notice: 'Caja eliminada con exito.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_finance
      @finance = Finance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def finance_params
      params.require(:finance).permit(:nombre, :dinero)
    end
end
