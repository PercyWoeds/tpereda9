require 'test_helper'

class AssistancesControllerTest < ActionController::TestCase
  setup do
    @assistance = assistances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assistances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assistance" do
    assert_difference('Assistance.count') do
      post :create, assistance: { cod_verificacion: @assistance.cod_verificacion, departamento: @assistance.departamento, equipo: @assistance.equipo, fecha: @assistance.fecha, nombre: @assistance.nombre, nro: @assistance.nro, num_tarjeta: @assistance.num_tarjeta }
    end

    assert_redirected_to assistance_path(assigns(:assistance))
  end

  test "should show assistance" do
    get :show, id: @assistance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assistance
    assert_response :success
  end

  test "should update assistance" do
    patch :update, id: @assistance, assistance: { cod_verificacion: @assistance.cod_verificacion, departamento: @assistance.departamento, equipo: @assistance.equipo, fecha: @assistance.fecha, nombre: @assistance.nombre, nro: @assistance.nro, num_tarjeta: @assistance.num_tarjeta }
    assert_redirected_to assistance_path(assigns(:assistance))
  end

  test "should destroy assistance" do
    assert_difference('Assistance.count', -1) do
      delete :destroy, id: @assistance
    end

    assert_redirected_to assistances_path
  end
end
