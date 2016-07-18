require 'test_helper'

class MovementsControllerTest < ActionController::TestCase
  setup do
    @movement = movements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movement" do
    assert_difference('Movement.count') do
      post :create, movement: { detalles_adicionales: @movement.detalles_adicionales, fecha_operacion: @movement.fecha_operacion, forma_de_pago: @movement.forma_de_pago, monto_neto: @movement.monto_neto, operacion: @movement.operacion, persona: @movement.persona, tipo_operacion: @movement.tipo_operacion }
    end

    assert_redirected_to movement_path(assigns(:movement))
  end

  test "should show movement" do
    get :show, id: @movement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movement
    assert_response :success
  end

  test "should update movement" do
    patch :update, id: @movement, movement: { detalles_adicionales: @movement.detalles_adicionales, fecha_operacion: @movement.fecha_operacion, forma_de_pago: @movement.forma_de_pago, monto_neto: @movement.monto_neto, operacion: @movement.operacion, persona: @movement.persona, tipo_operacion: @movement.tipo_operacion }
    assert_redirected_to movement_path(assigns(:movement))
  end

  test "should destroy movement" do
    assert_difference('Movement.count', -1) do
      delete :destroy, id: @movement
    end

    assert_redirected_to movements_path
  end
end
