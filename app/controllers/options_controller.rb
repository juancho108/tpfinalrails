class OptionsController < ApplicationController
  before_action :set_option, only: [:show, :edit, :update, :destroy, :resetear_cuentas_ml, :actualizar_valor_dolar]
  before_action :authenticate_user!

  # GET /options
  # GET /options.json
  def index
    @options = Option.all
    authorize @options
  end

  # GET /options/1
  # GET /options/1.json
  def show
    authorize @option
  end

  # GET /options/new
  def new
    @option = Option.new
    authorize @option
  end

  # GET /options/1/edit
  def edit
    authorize @option
  end

  # POST /options
  # POST /options.json
  def create
    @option = Option.new(option_params)
    authorize @option

    respond_to do |format|
      if @option.save
        format.html { redirect_to @option, notice: 'option was successfully created.' }
        format.json { render :show, status: :created, location: @option }
      else
        format.html { render :new }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /options/1
  # PATCH/PUT /options/1.json
  def update
    authorize @option
    respond_to do |format|
      if @option.update(option_params)
        format.html { redirect_to edit_option_path(@option), notice: 'Opciones de configuracion editadas correctamente.' }
        format.json { render :show, status: :ok, location: @option }
      else
        format.html { render :edit }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /options/1
  # DELETE /options/1.json
  def destroy
    authorize @option
    @option.destroy
    respond_to do |format|
      format.html { redirect_to options_url, notice: 'option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def resetear_cuentas_ml
    authorize @option
    OriginSale.resetear_cuentas
    redirect_to "/options/1/edit", notice:"Cuentas de ML actualizadas con exito"
  end

  def actualizar_valor_dolar
    authorize @option
    Option.actualizar_valor_dolar
    redirect_to "/options/1/edit", notice:"Dolar actualizado con exito"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_option
      @option = Option.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def option_params
      params.require(:option).permit(:dolar_libre, :dolar_blue, :porcentaje_mercadolibre, :porcentaje_mercadopago, :porcentaje_ml_mp, :skin, :limite)
    end
end
