class MovementsController < ApplicationController
  before_action :set_movement, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  # GET /movements
  # GET /movements.json
  def index
    @movements = Movement.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
    authorize @movements
  end

  # GET /movements/1
  # GET /movements/1.json
  def show
    authorize @movement
  end

  # GET /movements/new
  def new
    @movement = Movement.new
    authorize @movement
  end

  # GET /movements/1/edit
  def edit
    authorize @movement
    if @movement.tipo_operacion == "Venta"
      @inputs_pago_parcial = @movement.venta.cantidad_de_pagos > 1
    end
  end

  # POST /movements
  # POST /movements.json
  def create

    @movement = Movement.new(movement_params)
    @movement.persona = current_user.nombre+" "+current_user.apellido
    authorize @movement

    respond_to do |format|
      if @movement.save
        @movement.sumar_dinero 
        
        @movement.verificar_ingreso current_user
        format.html { redirect_to @movement, notice: 'Movimiento creado con exito.' }
        format.json { render :show, status: :created, location: @movement }
      else
        format.html { render :new }
        format.json { render json: @movement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movements/1
  # PATCH/PUT /movements/1.json
  def update
    authorize @movement
    respond_to do |format|

      if @movement.tipo_operacion != "Venta"
        @movement.revertir 
      end
      if @movement.update(movement_params.merge(persona: current_user.nombre+" "+current_user.apellido))
        if @movement.tipo_operacion == "Venta"
          @movement.verificar_monto_bruto
          format.html { redirect_to movements_sale_path(@movement.sale_id), notice: 'Movimiento modificado con exito.' }
        else
          @movement.editar_movimientos_de_dinero current_user
        end
        format.html { redirect_to @movement, notice: 'Movimiento modificado con exito.' }
        format.json { render :show, status: :ok, location: @movement }
      else
        format.html { render :edit }
        format.json { render json: @movement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movements/1
  # DELETE /movements/1.json
  def destroy
    authorize @movement
    @movement.revertir 
    @movement.destroy
    respond_to do |format|
      format.html { redirect_to movements_url, notice: 'Movimiento borrado con exito. El dinero se ha regresado con exito' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movement
      @movement = Movement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movement_params
      params.require(:movement).permit(:operacion, :tipo_operacion, :origen_id, :destino_id, :persona, :monto_neto, :monto_bruto, :fecha_operacion, :detalles_adicionales, :id)
    end
end

