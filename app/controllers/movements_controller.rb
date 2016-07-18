class MovementsController < ApplicationController
  before_action :set_movement, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  # GET /movements
  # GET /movements.json
  def index
    @movements = Movement.all
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
  end

  # POST /movements
  # POST /movements.json
  def create

    @movement = Movement.new(movement_params)
    @movement.persona = current_user.nombre+" "+current_user.apellido
    authorize @movement

    respond_to do |format|
      if @movement.save
        @movement.origen.dinero += @movement.monto_neto
        @movement.origen.save
        #Movement.verificarIngreso @movement
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
      
      if @movement.update(movement_params.merge(persona: current_user.nombre+" "+current_user.apellido))
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
    @movement.destroy
    respond_to do |format|
      format.html { redirect_to movements_url, notice: 'Movimiento borrado con exito.' }
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
      params.require(:movement).permit(:operacion, :tipo_operacion, :origen_id, :destino_id, :persona, :monto_neto, :fecha_operacion, :detalles_adicionales, :id)
    end
end
