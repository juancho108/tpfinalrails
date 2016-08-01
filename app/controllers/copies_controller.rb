class CopiesController < ApplicationController
  include ApplicationHelper
  before_action :set_copy, :load_product, only: [:show, :edit, :update, :destroy, :sale, :create_sale]
  before_action :authenticate_user!
  before_filter :load_product

  # GET /copies
  # GET /copies.json
  def index
    @copies = @product.copias.all.select{|c| c.estado_del_producto != "Vendido"}
    #@copies = Copy.all
  end

  # GET /copies/1
  # GET /copies/1.json
  def show
    @copy = @product.copias.find(params[:id])
  end

  # GET /copies/new
  def new
    @copy = @product.copias.new
  end

  # GET /copies/1/edit
  def edit
    @copy = @product.copias.find(params[:id])
  end

  # POST /copies
  # POST /copies.json
  def create
    @copy = @product.copias.new(copy_params)

    respond_to do |format|
      if @copy.save
        format.html { redirect_to [@product, @copy], notice: 'Item creada con exito.' }
        format.json { render :show, status: :created, location: @copy }
      else
        format.html { render :new }
        format.json { render json: @copy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /copies/1
  # PATCH/PUT /copies/1.json
  def update
    #@copy = @product.copias.find(params[:id]) 
    respond_to do |format|
      if @copy.update(copy_params)
        format.html { redirect_to product_copies_path(@product), notice: 'Item moficado con exito.' }
        format.json { render :show, status: :ok, location: @copy }
      else
        format.html { render :edit }
        format.json { render json: @copy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /copies/1
  # DELETE /copies/1.json
  def destroy
    @copy.destroy
    respond_to do |format|
      format.html { redirect_to product_copies_path(@product), notice: 'Item borrado con exito.' }
      format.json { head :no_content }
    end
  end

  def sale
    #muestra form para crear la venta de una copia
  end

  def create_sale
    #crear nueva venta en el modelo , despeja el controlaor
    Sale.crearVenta(params, @copy, cotizacion_dolar_libre.to_f, current_user)

      
    begin
    rescue
     # redirect_to sales_path, notice: 'Hubo un error creando la venta'
    end

    redirect_to sales_path, notice: 'Venta creada con exito'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_copy
      @copy = Copy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def copy_params
      params.require(:copy).permit(:lugar, :precio_compra, :packaging, :estado_del_producto, :estado, :nro_serie, :descripcion, :forma_de_pago_id)
    end

    def load_product
      @product = Product.find(params[:product_id])
    end

end
