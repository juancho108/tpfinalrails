class OriginSalesController < ApplicationController
  before_action :set_origin_sale, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /origin_sales
  # GET /origin_sales.json
  def index
    @origin_sales = OriginSale.all
  end

  # GET /origin_sales/1
  # GET /origin_sales/1.json
  def show
    authorize @origin_sale
  end

  # GET /origin_sales/new
  def new
    @origin_sale = OriginSale.new
    authorize @origin_sale
  end

  # GET /origin_sales/1/edit
  def edit
    authorize @origin_sale
  end

  # POST /origin_sales
  # POST /origin_sales.json
  def create
    @origin_sale = OriginSale.new(origin_sale_params)
    authorize @origin_sale
    respond_to do |format|
      if @origin_sale.save
        format.html { redirect_to @origin_sale, notice: 'Origin sale was successfully created.' }
        format.json { render :show, status: :created, location: @origin_sale }
      else
        format.html { render :new }
        format.json { render json: @origin_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /origin_sales/1
  # PATCH/PUT /origin_sales/1.json
  def update
    authorize @origin_sale
    respond_to do |format|
      if @origin_sale.update(origin_sale_params)
        format.html { redirect_to @origin_sale, notice: 'Origin sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @origin_sale }
      else
        format.html { render :edit }
        format.json { render json: @origin_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /origin_sales/1
  # DELETE /origin_sales/1.json
  def destroy
    authorize @origin_sale
    @origin_sale.destroy
    respond_to do |format|
      format.html { redirect_to origin_sales_url, notice: 'Origin sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_origin_sale
      @origin_sale = OriginSale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def origin_sale_params
      params.require(:origin_sale).permit(:nombre, :monto_bruto, :monto_neto, :tipo)
    end
end
