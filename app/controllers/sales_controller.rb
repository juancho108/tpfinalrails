class SalesController < ApplicationController
  include ApplicationHelper
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :confirm_sale, :cancel_sale, :movements, :close_sale]
  before_action :authenticate_user!

  # GET /sales
  # GET /sales.json
  def index
    @sales = Sale.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
    if @sale.estado != "Concretada"
      redirect_to sales_path, alert: 'La Venta no ha sido concretada, esta accion no puede realizarse.' 
    end
  end

  # GET /sales/new
  def new
    @sale = Sale.new
  end

  # GET /sales/1/edit
  def edit
    @client = @sale.cliente
  end

  # POST /sales
  # POST /sales.json
  def create
    @sale = Sale.new(sale_params)

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1
  # PATCH/PUT /sales/1.json
  def update

    respond_to do |format|

      previous_sale = @sale
      
      if @sale.update(sale_params)

        @sale.cliente.update(client_params)
               
        #verifica si cambió el estado de la venta y realiza las acciones que corresponda
        Sale.verificar_cambios(previous_sale, @sale, current_user)
        #Sale.verificarCambioDeEstado(estado_anterior, @sale, current_user) if estado_anterior != @sale.estado
        
        format.html { redirect_to @sale, notice: 'Venta actualizada con exito.' }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    #realiza acciones necesarias para anular la venta
    Sale.anular_venta(@sale)
    @sale.destroy
    
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'La Venta ha sido eliminada con exito. El producto está en stock nuevamente.' }
      format.json { head :no_content }
    end
  end

  def confirm_sale

    #realiza las acciones correspondientes al concretar una venta
    Sale.acciones_venta_concretada_desde_pendiente(@sale, current_user)
    
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'La Venta se ha registrado con Exito.' }
    end
  end

  def cancel_sale

    Sale.anular_venta(@sale)
    
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'La Venta se ha Cancelado con Exito.' }
    end
  end

  def close_sale
    if @sale.movements.where('monto_neto > 0').count == @sale.movements.count
      Sale.acciones_venta_concretada_desde_pago_parcial(@sale, current_user)
      respond_to do |format|
        format.html { redirect_to sales_url, notice: 'La Venta se ha concretado con Exito.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to sales_url, alert: 'No se ha podido cerrar la venta.' }
      end
    end
  end

  def movements

    @show_close_sale_button = @sale.movements.where('monto_neto > 0').count == @sale.movements.count
    if @sale.estado != "Pago Parcial"
      respond_to do |format|
      format.html { redirect_to sales_url, alert: 'La Venta no posee pagos paciales.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:precio_bruto, :precio_neto, :forma_de_pago_id, :usuario_id, :ganancia, :copy_id, :client_id, :origin_sale_id, :estado)
    end

    def client_params
      params.require(:client).permit(:nombre, :mail, :detalle_adicional)
    end

end
