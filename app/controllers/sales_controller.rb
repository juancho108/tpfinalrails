class SalesController < ApplicationController
  include ApplicationHelper
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :confirm_sale, :cancel_sale, :movements, :close_sale]
  before_action :authenticate_user!

  # GET /sales
  # GET /sales.json
  def index
    @sales = Sale.all
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
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
        Sale.verificarCambios(previous_sale, @sale, current_user)
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
    Sale.anularVenta(@sale)
    @sale.destroy
    
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'La Venta ha sido eliminada con exito. El producto está en stock nuevamente.' }
      format.json { head :no_content }
    end
  end

  def confirm_sale

    @sale.update estado: "Concretada"
    @sale.copia.update estado_del_producto: "Vendido"

    #realiza las acciones correspondientes al concretar una venta
    Sale.accionesVentaConcretada(@sale, current_user)
    
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'La Venta se ha registrado con Exito.' }
    end
  end

  def cancel_sale

    Sale.anularVenta(@sale)
    
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'La Venta se ha Cancelado con Exito.' }
    end
  end

  def close_sale
    if @sale.movements.where('monto_neto > 0').count == @sale.movements.count
      Sale.accionesVentaConcretadaPagoParcial(@sale, current_user, cotizacion_dolar_libre.to_f)
      respond_to do |format|
        format.html { redirect_to sales_url, notice: 'La Venta se ha concretado con Exito.' }
      end
    end#sino redireccionar con mensaje de que no se puede cerrar la venta
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
