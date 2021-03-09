require 'test_helper'

class AutoviaticsControllerTest < ActionController::TestCase
  setup do
    @autoviatic = autoviatics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:autoviatics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create autoviatic" do
    assert_difference('Autoviatic.count') do
      post :create, autoviatic: { almuerzo: @autoviatic.almuerzo, asunto: @autoviatic.asunto, date_processed: @autoviatic.date_processed, employee_id: @autoviatic.employee_id, fecha: @autoviatic.fecha, hora_ingreso: @autoviatic.hora_ingreso, hora_salida: @autoviatic.hora_salida, location_id: @autoviatic.location_id, lugar1: @autoviatic.lugar1, lugar2: @autoviatic.lugar2, lugar3: @autoviatic.lugar3, lugar_salida2: @autoviatic.lugar_salida2, lugar_salida: @autoviatic.lugar_salida, movilidad: @autoviatic.movilidad, obser2: @autoviatic.obser2, obser: @autoviatic.obser, otros: @autoviatic.otros, processed: @autoviatic.processed, proyecto_minerdo_id: @autoviatic.proyecto_minerdo_id, supplier_id: @autoviatic.supplier_id, tema: @autoviatic.tema, tramit_id: @autoviatic.tramit_id }
    end

    assert_redirected_to autoviatic_path(assigns(:autoviatic))
  end

  test "should show autoviatic" do
    get :show, id: @autoviatic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @autoviatic
    assert_response :success
  end

  test "should update autoviatic" do
    patch :update, id: @autoviatic, autoviatic: { almuerzo: @autoviatic.almuerzo, asunto: @autoviatic.asunto, date_processed: @autoviatic.date_processed, employee_id: @autoviatic.employee_id, fecha: @autoviatic.fecha, hora_ingreso: @autoviatic.hora_ingreso, hora_salida: @autoviatic.hora_salida, location_id: @autoviatic.location_id, lugar1: @autoviatic.lugar1, lugar2: @autoviatic.lugar2, lugar3: @autoviatic.lugar3, lugar_salida2: @autoviatic.lugar_salida2, lugar_salida: @autoviatic.lugar_salida, movilidad: @autoviatic.movilidad, obser2: @autoviatic.obser2, obser: @autoviatic.obser, otros: @autoviatic.otros, processed: @autoviatic.processed, proyecto_minerdo_id: @autoviatic.proyecto_minerdo_id, supplier_id: @autoviatic.supplier_id, tema: @autoviatic.tema, tramit_id: @autoviatic.tramit_id }
    assert_redirected_to autoviatic_path(assigns(:autoviatic))
  end

  test "should destroy autoviatic" do
    assert_difference('Autoviatic.count', -1) do
      delete :destroy, id: @autoviatic
    end

    assert_redirected_to autoviatics_path
  end
end
