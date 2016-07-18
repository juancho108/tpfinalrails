class ProductsController < ApplicationController
  before_action :set_product, only: [:create_stock_complejo, :stock_complejo, :create_stock_simple, :stock_simple, :show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product , notice: 'Product was successfully created.' }# @products_path para ir a la tabla
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def stock_simple
    #muestra form para crear x copias para un producto
  end

  def stock_complejo
    #muestra el form stock complejo
  end

  def create_stock_simple
    #crea un numero especifico de COPIAS y solo se carga 1 vez.
  
    begin
      params[:cantidad].to_i.times do |i|
        Copy.create product_id: @product.id, lugar: params[:lugar], precio_compra: params[:precio_compra], packaging: params[:packaging], estado: params[:estado], estado_del_producto: "En Stock"
      end
    rescue
      redirect_to products_path, notice: 'Hubo un error creando las copias'
    end

    redirect_to products_path, notice: 'Copias creadas con exito'
  end

  def create_stock_complejo
    #crea un una copia compleja detallada
  
    begin
      Copy.create product_id: @product.id, lugar: params[:lugar], precio_compra: params[:precio_compra], packaging: params[:packaging], estado: params[:estado], estado_del_producto: "En Stock", descripcion: params[:descripcion], nro_serie: params[:nro_serie]
      rescue
      redirect_to stock_complejo_product_path, notice: 'Hubo un error creando las copias'
    end

    redirect_to stock_complejo_product_path, notice: 'Copia creada con exito'
  end



  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:nombre, :tipo_stock, :instruccion_general, :categoria, :category_id)
    end
    
end