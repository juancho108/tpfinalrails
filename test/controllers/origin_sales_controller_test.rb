require 'test_helper'

class OriginSalesControllerTest < ActionController::TestCase
  setup do
    @origin_sale = origin_sales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:origin_sales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create origin_sale" do
    assert_difference('OriginSale.count') do
      post :create, origin_sale: { monto_bruto: @origin_sale.monto_bruto, monto_neto: @origin_sale.monto_neto, nombre: @origin_sale.nombre }
    end

    assert_redirected_to origin_sale_path(assigns(:origin_sale))
  end

  test "should show origin_sale" do
    get :show, id: @origin_sale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @origin_sale
    assert_response :success
  end

  test "should update origin_sale" do
    patch :update, id: @origin_sale, origin_sale: { monto_bruto: @origin_sale.monto_bruto, monto_neto: @origin_sale.monto_neto, nombre: @origin_sale.nombre }
    assert_redirected_to origin_sale_path(assigns(:origin_sale))
  end

  test "should destroy origin_sale" do
    assert_difference('OriginSale.count', -1) do
      delete :destroy, id: @origin_sale
    end

    assert_redirected_to origin_sales_path
  end
end
