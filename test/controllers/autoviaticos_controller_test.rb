require 'test_helper'

class AutoviaticosControllerTest < ActionController::TestCase
  setup do
    @autoviatico = autoviaticos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:autoviaticos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create autoviatico" do
    assert_difference('Autoviatico.count') do
      post :create, autoviatico: { almuerzo: @autoviatico.almuerzo, asunto: @autoviatico.asunto, code: @autoviatico.code, employee_id2: @autoviatico.employee_id2, employee_id: @autoviatico.employee_id, fecha: @autoviatico.fecha, hora1: @autoviatico.hora1, hora2: @autoviatico.hora2, hora_ingreso: @autoviatico.hora_ingreso, hora_salida: @autoviatico.hora_salida, lugar_destino: @autoviatico.lugar_destino, lugar_salida: @autoviatico.lugar_salida, movilidad: @autoviatico.movilidad, observa2: @autoviatico.observa2, observa: @autoviatico.observa, otros: @autoviatico.otros, supplier_id: @autoviatico.supplier_id, tema: @autoviatico.tema }
    end

    assert_redirected_to autoviatico_path(assigns(:autoviatico))
  end

  test "should show autoviatico" do
    get :show, id: @autoviatico
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @autoviatico
    assert_response :success
  end

  test "should update autoviatico" do
    patch :update, id: @autoviatico, autoviatico: { almuerzo: @autoviatico.almuerzo, asunto: @autoviatico.asunto, code: @autoviatico.code, employee_id2: @autoviatico.employee_id2, employee_id: @autoviatico.employee_id, fecha: @autoviatico.fecha, hora1: @autoviatico.hora1, hora2: @autoviatico.hora2, hora_ingreso: @autoviatico.hora_ingreso, hora_salida: @autoviatico.hora_salida, lugar_destino: @autoviatico.lugar_destino, lugar_salida: @autoviatico.lugar_salida, movilidad: @autoviatico.movilidad, observa2: @autoviatico.observa2, observa: @autoviatico.observa, otros: @autoviatico.otros, supplier_id: @autoviatico.supplier_id, tema: @autoviatico.tema }
    assert_redirected_to autoviatico_path(assigns(:autoviatico))
  end

  test "should destroy autoviatico" do
    assert_difference('Autoviatico.count', -1) do
      delete :destroy, id: @autoviatico
    end

    assert_redirected_to autoviaticos_path
  end
end
