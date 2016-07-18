class RecordsController < ApplicationController
  before_action :set_record, :load_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_filter :load_product

  # GET /records
  # GET /records.json
  def index
    @records = @product.registros.all
  end

  # GET /records/1
  # GET /records/1.json
  def show
    @record = @product.registros.find(params[:id])
  end

  # GET /records/new
  def new
    @record = @product.registros.new
  end

  # GET /records/1/edit
  def edit
    @record = @product.registros.find(params[:id])
  end

  # POST /records
  # POST /records.json
  def create
    @record = @product.registros.new(record_params)
    #actualizo orden
    orden = if @record.orden == nil then 0 else @record.orden+1 end
    @record.orden = orden


    respond_to do |format|
      if @record.save
        format.html { redirect_to products_path, notice: 'Registro creado con exito.' }
        format.json { render :show, status: :created, location: @record }
      else
        format.html { render :new }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to products_path, notice: 'Registro modificado con exito.' }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:cuenta_ml_id, :estado, :orden)
    end

    def load_product
      @product = Product.find(params[:product_id])
    end
end
