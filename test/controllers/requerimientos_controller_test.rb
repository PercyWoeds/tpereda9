require 'test_helper'

class RequerimientosControllerTest < ActionController::TestCase
  setup do
    @requerimiento = requerimientos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:requerimientos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create requerimiento" do
    assert_difference('Requerimiento.count') do
      post :create, requerimiento: { cantidad_1: @requerimiento.cantidad_1, code: @requerimiento.code, codigo_1: @requerimiento.codigo_1, descrip_1: @requerimiento.descrip_1, descrip_1: @requerimiento.descrip_1, division_id: @requerimiento.division_id, employee_id: @requerimiento.employee_id, fecha: @requerimiento.fecha, hora: @requerimiento.hora, item_1: @requerimiento.item_1, nota: @requerimiento.nota, observa: @requerimiento.observa, placa_1: @requerimiento.placa_1, unidad_1: @requerimiento.unidad_1 }
    end

    assert_redirected_to requerimiento_path(assigns(:requerimiento))
  end

  test "should show requerimiento" do
    get :show, id: @requerimiento
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @requerimiento
    assert_response :success
  end

  test "should update requerimiento" do
    patch :update, id: @requerimiento, requerimiento: { cantidad_1: @requerimiento.cantidad_1, code: @requerimiento.code, codigo_1: @requerimiento.codigo_1, descrip_1: @requerimiento.descrip_1, descrip_1: @requerimiento.descrip_1, division_id: @requerimiento.division_id, employee_id: @requerimiento.employee_id, fecha: @requerimiento.fecha, hora: @requerimiento.hora, item_1: @requerimiento.item_1, nota: @requerimiento.nota, observa: @requerimiento.observa, placa_1: @requerimiento.placa_1, unidad_1: @requerimiento.unidad_1 }
    assert_redirected_to requerimiento_path(assigns(:requerimiento))
  end

  test "should destroy requerimiento" do
    assert_difference('Requerimiento.count', -1) do
      delete :destroy, id: @requerimiento
    end

    assert_redirected_to requerimientos_path
  end
end
