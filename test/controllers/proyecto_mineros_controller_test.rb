require 'test_helper'

class ProyectoMinerosControllerTest < ActionController::TestCase
  setup do
    @proyecto_minero = proyecto_mineros(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proyecto_mineros)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proyecto_minero" do
    assert_difference('ProyectoMinero.count') do
      post :create, proyecto_minero: { code: @proyecto_minero.code, descrip: @proyecto_minero.descrip, fecha1: @proyecto_minero.fecha1, fecha2: @proyecto_minero.fecha2, punto_id: @proyecto_minero.punto_id }
    end

    assert_redirected_to proyecto_minero_path(assigns(:proyecto_minero))
  end

  test "should show proyecto_minero" do
    get :show, id: @proyecto_minero
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proyecto_minero
    assert_response :success
  end

  test "should update proyecto_minero" do
    patch :update, id: @proyecto_minero, proyecto_minero: { code: @proyecto_minero.code, descrip: @proyecto_minero.descrip, fecha1: @proyecto_minero.fecha1, fecha2: @proyecto_minero.fecha2, punto_id: @proyecto_minero.punto_id }
    assert_redirected_to proyecto_minero_path(assigns(:proyecto_minero))
  end

  test "should destroy proyecto_minero" do
    assert_difference('ProyectoMinero.count', -1) do
      delete :destroy, id: @proyecto_minero
    end

    assert_redirected_to proyecto_mineros_path
  end
end
